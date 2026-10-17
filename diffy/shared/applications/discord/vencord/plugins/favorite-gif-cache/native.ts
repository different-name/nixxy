import { IpcMainInvokeEvent } from "electron";

// the renderer csp blocks some gif hosts
export async function fetchMedia(_: IpcMainInvokeEvent, url: string) {
    if (!/^https?:\/\//.test(url)) return null;

    try {
        const res = await fetch(url);
        if (!res.ok) return null;

        return {
            contentType: res.headers.get("content-type") ?? "application/octet-stream",
            data: new Uint8Array(await res.arrayBuffer())
        };
    } catch {
        return null;
    }
}
