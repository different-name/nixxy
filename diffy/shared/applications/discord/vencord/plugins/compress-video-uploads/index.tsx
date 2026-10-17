import NotificationComponent from "@api/Notifications/NotificationComponent";
import definePlugin, { PluginNative } from "@utils/types";
import { Channel } from "@vencord/discord-types";
import { findByCodeLazy } from "@webpack";
import { createRoot, Toasts, UploadHandler, useEffect, useState } from "@webpack/common";

import type { ReactNode } from "react";

import type { Progress } from "./native";

const Native = VencordNative.pluginHelpers.CompressVideoUploads as PluginNative<typeof import("./native")>;

const getMaxFileSize: (guildId?: string | null) => number = findByCodeLazy(".getUserMaxFileSize(", ".features.has(");
// discord raises the per-user limit to a floor in its own size check
const applyUploadFloor: (limit: number) => number = findByCodeLazy("Math.max(0x1400000,");
const promptToUpload = UploadHandler.promptToUpload as (files: File[], channel: Channel, draftType: number, options?: unknown) => void;

const VIDEO_EXT = /\.(mp4|m4v|mov|mkv|webm|avi|flv|wmv)$/i;

// compressed outputs and files that failed, so the re-prompt never loops
const handled = new WeakSet<File>();

// vencord's createToast lookup no longer matches discord, show takes { text, variant } directly
function toast(text: string, variant: "default" | "critical" = "default") {
    try {
        (Toasts.show as (toast: { text: string; variant: string; }) => void)({ text, variant });
    } catch { }
}

function extOf(name: string) {
    return name.match(/\.[^.]+$/)?.[0] ?? "";
}

// chromium types typescript sources as video/mp2t
function isVideo(file: File) {
    return VIDEO_EXT.test(file.name) || (file.type.startsWith("video/") && file.type !== "video/mp2t");
}

function isOversizedVideo(file: File, limit: number) {
    return file.size > limit
        && !handled.has(file)
        && isVideo(file);
}

function isMkv(file: File) {
    return !handled.has(file) && /\.mkv$/i.test(file.name);
}

function needsWork(file: File, limit: number) {
    return isOversizedVideo(file, limit) || isMkv(file);
}

function asMp4(data: Uint8Array, name: string) {
    const out = new File([data], name.replace(/\.[^.]+$/, "") + ".mp4", { type: "video/mp4" });
    handled.add(out);
    return out;
}

function ProgressPopup({ id, name }: { id: number; name: string; }) {
    const [progress, setProgress] = useState<Progress>();
    const [dismissed, setDismissed] = useState(false);

    useEffect(() => {
        const timer = setInterval(() => Native.getProgress(id).then(setProgress), 500);
        return () => clearInterval(timer);
    }, [id]);

    if (dismissed) return null;

    const percent = progress ? Math.round((progress.pass - 1 + progress.fraction) * 50) : 0;
    return (
        <NotificationComponent
            title="Compressing video"
            body=""
            permanent
            dismissOnClick={false}
            onClose={() => setDismissed(true)}
            richBody={
                <>
                    <p className="vc-notification-p" style={{ whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>
                        {name}
                    </p>
                    <p className="vc-notification-p">
                        {progress?.attempt ? `Still too large, retrying at a lower bitrate (${percent}%)` : `${percent}%`}
                    </p>
                    <div style={{ height: "0.25rem", marginTop: "0.75rem", borderRadius: 5, overflow: "hidden", background: "rgb(127 127 127 / 0.25)" }}>
                        <div style={{ height: "100%", width: `${percent}%`, background: "var(--brand-500)", transition: "width 0.5s linear" }} />
                    </div>
                </>
            }
        />
    );
}

let popupRoot: ReturnType<typeof createRoot> | undefined;
let shownJobId: number | undefined;
let nextJobId = 0;

function showPopup(id: number, name: string) {
    shownJobId = id;
    renderPopup(<ProgressPopup key={id} id={id} name={name} />);
}

function hidePopup(id: number) {
    if (shownJobId !== id) return;
    shownJobId = undefined;
    renderPopup(null);
}

function renderPopup(node: ReactNode) {
    try {
        if (!popupRoot) {
            const container = document.createElement("div");
            container.id = "vc-compress-video-uploads";
            document.body.append(container);
            popupRoot = createRoot(container);
        }
        popupRoot.render(node);
    } catch { }
}

async function compressFile(file: File, limit: number, quiet = false) {
    const id = nextJobId++;
    showPopup(id, file.name);
    const { data, error } = await file.arrayBuffer()
        .then(buf => Native.compress(id, new Uint8Array(buf), extOf(file.name), limit))
        .catch(e => ({ data: undefined, error: String(e) }))
        .finally(() => hidePopup(id));
    if (!data) {
        handled.add(file);
        if (!quiet) toast(`Couldn't compress ${file.name}: ${error}`, "critical");
        return file;
    }

    return asMp4(data, file.name);
}

// the mkv already fits, so re-encode at its own size and upload it as is if that fails
async function remuxFile(file: File, limit: number) {
    const { data } = await file.arrayBuffer()
        .then(buf => Native.remux(new Uint8Array(buf), extOf(file.name)))
        .catch(() => ({ data: undefined }));
    if (data && data.byteLength <= limit) return asMp4(data, file.name);
    return compressFile(file, Math.min(limit, file.size), true);
}

async function processFile(file: File, limit: number) {
    if (isOversizedVideo(file, limit)) return compressFile(file, limit);
    if (isMkv(file)) return remuxFile(file, limit);
    return file;
}

async function processAll(files: File[], limit: number) {
    const out: File[] = [];
    for (const file of files)
        out.push(await processFile(file, limit));
    return out;
}

export default definePlugin({
    name: "CompressVideoUploads",
    description: "Compresses videos over the upload limit to fit before uploading and converts mkv to mp4",
    authors: [{ name: "diffy", id: 0n }],

    patches: [
        {
            find: "Unexpected mismatch between files and file metadata",
            replacement: {
                match: /throw Error\("Unexpected mismatch between files and file metadata"\);/,
                replace: "$&if($self.interceptUpload(arguments))return;"
            }
        }
    ],

    interceptUpload([files, channel, draftType, options]: [ArrayLike<File>, Channel, number, { isThumbnail?: boolean; }?]) {
        if (options?.isThumbnail) return false;

        const list = Array.from(files);
        let limit: number;
        try {
            limit = getMaxFileSize(channel.getGuildId());
        } catch {
            return false;
        }
        try {
            limit = applyUploadFloor(limit);
        } catch { }
        if (!list.some(f => needsWork(f, limit))) return false;

        processAll(list, limit)
            .catch(() => {
                list.forEach(f => handled.add(f));
                return list;
            })
            .then(next => promptToUpload(next, channel, draftType, options));
        return true;
    }
});
