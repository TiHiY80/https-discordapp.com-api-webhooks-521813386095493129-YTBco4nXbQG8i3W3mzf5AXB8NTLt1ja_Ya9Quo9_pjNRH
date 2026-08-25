# Сценарій запису (після патча клієнта)

Один дубль 8–15 хв. Коментар англійською бажаний.

## До камери

1. Накладіть патч і зберіть клієнт (`APPLY-CLIENT-PATCH-UA.md`).
2. YouTube Studio → Go live → **Unlisted**, чат увімкнений.
   Назва: `TiHiY StreamControl Center API compliance test`.
3. Другий YouTube-акаунт пише в чат. Сторонніх не модеруємо.
4. У **КАНАЛИ** поле Client Secret порожнє або розмите
   (секрет уже в Credential Manager).
5. Не відкривайте Discord/Twitch secret, Credential Manager, логи з token.

## Дубль

### 0:00 Старт
TiHiY StreamControl Center на екрані.

### OAuth + авторизований канал
1. **КАНАЛИ**
2. YouTube → **АВТОРИЗУВАТИ** (Desktop loopback `http://127.0.0.1:17847/`)
3. Google consent
4. Показати read-only поля: назва каналу + `https://www.youtube.com/channel/...`
   (це `channels.list mine=true`)
5. Закрити вікно так, щоб secret не лишився в кадрі

### Broadcast data
1. Модуль **YOUTUBE ЕФІР**
2. **ОНОВИТИ СПИСОК**
3. Combo: title • lifeCycleStatus • час
4. Стан `LIVE`, URL `youtube.com/watch?v=...`
5. Рядок «Авторизований канал» зверху вікна

### Statistics
Головне вікно, блок YouTube: 👁 viewers, ♥ likes, **LIVE**,
статус `В ЕФІРІ • {title}`.

### Chat
З другого акаунта 2 повідомлення. У мультичаті іконка YouTube,
ім’я, текст. Tooltip рядка = channel URL.

### Send
Поле вводу → кнопка **YOUTUBE** →
`API compliance test message from StreamControl Center`.

### Delete
ПКМ по YouTube-повідомленню → **Видалити повідомлення**.

### Timeout
ПКМ по тестовому глядачу → **Мут на 10 хвилин**.
Діалог мусить показати:
- Target YouTube channel + Target channel URL
- Acting YouTube account + Acting channel URL  
Yes.

### Ban
ПКМ → **Забанити користувача**. Той самий діалог для permanent ban. Yes.

### Unban
ПКМ → **Зняти бан YouTube**. Той самий діалог. Yes.

### Фінал
Головне вікно: LIVE, статистика, чат. Одна фраза:
дані лише для каналу, який пройшов OAuth.

Заповніть таймкоди в `05-TIMECODES-TEMPLATE-EN.txt` і вставте їх
у `06-EMAIL-FINAL-SEND-THIS-EN.txt`.
