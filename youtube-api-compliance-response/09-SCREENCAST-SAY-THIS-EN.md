# English screencast — say this, click this

Google asked for a step-by-step screencast **in English**.
The app buttons stay Ukrainian. You **speak English** and name each button.

Record with Windows: **Win + Alt + R** (Xbox Game Bar). Stop with the same keys.
Or OBS scene, if it is already running.

One take, 8–12 minutes. Do not show Client Secret, tokens, Discord, Twitch secrets.

Before record:
- YouTube Studio → Go live → **Unlisted**, chat ON
- Title: `TiHiY StreamControl Center API compliance test`
- Second YouTube account ready to type in chat (only that account for mute/ban)

---

Start recording. Speak slowly.

**1. Start**
Say: “This is TiHiY StreamControl Center, a desktop API client for a content creator to manage their own YouTube live stream.”

**2. OAuth**
Click **КАНАЛИ**.
Say: “I open Channels. This is YouTube OAuth for a Desktop app. Redirect URI is http://127.0.0.1:17847/. The only scope is youtube.force-ssl.”
Click **АВТОРИЗУВАТИ**. Complete Google consent.
Point to channel name and `https://www.youtube.com/channel/...`
Say: “After login the client calls channels.list mine=true. This is the authenticated YouTube channel. All later API calls use this account.”
Close the window so the secret field is not visible.

**3. Broadcast data**
Click **YOUTUBE ЕФІР**. Click **ОНОВИТИ СПИСОК**.
Say: “This list is liveBroadcasts.list with mine=true. Here is the broadcast title, lifeCycleStatus LIVE, privacy, and the watch URL.”
Point at title, LIVE, URL.

**4. Statistics**
Go back to the main window. Point at YouTube viewers, likes, LIVE.
Say: “These numbers come from videos.list, parts liveStreamingDetails and statistics: concurrent viewers and like count. End result: the console shows the live broadcast state.”

**5. Chat read**
Have the second account send two messages.
Say: “Incoming messages are liveChatMessages.list. The UI shows the author’s display name, the text, and the author’s channel URL.”

**6. Send**
Type `API compliance test from StreamControl Center`. Click **YOUTUBE**.
Say: “This send is liveChatMessages.insert as the authenticated creator. End result: the message appears in live chat.”

**7. Delete**
Right-click that YouTube message → **Видалити повідомлення**.
Say: “This is liveChatMessages.delete. End result: the message is removed.”

**8. Timeout**
Right-click the test viewer → **Мут на 10 хвилин**.
Read the dialog out loud:
“Target YouTube channel … Target channel URL … Acting YouTube account … Acting channel URL.”
Click Yes.
Say: “This is liveChatBans.insert, temporary. The dialog identifies the target channel and the acting account, as required.”

**9. Ban**
Right-click → **Забанити користувача**. Read the same dialog. Yes.
Say: “This is liveChatBans.insert, permanent. End result: the test channel is banned from this live chat.”

**10. Unban**
Right-click → **Зняти бан YouTube**. Read the dialog. Yes.
Say: “This is liveChatBans.delete. End result: the ban is removed.”

**11. Close**
Show main window LIVE + chat.
Say: “End result of the full workflow: the signed-in creator’s own broadcast, statistics, and chat, using YouTube API Services only for this authenticated channel.”

Stop recording.

Upload as **unlisted** YouTube or Google Drive (anyone with the link).
Paste the link into `СКОПІЮЙ-У-GMAIL-ПІСЛЯ-ВІДЕО.txt` and Reply in the same Gmail thread.
