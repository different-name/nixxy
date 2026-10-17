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

const VIDEO_EXT = /\.(mp4|m4v|mov|mkv|webm|avi|flv|wmv|ts)$/i;

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

function isOversizedVideo(file: File, limit: number) {
    return file.size > limit
        && !handled.has(file)
        && (file.type.startsWith("video/") || VIDEO_EXT.test(file.name));
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
let nextJobId = 0;

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

async function compressFile(file: File, limit: number) {
    const id = nextJobId++;
    renderPopup(<ProgressPopup key={id} id={id} name={file.name} />);
    const { data, error } = await file.arrayBuffer()
        .then(buf => Native.compress(id, new Uint8Array(buf), extOf(file.name), limit))
        .catch(e => ({ data: undefined, error: String(e) }))
        .finally(() => renderPopup(null));
    if (!data) {
        handled.add(file);
        toast(`Couldn't compress ${file.name}: ${error}`, "critical");
        return file;
    }

    const out = new File([data], file.name.replace(/\.[^.]+$/, "") + ".mp4", { type: "video/mp4" });
    handled.add(out);
    return out;
}

async function compressAll(files: File[], limit: number) {
    const out: File[] = [];
    for (const file of files)
        out.push(isOversizedVideo(file, limit) ? await compressFile(file, limit) : file);
    return out;
}

export default definePlugin({
    name: "CompressVideoUploads",
    description: "Compresses videos over the upload limit to fit before uploading",
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
        if (!list.some(f => isOversizedVideo(f, limit))) return false;

        compressAll(list, limit)
            .catch(() => {
                list.forEach(f => handled.add(f));
                return list;
            })
            .then(next => promptToUpload(next, channel, draftType, options));
        return true;
    }
});
