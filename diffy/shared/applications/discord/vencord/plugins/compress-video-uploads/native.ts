import { spawn } from "child_process";
import { IpcMainInvokeEvent } from "electron";
import { mkdtemp, readFile, rm, stat, writeFile } from "fs/promises";
import { tmpdir } from "os";
import { join } from "path";

const FFMPEG = "ffmpeg";
const FFPROBE = "ffprobe";

const AUDIO_BPS = 96_000;
const MIN_VIDEO_BPS = 100_000;
const MAX_ATTEMPTS = 4;

export interface Progress {
    attempt: number;
    pass: number;
    fraction: number;
}

const jobs = new Map<number, Progress>();

function run(cmd: string, args: string[], onLine?: (line: string) => void) {
    return new Promise<string>((resolve, reject) => {
        const proc = spawn(cmd, args, { stdio: ["ignore", "pipe", "pipe"] });
        let stdout = "";
        let stderr = "";
        let pending = "";
        proc.stdout.on("data", d => {
            stdout += d;
            if (!onLine) return;
            const lines = (pending + d).split("\n");
            pending = lines.pop()!;
            lines.forEach(onLine);
        });
        proc.stderr.on("data", d => stderr += d);
        proc.on("error", reject);
        proc.on("close", code => {
            if (code === 0) resolve(stdout);
            else reject(new Error(stderr.trim().split("\n").pop() || `${cmd} exited with code ${code}`));
        });
    });
}

async function probe(input: string) {
    const out = await run(FFPROBE, [
        "-v", "error",
        "-show_entries", "format=duration:stream=codec_type,height",
        "-of", "json",
        input
    ]);
    const { format, streams } = JSON.parse(out);
    const video = streams.find(s => s.codec_type === "video");
    return {
        duration: Number(format.duration),
        height: Number(video?.height) || 0,
        hasAudio: streams.some(s => s.codec_type === "audio")
    };
}

function maxHeightFor(videoBps: number) {
    if (videoBps < 500_000) return 480;
    if (videoBps < 1_500_000) return 720;
    return Infinity;
}

async function encode(dir: string, input: string, output: string, targetBytes: number, info: Awaited<ReturnType<typeof probe>>, progress: Progress) {
    const audioBps = info.hasAudio ? AUDIO_BPS : 0;
    const videoBps = Math.floor(targetBytes * 8 / info.duration) - audioBps;
    if (videoBps < MIN_VIDEO_BPS) throw new Error("video is too long to fit the upload limit");

    const maxHeight = maxHeightFor(videoBps);
    const common = [
        "-y", "-nostdin", "-v", "error",
        "-progress", "pipe:1", "-nostats",
        "-i", input,
        ...(info.height > maxHeight ? ["-vf", `scale=-2:${maxHeight}`] : []),
        "-c:v", "libx264",
        "-pix_fmt", "yuv420p",
        "-b:v", String(videoBps),
        "-maxrate", String(Math.floor(videoBps * 1.45)),
        "-bufsize", String(videoBps * 2),
        "-passlogfile", join(dir, "pass")
    ];

    const track = (pass: number) => {
        progress.pass = pass;
        progress.fraction = 0;
        return (line: string) => {
            const [key, value] = line.split("=");
            const us = Number(value);
            if (key === "out_time_us" && us > 0)
                progress.fraction = Math.min(us / 1e6 / info.duration, 1);
        };
    };

    await run(FFMPEG, [...common, "-pass", "1", "-an", "-f", "null", "/dev/null"], track(1));
    await run(FFMPEG, [
        ...common,
        "-pass", "2",
        ...(info.hasAudio ? ["-c:a", "aac", "-b:a", String(audioBps), "-ac", "2"] : ["-an"]),
        "-map_chapters", "-1",
        "-movflags", "+faststart",
        output
    ], track(2));

    return (await stat(output)).size;
}

export function getProgress(_: IpcMainInvokeEvent, id: number) {
    return jobs.get(id);
}

export async function compress(_: IpcMainInvokeEvent, id: number, data: Uint8Array, ext: string, limit: number): Promise<{ data?: Uint8Array; error?: string; }> {
    const progress: Progress = { attempt: 0, pass: 1, fraction: 0 };
    jobs.set(id, progress);
    const dir = await mkdtemp(join(tmpdir(), "vc-compress-"));
    try {
        const input = join(dir, "input" + (/^\.[a-z0-9]{1,5}$/i.test(ext) ? ext : ""));
        const output = join(dir, "output.mp4");
        await writeFile(input, data);

        const info = await probe(input);
        if (!(info.duration > 0)) throw new Error("couldn't read the video duration");

        // container overhead
        let target = limit * 0.97;
        for (; progress.attempt < MAX_ATTEMPTS; progress.attempt++) {
            const size = await encode(dir, input, output, target, info, progress);
            if (size <= limit) return { data: new Uint8Array(await readFile(output)) };
            target *= Math.min(limit / size, 0.95);
        }
        throw new Error("output is still over the upload limit");
    } catch (e) {
        return { error: e instanceof Error ? e.message : String(e) };
    } finally {
        jobs.delete(id);
        rm(dir, { recursive: true, force: true }).catch(() => { });
    }
}
