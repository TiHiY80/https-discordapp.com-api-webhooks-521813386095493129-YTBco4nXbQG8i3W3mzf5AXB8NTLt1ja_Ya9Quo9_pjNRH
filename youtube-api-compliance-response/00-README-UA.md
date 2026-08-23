# Повна відповідь на second notice

Лист Google просить **одне відео реального клієнта** + письмове пояснення.
Форму audit/quota **повторно не подаємо**. Відповідь = **Reply** на їхній email.

## Що вже зроблено тут

1. **`06-EMAIL-FINAL-SEND-THIS-EN.txt`** — повний текст Reply.
   Вам лишилось вписати 4 поля: GCP name / number / id, OAuth client ID,
   лінк на відео, таймкоди.
2. **`03-API-USAGE-STATEMENT-EN.md`** — додаток по методах (можна прикріпити).
3. **`client-patches/`** — патч клієнта, без якого відео не закриє RMF
   (кнопка ефіру, `channels.list`, діалоги target/acting URL, unban).
4. Сценарій зйомки й чеклист оновлені під цей патч.

## Що можу зробити лише ви (технічно неможливо з цього середовища)

- Увійти у ваш Google-акаунт і пройти OAuth.
- Запустити Windows WPF клієнт і зняти живий unlisted ефір.
- Натиснути Send у Gmail від вашого API contact.

Без цього кроку Google **не прийме** відповідь: вони явно просять screencast.

## Ваш мінімальний порядок

1. Накласти патч і зібрати клієнт (`APPLY-CLIENT-PATCH-UA.md`).
2. Unlisted тест-ефір + другий акаунт у чаті.
3. Записати один ролик за `02-SCREENCAST-SCRIPT-UA.md`.
4. Unlisted YouTube або Drive (anyone with the link).
5. Відкрити `06-EMAIL-FINAL-SEND-THIS-EN.txt`, вставити GCP + лінк + таймкоди.
6. Reply All на лист YouTube API Services Team з `tihiy80tv@gmail.com`.
