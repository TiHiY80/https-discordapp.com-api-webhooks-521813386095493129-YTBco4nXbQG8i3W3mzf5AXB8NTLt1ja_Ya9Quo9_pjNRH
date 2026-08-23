# Чеклист перед відправкою листа

## Підготовка ефіру

- [ ] YouTube Studio → Go live → **Unlisted** (або Private, якщо чат працює)
- [ ] Live Chat увімкнено
- [ ] Другий акаунт готовий писати в чат
- [ ] Нікого стороннього не модеруємо

## Клієнт

- [ ] Збірка з https://github.com/sergsivak-lang/TiHiY-StreamControl-Center
- [ ] Додано кнопку **YOUTUBE ЕФІР** → `OpenYouTubeSettings_Click` (див. сценарій)
- [ ] YouTube Data API v3 увімкнено в Google Cloud
- [ ] OAuth Desktop + redirect `http://127.0.0.1:17847/`
- [ ] Scope у згоді лише YouTube (`youtube.force-ssl`)
- [ ] Client Secret не в кадрі
- [ ] Автопідключення YouTube можна лишити увімкненим

## Зйомка

- [ ] Один суцільний запис (не слайдшоу зі скрінів)
- [ ] Не натискали фейкові кнопки в «ЧАТ І БОТ»
- [ ] Показано: OAuth, список/стан ефіру, viewers/likes, вхідний чат, send, delete, mute/ban
- [ ] Не заявлено unban / liveStreams / moderators API
- [ ] Відео unlisted YouTube **або** Drive: anyone with the link can view

## Лист

- [ ] Відповідь **Reply** на їхній email (не нова форма)
- [ ] Той самий контакт, що в API-проєкті; за потреби CC
- [ ] Вписано Project number, Project ID, OAuth client ID
- [ ] Вписано requested quota + коротке обґрунтування
- [ ] Вставлено лінк на відео
- [ ] Заповнені таймкоди з `05-TIMECODES-TEMPLATE-EN.txt`
- [ ] У листі лише методи, які є в `YouTubeService.cs`

## Після відправки

- [ ] Збережіть копію листа і лінк на відео
- [ ] Не видаляйте unlisted відео, поки review відкритий
- [ ] Якщо попросять test login — відповідайте в тому ж треді
