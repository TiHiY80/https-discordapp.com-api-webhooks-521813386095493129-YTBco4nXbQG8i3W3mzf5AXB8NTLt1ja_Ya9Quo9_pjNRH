#!/usr/bin/env python3
"""Lay English VO on each cut clip so speech matches the on-screen action."""
from __future__ import annotations

import asyncio
import subprocess
from pathlib import Path

import edge_tts

ROOT = Path("/workspace/youtube-api-compliance-response/out")
CLIPS = ROOT / "clips"
VOICE = "en-US-AndrewNeural"

# One spoken line per visual clip. Keep shorter than the clip so there is
# a beat to watch the UI. Extra time is silence.
LINES: list[tuple[str, str]] = [
    (
        "c01.mp4",
        "This is TiHiY StreamControl Center, a Windows desktop API client for a creator to manage their own YouTube live stream.",
    ),
    (
        "c02.mp4",
        "Step one: OAuth. This is the Channels window. YouTube OAuth for a Desktop app. Redirect URI: 127.0.0.1, port 17847. Only scope: youtube.force-ssl. The secret is hidden.",
    ),
    (
        "c03.mp4",
        "Main console. YouTube shows live. This client is now attached to the creator's own broadcast.",
    ),
    (
        "c04.mp4",
        "YouTube Broadcast window. liveBroadcasts.list with mine equals true. Title, life cycle status live, privacy, and the watch URL.",
    ),
    (
        "c05.mp4",
        "Google OAuth consent. The browser asks the creator to continue to TiHiY StreamControl Center. After login, the Channels window shows YouTube chat connected for TiHiY-DED. That signed-in account is used for every later API call. Redirect URI 127.0.0.1 port 17847. Scope youtube.force-ssl only.",
    ),
    (
        "c06.mp4",
        "Live statistics on the console come from videos.list: concurrent viewers and like count.",
    ),
    (
        "c07.mp4",
        "Step three: real-time YouTube Live Chat. Each incoming line is liveChatMessages.list. The UI shows the YouTube icon, the author display name, and the text. This is the creator's own live chat, not a third-party scrape. Watch the test messages arrive: hello, test one, test two. That is the end result of chat retrieval.",
    ),
    (
        "c08.mp4",
        "The creator sends from this desktop client. That call is liveChatMessages.insert as the signed-in channel. End result: the message API compliance test from StreamControl Center appears in live chat, in this console and on YouTube.",
    ),
    (
        "c09.mp4",
        "Chat moderation. The dialog asks to ban the test user on YouTube. The operator confirms yes. That is liveChatBans.insert. Only a test account on this authenticated live chat. End result: the ban is done from StreamControl Center.",
    ),
    (
        "c10.mp4",
        "End result: still on the signed-in creator's own live session. YouTube API Services only. Thank you.",
    ),
]


def probe_duration(path: Path) -> float:
    out = subprocess.check_output(
        [
            "ffprobe",
            "-v",
            "error",
            "-show_entries",
            "format=duration",
            "-of",
            "default=nw=1:nk=1",
            str(path),
        ],
        text=True,
    ).strip()
    return float(out)


def run(cmd: list[str]) -> None:
    subprocess.check_call(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


async def synth(text: str, dest: Path) -> None:
    await edge_tts.Communicate(text, VOICE).save(str(dest))


async def main() -> None:
    work = ROOT / "vo-sync"
    work.mkdir(parents=True, exist_ok=True)
    padded: list[Path] = []
    srt_chunks: list[str] = []
    t = 0.0
    idx = 1

    for name, text in LINES:
        clip = CLIPS / name
        dur = probe_duration(clip)
        speech = work / f"{clip.stem}-speech.mp3"
        await synth(text, speech)
        sp = probe_duration(speech)
        pad = work / f"{clip.stem}-pad.mp3"
        if sp > dur - 0.15:
            # slight speed-up so speech still fits the picture
            tempo = min(sp / (dur - 0.12), 1.25)
            sped = work / f"{clip.stem}-sped.mp3"
            run(
                [
                    "ffmpeg",
                    "-y",
                    "-i",
                    str(speech),
                    "-filter:a",
                    f"atempo={tempo:.4f}",
                    str(sped),
                ]
            )
            speech = sped
            sp = probe_duration(speech)
        exact = work / f"{clip.stem}-exact.mp3"
        run(
            [
                "ffmpeg",
                "-y",
                "-i",
                str(speech),
                "-af",
                f"aformat=sample_rates=44100:channel_layouts=stereo,apad=whole_dur={dur:.4f}",
                "-t",
                f"{dur:.4f}",
                "-c:a",
                "libmp3lame",
                "-q:a",
                "4",
                str(exact),
            ]
        )
        padded.append(exact)
        start = t
        end = t + min(sp, dur)
        def ts(x: float) -> str:
            h = int(x // 3600)
            m = int((x % 3600) // 60)
            s = x % 60
            return f"{h:02d}:{m:02d}:{s:06.3f}".replace(".", ",")

        srt_chunks.append(f"{idx}\n{ts(start)} --> {ts(end)}\n{text}\n")
        idx += 1
        t += dur
        print(f"{name} clip={dur:.2f}s speech={sp:.2f}s")

    concat = work / "vo.txt"
    concat.write_text("".join(f"file '{p}'\n" for p in padded), encoding="utf-8")
    vo = ROOT / "narration-synced.mp3"
    run(
        [
            "ffmpeg",
            "-y",
            "-f",
            "concat",
            "-safe",
            "0",
            "-i",
            str(concat),
            "-c:a",
            "libmp3lame",
            "-q:a",
            "4",
            str(vo),
        ]
    )
    srt = ROOT / "en-synced.srt"
    srt.write_text("\n".join(srt_chunks), encoding="utf-8")
    print("vo", probe_duration(vo), "video", t)


if __name__ == "__main__":
    asyncio.run(main())
