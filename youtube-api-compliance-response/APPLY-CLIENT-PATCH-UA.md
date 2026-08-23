# Як накласти патч клієнта (обов’язково перед відео)

У публічному репозиторії StreamControl Center кнопки **YOUTUBE ЕФІР**,
діалоги RMF (ім’я + URL цілі + хто діє) і `channels.list` / unban
з’явились у цих файлах. Без збірки з патчем відео для Google буде слабшим.

Пуш у `sergsivak-lang/TiHiY-StreamControl-Center` з цього середовища
недоступний (немає write). Патч лежить тут.

## Варіант A — git apply (якщо є клон source)

```bat
cd /d "ШЛЯХ\ДО\TiHiY-StreamControl-Center"
git apply --whitespace=nowarn youtube-api-compliance-response\client-patches\streamcontrol-compliance.patch
START-HERE.cmd
```

Або скопіюйте файли з `client-patches\` поверх відповідних шляхів у клоні
і зберіть `START-HERE.cmd`.

## Варіант B — папка з завантаженнями

`F:\Загрузки\TiHiY Stream Studio\стрім контрол\TiHiY-StreamControl-MINI-AIMP-COMPACT-OPACITY-win-x64`
це вже зібраний EXE. Патч треба накласти на **source** з
https://github.com/sergsivak-lang/TiHiY-StreamControl-Center
і перезібрати. Просто замінити файли всередині win-x64 папки не вийде.

## Що змінює патч

- кнопка **YOUTUBE ЕФІР** відкриває список `liveBroadcasts.list`;
- після OAuth викликається `channels.list?mine=true`, у UI видно назву і URL каналу;
- ban / timeout / unban: діалог англійською з target channel URL і acting account URL;
- `liveChatBans.delete` для бану, зробленого в цій сесії;
- фейкові кнопки «ДОДАТИ ПІДПИСНИКА / МОДЕРАТОРА» вимкнені.
