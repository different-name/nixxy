/*
 * Vencord, a Discord client mod
 * Copyright (c) 2026 Vendicated and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import { definePluginSettings } from "@api/Settings";
import { Button } from "@components/Button";
import { Flex } from "@components/Flex";
import { Paragraph } from "@components/Paragraph";
import { Logger } from "@utils/Logger";
import definePlugin, { OptionType, PluginNative } from "@utils/types";
import { UserSettingsActionCreators, useState } from "@webpack/common";

import * as cache from "./cache";

const Native = VencordNative.pluginHelpers.FavoriteGifCache as PluginNative<typeof import("./native")>;

const logger = new Logger("FavoriteGifCache");

const GIF_HOSTS = /^(media\d*\.tenor\.com|c\.tenor\.com|media\d*\.giphy\.com|i\.giphy\.com)$/;
const PREFETCH_WORKERS = 4;
const OBJECT_URL_BUDGET = 64 * 1024 * 1024;
const MEGABYTE = 1024 * 1024;

const settings = definePluginSettings({
    prefetch: {
        type: OptionType.BOOLEAN,
        description: "Download every favorite in the background on startup, so the picker never waits on the network",
        default: true
    },
    cacheSearchResults: {
        type: OptionType.BOOLEAN,
        description: "Also keep gifs from search and trending, not just favorites",
        default: false
    },
    maxCacheSize: {
        type: OptionType.SLIDER,
        description: "How much disk the stored gifs may use, in MB",
        markers: [128, 256, 512, 1024, 2048],
        default: 512,
        stickToMarkers: true
    },
    storage: {
        type: OptionType.COMPONENT,
        component() {
            const [, setRevision] = useState(0);

            return (
                <Flex flexDirection="column" gap="8px" alignItems="flex-start">
                    <Paragraph>{cache.index.size} gifs stored, {(cache.size() / MEGABYTE).toFixed(1)} MB</Paragraph>
                    <Button
                        variant="dangerPrimary"
                        size="small"
                        onClick={async () => {
                            await cache.clear();
                            releaseObjectUrls();
                            setRevision(revision => revision + 1);
                        }}
                    >
                        Clear stored gifs
                    </Button>
                </Flex>
            );
        }
    }
});

const favorites = new Map<string, string>();
const downloading = new Set<string>();
const objectUrls = new Map<string, { url: string; size: number; }>();
const serving = new WeakMap<Element, string>();

let objectUrlBytes = 0;
let unpatch: (() => void) | undefined;

function parse(value: unknown) {
    if (typeof value !== "string" || !value.startsWith("http")) return null;

    try {
        const url = new URL(value);
        return { key: url.origin + url.pathname, hostname: url.hostname };
    } catch {
        return null;
    }
}

function cacheKey(value: unknown) {
    const parsed = parse(value);
    if (!parsed) return null;

    if (favorites.has(parsed.key)) return parsed.key;
    if (settings.store.cacheSearchResults && GIF_HOSTS.test(parsed.hostname)) return parsed.key;

    return null;
}

function loadFavorites() {
    try {
        const { favoriteGifs } = UserSettingsActionCreators.FrecencyUserSettingsActionCreators.getCurrentValue();

        favorites.clear();
        for (const gif of Object.values<any>(favoriteGifs?.gifs ?? {})) {
            const parsed = parse(gif?.src);
            if (parsed) favorites.set(parsed.key, gif.src);
        }
    } catch (err) {
        logger.error("could not read favorite gifs", err);
    }
}

async function download(url: string) {
    const media = await Native?.fetchMedia(url);
    if (media) return new Blob([media.data], { type: media.contentType });

    const res = await fetch(url);
    if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);

    return res.blob();
}

async function store(key: string, url: string) {
    if (downloading.has(key) || cache.index.has(key)) return;

    downloading.add(key);
    try {
        const blob = await download(url);
        if (blob.size) await cache.write(key, blob);
    } catch (err) {
        logger.debug("could not store", url, err);
    } finally {
        downloading.delete(key);
    }
}

function objectUrlFor(key: string, blob: Blob) {
    const existing = objectUrls.get(key);
    if (existing) {
        objectUrls.delete(key);
        objectUrls.set(key, existing);
        return existing.url;
    }

    const created = { url: URL.createObjectURL(blob), size: blob.size };
    objectUrls.set(key, created);
    objectUrlBytes += created.size;

    for (const [oldest, entry] of objectUrls) {
        if (objectUrlBytes <= OBJECT_URL_BUDGET || objectUrls.size === 1) break;
        objectUrls.delete(oldest);
        objectUrlBytes -= entry.size;
        URL.revokeObjectURL(entry.url);
    }

    return created.url;
}

function releaseObjectUrls() {
    for (const { url } of objectUrls.values()) URL.revokeObjectURL(url);
    objectUrls.clear();
    objectUrlBytes = 0;
}

function serve(el: Element, value: string, setSrc: (src: string) => void) {
    // a late src swap on <source> never reloads, so only elements that own their src
    if (el.tagName !== "IMG" && el.tagName !== "VIDEO") return false;

    const key = cacheKey(value);
    if (!key) {
        serving.delete(el);
        return false;
    }

    if (serving.get(el) === key && el.hasAttribute("src")) return true;
    serving.set(el, key);

    if (!cache.index.has(key)) {
        setSrc(value);
        void store(key, value);
        return true;
    }

    el.removeAttribute("src");
    cache.read(key)
        .then(blob => {
            if (serving.get(el) === key) setSrc(blob ? objectUrlFor(key, blob) : value);
        })
        .catch(err => {
            logger.debug("could not read", value, err);
            if (serving.get(el) === key) setSrc(value);
        });

    return true;
}

function patch() {
    const nativeSetAttribute = Element.prototype.setAttribute;
    const descriptors: Array<[object, PropertyDescriptor]> = [];

    Element.prototype.setAttribute = function (this: Element, name: string, value: string) {
        if (name === "src" && serve(this, value, src => nativeSetAttribute.call(this, "src", src))) return;

        nativeSetAttribute.call(this, name, value);
    };

    for (const ctor of [HTMLImageElement, HTMLVideoElement]) {
        const descriptor = Object.getOwnPropertyDescriptor(ctor.prototype, "src");
        if (!descriptor?.set) continue;

        descriptors.push([ctor.prototype, descriptor]);
        Object.defineProperty(ctor.prototype, "src", {
            ...descriptor,
            set(this: Element, value: string) {
                if (!serve(this, value, src => descriptor.set!.call(this, src))) descriptor.set!.call(this, value);
            }
        });
    }

    unpatch = () => {
        Element.prototype.setAttribute = nativeSetAttribute;
        for (const [prototype, descriptor] of descriptors) Object.defineProperty(prototype, "src", descriptor);
    };
}

async function prefetch() {
    const queue = [...favorites].filter(([key]) => !cache.index.has(key));
    if (!queue.length) return;

    logger.info(`storing ${queue.length} favorite gifs`);

    await Promise.all(Array.from({ length: PREFETCH_WORKERS }, async () => {
        for (let next = queue.pop(); next; next = queue.pop()) await store(next[0], next[1]);
    }));

    await cache.evict(settings.store.maxCacheSize * MEGABYTE);
}

export default definePlugin({
    name: "FavoriteGifCache",
    description: "Keeps your favorite gifs on disk so the gif picker loads them instantly",
    authors: [{ name: "diffy", id: 0n }],
    tags: ["Media"],
    settings,

    flux: {
        USER_SETTINGS_PROTO_UPDATE() {
            loadFavorites();
        }
    },

    async start() {
        try {
            await cache.open();
        } catch (err) {
            logger.error("could not open the gif store", err);
            return;
        }

        loadFavorites();
        patch();

        await cache.evict(settings.store.maxCacheSize * MEGABYTE);
        if (settings.store.prefetch) void prefetch();
    },

    stop() {
        unpatch?.();
        unpatch = undefined;

        releaseObjectUrls();
        void cache.close();
    }
});
