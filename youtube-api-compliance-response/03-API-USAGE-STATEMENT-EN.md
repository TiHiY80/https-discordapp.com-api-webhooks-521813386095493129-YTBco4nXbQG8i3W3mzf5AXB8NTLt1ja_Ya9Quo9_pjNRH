# TiHiY StreamControl Center — YouTube API usage statement

Supporting material for the YouTube API Services compliance review.
Source of truth: public repository
https://github.com/sergsivak-lang/TiHiY-StreamControl-Center
Primary implementation file: `Services/YouTubeService.cs`

## OAuth

| Item | Actual value in code |
|---|---|
| Authorization endpoint | `https://accounts.google.com/o/oauth2/v2/auth` |
| Token endpoint | `https://oauth2.googleapis.com/token` |
| Client type | Desktop app |
| Redirect URI | `http://127.0.0.1:17847/` |
| Loopback helper | `Services/OAuthLoopback.cs` |
| Scopes requested | **Only** `https://www.googleapis.com/auth/youtube.force-ssl` |
| `access_type` | `offline` |
| `prompt` | `consent` |
| CSRF | random `state` compared on return |
| Token persistence | Windows Credential Manager key `TiHiY.StreamControlCenter.YOUTUBE_TOKEN` |
| Client secret persistence | Windows Credential Manager key `TiHiY.StreamControlCenter.YOUTUBE_CLIENT_SECRET` |
| Client ID persistence | `settings.json` field `YouTubeClientId` (not a secret) |
| UI | Module **КАНАЛИ** → YouTube → **АВТОРИЗУВАТИ** / **ПІДКЛЮЧИТИ** / **ВІДКЛЮЧИТИ** / **ЗАБУТИ** |

`youtube.force-ssl` is the only scope. The client does not request
`youtube`, `youtube.readonly`, `youtube.upload`, `openid`, `email`, or `profile`.

## Execution flow (real)

```
ChannelConnectionsWindow.AuthorizeYouTube_Click
  → YouTubeService.AuthorizeAsync
    → browser OAuth + OAuthLoopback
    → oauth2.googleapis.com/token
    → CredentialService.SaveSecret("YOUTUBE_TOKEN")
    → YouTubeService.ConnectAsync
      → PollLoopAsync
        → GET liveBroadcasts?mine=true
        → if live: GET videos?part=liveStreamingDetails,statistics
        → if live: GET liveChat/messages
        → events: StatusChanged, StatsChanged, MessageReceived
          → MainWindow / ChatService UI
```

Chat send:

```
MainWindow SendYouTube button
  → AppServices.SendChatAsync
    → YouTubeService.SendMessageAsync
      → POST liveChat/messages?part=snippet
```

Moderation:

```
Main chat context menu (мут / бан / видалити)
  → AppServices.ModerateChatUserAsync / DeleteChatMessageAsync
    → YouTubeService.TimeoutUserAsync / BanUserAsync / DeleteMessageAsync
      → POST liveChat/bans?part=snippet
        or DELETE liveChat/messages?id=...
```

## Methods and responses consumed

| Method | HTTP | Path | Response fields used | UI |
|---|---|---|---|---|
| `liveBroadcasts.list` | GET | `liveBroadcasts?part=id,snippet,status&mine=true&broadcastType=all&maxResults=50` | `id`, `snippet.title`, `snippet.description`, `snippet.scheduledStartTime`, `snippet.liveChatId`, `status.privacyStatus`, `status.lifeCycleStatus` | Poll: LIVE/OFF, chat attach. Window `YouTubeStreamSettingsWindow`: combo of broadcasts |
| `liveBroadcasts.update` | PUT | `liveBroadcasts?part=snippet,status` | success / error body | **ЗБЕРЕГТИ В YOUTUBE** |
| `videos.list` | GET | `videos?part=liveStreamingDetails,statistics&id={broadcastId}` | `liveStreamingDetails.concurrentViewers`, `statistics.likeCount` | Main header `YouTubeViewerText`, `YouTubeLikesText` |
| `liveChatMessages.list` | GET | `liveChat/messages?part=id,snippet,authorDetails&liveChatId=...` | `items[].id`, `snippet.type`, `snippet.displayMessage`, `authorDetails.displayName`, `authorDetails.channelId`, roles, Super Chat/Member details, `nextPageToken`, `pollingIntervalMillis` | Multichat list (platform icon YOUTUBE, user, text) |
| `liveChatMessages.insert` | POST | `liveChat/messages?part=snippet` | success / error | Button **YOUTUBE** on main chat and ChatBot window |
| `liveChatMessages.delete` | DELETE | `liveChat/messages?id=...` | success / error | Context menu **Видалити повідомлення** |
| `channels.list` | GET | `channels?part=snippet&mine=true` | `id`, `snippet.title` | **КАНАЛИ** and **YOUTUBE ЕФІР**: authenticated title + `https://www.youtube.com/channel/{id}` |
| `liveChatBans.insert` | POST | `liveChat/bans?part=snippet` | `id` stored for unban | Context menu mute (temporary 600s) and ban (permanent). Confirm dialog shows target + acting channel URLs |
| `liveChatBans.delete` | DELETE | `liveChat/bans?id={banId}` | success / error | Context menu **Зняти бан YouTube** for a ban created in this session |

Base URL for all Data API calls: `https://www.googleapis.com/youtube/v3/`

## Polling and quota (factual)

- While connected, `PollLoopAsync` repeats on `pollingIntervalMillis` from chat list, clamped to 2000–15000 ms (default 5000).
- Every cycle calls `liveBroadcasts.list`.
- When `lifeCycleStatus=live`, the same cycle also calls `videos.list` and `liveChatMessages.list`.
- There is **no** in-app quota counter. Quota math for the extension request should be estimated from this poll cycle, not invented in the client.

## Not implemented (do not claim)

| Item | Status |
|---|---|
| `liveStreams.list` | No call site |
| `liveChatMessages.streamList` | No call site (client uses official list + poll) |
| `liveChatModerators.*` | No API. ChatBot preview buttons are disabled |

## Error handling

`YouTubeService.ApiAsync`:

- missing token → user is told to authorize in **КАНАЛИ**;
- HTTP 401 → token missing/expired, re-authorize;
- other non-success → `YouTube API {status}: {body}`;
- poll failures → journal log + status `ПОМИЛКА API`.

UI surfaces these via `MessageBox` in Channels, YouTube stream settings, and moderation.

## Demonstrable against a real YouTube account

Yes, for the implemented methods, if:

1. Google Cloud OAuth Desktop client is configured with redirect `http://127.0.0.1:17847/`;
2. YouTube Data API v3 is enabled;
3. the same Google account has a **live** broadcast with chat;
4. the compliance patch is applied so YOUTUBE ЕФІР, RMF dialogs, channels.list, and unban are visible.

Cannot be demonstrated from this client: `liveStreams.list` ingest objects and `liveChatModerators.*`.
