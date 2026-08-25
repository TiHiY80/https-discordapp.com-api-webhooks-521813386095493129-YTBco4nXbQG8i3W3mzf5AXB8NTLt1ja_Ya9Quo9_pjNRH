#!/usr/bin/env python3
"""Build an English voiceover for the YouTube API compliance screencast."""
from __future__ import annotations

import asyncio
import subprocess
from pathlib import Path

import edge_tts

OUT = Path(__file__).resolve().parent
VOICE = "en-US-AndrewNeural"

# Each item: (filename stem, spoken English, silence seconds after for the operator to click)
STEPS: list[tuple[str, str, float]] = [
    (
        "01",
        "This is TiHiY StreamControl Center. It is a desktop API client for a content creator to manage their own YouTube live stream using YouTube API Services.",
        4,
    ),
    (
        "02",
        "Step one: OAuth authorization. I open Channels. This is YouTube OAuth for a Desktop application. The redirect URI is one two seven dot zero dot zero dot one, port one seven eight four seven. The only OAuth scope requested is youtube.force-ssl.",
        6,
    ),
    (
        "03",
        "I click Authorize and complete Google consent as the creator. After login, the client calls channels.list with mine equals true. Here is the authenticated YouTube channel title and the channel URL. All later API calls use this signed-in account. I close the secret fields so credentials are not shown.",
        22,
    ),
    (
        "04",
        "Step two: broadcast data retrieval. I open YouTube Broadcast. I click Refresh list. This list is liveBroadcasts.list with mine equals true. Here you see the broadcast title, life cycle status live, privacy, and the watch URL. That is the end result of broadcast retrieval.",
        14,
    ),
    (
        "05",
        "On the main console, live statistics come from videos.list, parts liveStreamingDetails and statistics: concurrent viewers and like count. The end result is the live indicator, viewer count, and likes for this broadcast.",
        6,
    ),
    (
        "06",
        "Step three: real-time chat. Incoming messages are liveChatMessages.list. The user interface shows the author's display name, the message text, and the author's YouTube channel URL.",
        12,
    ),
    (
        "07",
        "I send a message with the YouTube button. This is liveChatMessages.insert as the authenticated creator. End result: the message appears in live chat.",
        8,
    ),
    (
        "08",
        "I delete that message. This is liveChatMessages.delete. End result: the message is removed from chat.",
        6,
    ),
    (
        "09",
        "Moderation timeout. The confirmation dialog identifies the target YouTube channel name and channel URL, and the acting YouTube account name and channel URL, as required by YouTube API minimum functionality. This call is liveChatBans.insert, temporary. End result: the test user is timed out.",
        10,
    ),
    (
        "10",
        "Permanent ban. The same dialog identifies the target channel and the acting account. This is liveChatBans.insert, permanent. End result: the test channel is banned from this live chat.",
        8,
    ),
    (
        "11",
        "Unban. This is liveChatBans.delete. The dialog again shows the target and acting channel URLs. End result: the ban is removed.",
        8,
    ),
    (
        "12",
        "Final result of the full workflow: this API client uses YouTube API Services only for the authenticated creator's own live broadcast, statistics, real-time chat, and moderation. Thank you.",
        3,
    ),
]


async def synth(text: str, dest: Path) -> None:
    communicate = edge_tts.Communicate(text, VOICE)
    await communicate.save(str(dest))


def silence(seconds: float, dest: Path) -> None:
    subprocess.check_call(
        [
            "ffmpeg",
            "-y",
            "-f",
            "lavfi",
            "-i",
            "anullsrc=r=24000:cl=mono",
            "-t",
            f"{seconds:.2f}",
            "-q:a",
            "9",
            "-acodec",
            "libmp3lame",
            str(dest),
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


async def main() -> None:
    parts: list[Path] = []
    for stem, text, pause in STEPS:
        speech = OUT / f"{stem}-speech.mp3"
        gap = OUT / f"{stem}-gap.mp3"
        await synth(text, speech)
        silence(pause, gap)
        parts.extend([speech, gap])

    concat = OUT / "concat.txt"
    concat.write_text("".join(f"file '{p.name}'\n" for p in parts), encoding="utf-8")
    final = OUT / "ENGLISH-VOICEOVER.mp3"
    subprocess.check_call(
        [
            "ffmpeg",
            "-y",
            "-f",
            "concat",
            "-safe",
            "0",
            "-i",
            str(concat),
            "-c",
            "copy",
            str(final),
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    print(final, "bytes", final.stat().st_size)


if __name__ == "__main__":
    asyncio.run(main())
