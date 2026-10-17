const DB_NAME = "VencordFavoriteGifCache";
const DB_VERSION = 1;
const BLOBS = "blobs";
const META = "meta";
const FLUSH_DELAY = 30_000;

interface Meta {
    size: number;
    lastUsed: number;
}

export const index = new Map<string, Meta>();

let db: IDBDatabase | undefined;
const dirty = new Set<string>();
let flushTimer: ReturnType<typeof setTimeout> | undefined;

function promisify<T>(req: IDBRequest<T>) {
    return new Promise<T>((resolve, reject) => {
        req.onsuccess = () => resolve(req.result);
        req.onerror = () => reject(req.error);
    });
}

function settled(tx: IDBTransaction) {
    return new Promise<void>((resolve, reject) => {
        tx.oncomplete = () => resolve();
        tx.onerror = tx.onabort = () => reject(tx.error);
    });
}

export async function open() {
    const req = indexedDB.open(DB_NAME, DB_VERSION);
    req.onupgradeneeded = () => {
        const upgrading = req.result;
        if (!upgrading.objectStoreNames.contains(BLOBS)) upgrading.createObjectStore(BLOBS);
        if (!upgrading.objectStoreNames.contains(META)) upgrading.createObjectStore(META);
    };

    db = await promisify(req);

    const store = db.transaction(META, "readonly").objectStore(META);
    const [keys, metas] = await Promise.all([promisify(store.getAllKeys()), promisify(store.getAll())]);

    index.clear();
    keys.forEach((key, i) => index.set(String(key), metas[i]));
}

// detaches before awaiting so a restart's open() isn't closed by this
export async function close() {
    if (flushTimer !== undefined) clearTimeout(flushTimer);
    flushTimer = undefined;

    const handle = db;
    db = undefined;
    const flushed = flush(handle);
    index.clear();

    await flushed.catch(() => { });
    handle?.close();
}

async function flush(handle = db) {
    if (!handle || !dirty.size) return;

    const tx = handle.transaction(META, "readwrite");
    for (const key of dirty) {
        const meta = index.get(key);
        if (meta) tx.objectStore(META).put({ ...meta }, key);
    }
    dirty.clear();

    await settled(tx);
}

function touch(key: string) {
    const meta = index.get(key);
    if (!meta) return;

    meta.lastUsed = Date.now();
    dirty.add(key);

    flushTimer ??= setTimeout(() => {
        flushTimer = undefined;
        void flush();
    }, FLUSH_DELAY);
}

export async function read(key: string) {
    if (!db) return;

    const blob = await promisify(db.transaction(BLOBS, "readonly").objectStore(BLOBS).get(key)) as Blob | undefined;
    if (blob) touch(key);

    return blob;
}

export async function write(key: string, blob: Blob) {
    if (!db) return;

    const meta: Meta = { size: blob.size, lastUsed: Date.now() };

    const tx = db.transaction([BLOBS, META], "readwrite");
    tx.objectStore(BLOBS).put(blob, key);
    tx.objectStore(META).put(meta, key);
    await settled(tx);

    index.set(key, meta);
}

export async function remove(keys: string[]) {
    if (!db || !keys.length) return;

    const tx = db.transaction([BLOBS, META], "readwrite");
    for (const key of keys) {
        tx.objectStore(BLOBS).delete(key);
        tx.objectStore(META).delete(key);
        index.delete(key);
        dirty.delete(key);
    }

    await settled(tx);
}

export async function clear() {
    if (!db) return;

    const tx = db.transaction([BLOBS, META], "readwrite");
    tx.objectStore(BLOBS).clear();
    tx.objectStore(META).clear();
    await settled(tx);

    index.clear();
    dirty.clear();
}

export function size() {
    let total = 0;
    for (const meta of index.values()) total += meta.size;
    return total;
}

export async function evict(maxBytes: number) {
    let total = size();
    if (total <= maxBytes) return;

    const doomed: string[] = [];
    for (const [key, meta] of [...index].sort(([, a], [, b]) => a.lastUsed - b.lastUsed)) {
        if (total <= maxBytes) break;
        doomed.push(key);
        total -= meta.size;
    }

    await remove(doomed);
}
