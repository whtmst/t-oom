# T-OoM: About / Описание

EN: **T-OoM** - is a simple Out of Mana announcer addon for [Turtle WoW](https://turtle-wow.org/#/home).

RU: **T-OoM** - это простой аддон для объявления об окончании маны для сервера [Turtle WoW](https://turtle-wow.org/#/home).

---

# T-OoM: Download
### Installation (Turtle WoW)
1. Download: **[Latest Version](https://github.com/whtmst/t-oom/archive/master.zip)**
2. Unpack the Zip file "t-oom-main.zip"
3. Find "T-OoM" folder inside "t-oom-main" folder
4. Copy "T-OoM" folder into \Interface\AddOns
5. Restart game

# T-OoM: Скачать
### Установка (Turtle WoW)
1. Скачайте: **[Последняя версия](https://github.com/whtmst/t-oom/archive/master.zip)**
2. Распакуйте Zip-файл "t-oom-main.zip"
3. Найдите папку "T-OoM" внутри папки "t-oom-main"
4. Скопируйте папку "T-OoM" в \Interface\AddOns
5. Перезапустите игру

---

# T-OoM: Settings / Настройки

EN: All settings are stored in the file "T-OoM.lua" in the section "-- SETTINGS (НАСТРОЙКИ)". **I recommend making changes only when absolutely necessary, as they are configured for maximum convenience.**

RU: Все настройки храняться в файле "T-OoM.lua" в блоке "-- SETTINGS (НАСТРОЙКИ)". **Советую менять только при очень сильной необходимости, так как они настроены максимально удобно.**

---

* local outOfManaMessage = "--- OUT OF MANA ---"  -- Message at 5% of mana (Сообщение при 5% маны)
* local lowManaMessage = "--- LOW MANA ---"  -- Message at 25% of mana (Сообщение при 25% маны)
* local mana50Message = "--- MANA IS 50% ---"  -- Message at 50% of mana (Сообщение при 50% маны)
* local chatChannel = "PARTY"  -- You can change the channel, for example, to "RAID" or "SAY" (channel for sending messages) (Вы можете изменить чат, например, на "RAID" или "SAY" (чат для отправки сообщений))
* local lowManaThreshold1 = 0.50 -- Threshold 50% of mana (Порог 50% маны)
* local lowManaThreshold2 = 0.25 -- Threshold 25% of mana (Порог 25% маны)
* local lowManaThreshold3 = 0.05 -- Threshold 5% of mana (Порог 5% маны)
* local messageDuration = 3  -- Message display duration in seconds (Время отображения сообщения в секундах)
* local fontSize = 96  -- Font size for the custom message (Размер шрифта для собственного сообщения)
* local frameColor = {0, 0, 0, 0}  -- Frame color with transparency (Цвет фрейма с прозрачностью)
* local fontColor = {1, 1, 1, 1}  -- Font color with transparency (Цвет шрифта с прозрачностью)
* local fontPath = "Interface\\AddOns\\T-OoM\\Fonts\\ARIALN.ttf"  -- File path to the custom font (Путь к файлу собственного шрифта)

---

# T-OoM: Credits / Благодарности

EN: You are welcome to enhance this addon, but you must always provide a link to the original version at **[https://github.com/whtmst/t-oom](https://github.com/whtmst/t-oom)**.

RU: Вы можете усовершенствовать данный аддон, но вы обязаны всегда предоставлять ссылку на оригинальную версию по адресу **[https://github.com/whtmst/t-oom](https://github.com/whtmst/t-oom)**.

---

# T-OoM: IMPORTANT / ВАЖНО

EN: I do not create add-ons on request and do not fix errors in other add-ons, please do not contact me with such requests.

RU: Я не пишу аддоны на заказ и не исправляю ошибки в других аддонах, просьба не писать мне с такими вопросами.

