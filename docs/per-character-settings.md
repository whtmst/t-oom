# T-OoM: Персонажные настройки (Per-Character Settings)

## Обзор изменений / Changes Overview

**RU:** С версии 1.0.0 Beta аддон T-OoM использует персонажные настройки. Это означает:
- Каждый персонаж имеет собственную конфигурацию
- Настройки не наследуются между персонажами
- Каждый персонаж может использовать разный язык интерфейса
- Настройки сохраняются автоматически при изменении

**EN:** Starting from version 1.0.0 Beta, T-OoM addon uses per-character settings. This means:
- Each character has its own configuration
- Settings are not inherited between characters  
- Each character can use different interface language
- Settings are saved automatically when changed

## Расположение файлов настроек / Settings File Location

**Старое расположение (глобальные настройки):**
```
WTF/Account/[AccountName]/SavedVariables/T-OoM.lua
```

**Новое расположение (персонажные настройки):**
```
WTF/Account/[AccountName]/[ServerName]/[CharacterName]/SavedVariables/T-OoM.lua
```

**Пример для персонажа Skoofeedon на сервере Nordanaar:**
```
WTF/Account/WHTMST/Nordanaar/Skoofeedon/SavedVariables/T-OoM.lua
```

## Миграция настроек / Settings Migration

При первом запуске аддона с новой версией:
1. Аддон создаст новые персонажные настройки с значениями по умолчанию
2. Старые глобальные настройки (если есть) не будут автоматически перенесены
3. Каждому персонажу потребуется настроить аддон заново

## Команды управления / Management Commands

Все команды остаются теми же:
- `/toom help` - справка по командам
- `/toom lang <en/ru>` - смена языка интерфейса
- `/toom test` - тестирование функциональности
- `/toom-test-perchar` - тест персонажных настроек (новая команда)

## Технические детали / Technical Details

**Изменения в коде:**
- В файле `T-OoM.toc` изменено `SavedVariables` на `SavedVariablesPerCharacter`
- Логика инициализации настроек остается прежней
- Переменная `T_OoM_Settings` по-прежнему используется для доступа к настройкам

**Структура данных остается без изменений:**
```lua
T_OoM_Settings = {
    language = "auto",
    lowManaThreshold = 20,
    criticalLowManaThreshold = 5,
    enabledChannels = { ... },
    -- и другие настройки
}
```

## Преимущества персонажных настроек / Benefits

1. **Гибкость** - разные персонажи могут использовать разные настройки
2. **Изоляция** - изменения на одном персонаже не влияют на других
3. **Язык интерфейса** - каждый персонаж может использовать удобный язык
4. **Безопасность** - сброс настроек затрагивает только текущего персонажа
