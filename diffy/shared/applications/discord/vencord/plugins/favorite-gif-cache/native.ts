/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 Vendicated and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import { IpcMainInvokeEvent } from "electron";

// downloading in the main process sidesteps the renderer csp, which only
// whitelists some of the gif hosts discord itself serves from
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
