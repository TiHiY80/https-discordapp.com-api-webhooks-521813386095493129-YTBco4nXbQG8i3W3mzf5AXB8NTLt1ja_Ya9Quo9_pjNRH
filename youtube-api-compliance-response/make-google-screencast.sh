#!/usr/bin/env bash
# Build a Google API review screencast from a local MP4:
# optional trim + English voiceover + burned-in English captions.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
AUDIO="${ROOT}/ENGLISH-VOICEOVER.mp3"
if [[ ! -f "$AUDIO" ]]; then
  AUDIO="${ROOT}/youtube-api-compliance-response/screencast-audio/ENGLISH-VOICEOVER.mp3"
fi
SRT="${ROOT}/youtube-api-compliance-response/screencast-audio/ENGLISH-CAPTIONS.srt"
OUT_DIR="${ROOT}/youtube-api-compliance-response/out"
mkdir -p "$OUT_DIR"

IN="${1:-}"
START="${2:-}"
END="${3:-}"

if [[ -z "$IN" || ! -f "$IN" ]]; then
  echo "Usage: $0 input.mp4 [start_seconds] [end_seconds]" >&2
  exit 1
fi
if [[ ! -f "$AUDIO" ]]; then
  echo "Missing English voiceover: $AUDIO" >&2
  exit 1
fi

CUT="${OUT_DIR}/cut.mp4"
if [[ -n "$START" && -n "$END" ]]; then
  ffmpeg -y -ss "$START" -to "$END" -i "$IN" -c:v libx264 -preset veryfast -crf 20 -an "$CUT"
else
  ffmpeg -y -i "$IN" -c:v libx264 -preset veryfast -crf 20 -an "$CUT"
fi

# Mix: duck original (already stripped) — voiceover is the English track.
# Loop/pad video to voiceover length if the cut is shorter; trim voice if longer.
MIX="${OUT_DIR}/with-voice.mp4"
ffmpeg -y -i "$CUT" -i "$AUDIO" -filter_complex \
  "[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1[v];
   [1:a]aformat=sample_rates=48000:channel_layouts=stereo,volume=1.0[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 160k \
  -shortest "$MIX"

CAPTIONED="${OUT_DIR}/TiHiY-YouTube-API-compliance-screencast.mp4"
ffmpeg -y -i "$MIX" -vf "subtitles=${SRT}:force_style='FontName=DejaVu Sans,FontSize=22,PrimaryColour=&H00FFFFFF,OutlineColour=&H00000000,Outline=2,Alignment=2'" \
  -c:v libx264 -preset veryfast -crf 20 -c:a copy "$CAPTIONED"

echo "WROTE $CAPTIONED"
ls -lh "$CAPTIONED"
