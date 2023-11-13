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

* local lowManaMsg = "--- LOW ON MANA ---"  -- Message at 30% of mana (Сообщение при 30% маны)
* local criticalLowManaMsg = "--- CRITICAL LOW MANA ---"  -- Message at 15% of mana (Сообщение при 15% маны)
* local outOfManaMessage = "--- OUT OF MANA ---"  -- Message at 5% of mana (Сообщение при 5% маны)
* local chatChannel = "PARTY"  -- You can change the channel, for example, to "RAID" or "SAY" (channel for sending messages) (Вы можете изменить чат, например, на "RAID" или "SAY" (чат для отправки сообщений))
* local lowManaThreshold1 = 0.30 -- Threshold 30% of mana (Порог 30% маны)
* local lowManaThreshold2 = 0.15 -- Threshold 15% of mana (Порог 15% маны)
* local lowManaThreshold3 = 0.05 -- Threshold 5% of mana (Порог 5% маны)
* local messageDuration = 3  -- Message display duration in seconds (Время отображения сообщения в секундах)
* local fontSize = 96  -- Font size for the custom message (Размер шрифта для собственного сообщения)
* local frameColor = {0, 0, 0, 0}  -- Frame color with transparency (Цвет фрейма с прозрачностью)
* local fontColor = {1, 1, 1, 1}  -- Font color with transparency (Цвет шрифта с прозрачностью)
* local fontPath = "Interface\\AddOns\\T-OoM\\Fonts\\ARIALN.ttf"  -- File path to the custom font (Путь к файлу собственного шрифта)

**Set to true to enable the respective instance type (Установите true, чтобы включить соответствующий тип инстанса)**
* local instanceTypeOptions = { 
    * none = false, -- When outside an instance (В открытом мире)
    * party = true, -- In 5-man instances (В подземельях на 5-человек)
    * raid = false, -- In raid instances (В рейдах)
    * arena = false, -- In arenas (На арене)
    * pvp = false, -- In battlegrounds (На полях боя)
    * scenario = false -- In scenarios (В сценариях)
* }

---

# T-OoM: Credits / Благодарности

EN: You are welcome to enhance this addon, but you must always provide a link to the original version at **[https://github.com/whtmst/t-oom](https://github.com/whtmst/t-oom)**.

RU: Вы можете усовершенствовать данный аддон, но вы обязаны всегда предоставлять ссылку на оригинальную версию по адресу **[https://github.com/whtmst/t-oom](https://github.com/whtmst/t-oom)**.

---

# T-OoM: IMPORTANT / ВАЖНО

EN: I do not create add-ons on request and do not fix errors in other add-ons, please do not contact me with such requests.

RU: Я не пишу аддоны на заказ и не исправляю ошибки в других аддонах, просьба не писать мне с такими вопросами.

---

<h3 align="center">Wow, finished reading!😌 Hit me up if anything!</h3>

---
<p align="center">
    <a href="https://www.donationalerts.com/r/whtmst"><img src="https://img.shields.io/static/v1?logo=BUY-ME-A-COFFEE&label=&labelColor=131313&logoColor=FFFFFF&logoWidth=20&message=BUY ME A COFFEE&color=f58407&style=flat-square" alt="BUY ME A COFFEE" height="25"></a>
    <a href="https://boosty.to/whtmst"><img src="https://img.shields.io/static/v1?logo=COFFEESCRIPT&label=&labelColor=131313&logoColor=FFFFFF&logoWidth=20&message=BOOSTY&color=f0682a&style=flat-square" alt="BOOSTY" height="25"></a>
</p>

