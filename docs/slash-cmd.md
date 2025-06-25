# Слеш команды T-OoM

## Синтаксис
```
/toom <команда> [параметры]
```

## Команды

| Команда | Описание | Пример |
|---------|----------|--------|
| `test` | Быстрый тест функциональности | `/toom test` |
| `status` | Проверка статуса глобальных функций | `/toom status` |
| `testorder` | Тест порядка настроек | `/toom testorder` |
| `testmana` | Тест модуля мониторинга маны (Этап 3.1) | `/toom testmana` |
| `testui` | Тест модуля отображения UI (Этап 3.2) | `/toom testui` |
| `testui_mana` | Тест UI с событиями маны (Этап 3.2) | `/toom testui_mana` |
| `config` | Окно настроек (🚧 в разработке) | `/toom config` |
| `export` | Экспорт настроек в чат | `/toom export` |
| `lang <код>` | Смена языка (`en`/`ru`) | `/toom lang ru` |
| `help` / *(пусто)* | Справка по командам | `/toom help` |

## Локализация

**English:**
- `/toom test` - Run quick functionality test
- `/toom status` - Check global test functions status
- `/toom testorder` - Test settings keys order
- `/toom testmana` - Test mana monitor module (Stage 3.1)
- `/toom testui` - Test UI display module (Stage 3.2)
- `/toom testui_mana` - Test UI display with mana events (Stage 3.2)
- `/toom config` - Open configuration window
- `/toom export` - Export current settings to chat  
- `/toom lang <en/ru>` - Change language
- `/toom help` - Show this help message

**Русский:**
- `/toom test` - Запустить быстрый тест функций
- `/toom status` - Проверить статус глобальных функций тестов
- `/toom testorder` - Тест порядка настроек
- `/toom testmana` - Тест модуля мониторинга маны (Этап 3.1)
- `/toom testui` - Тест модуля отображения UI (Этап 3.2)
- `/toom testui_mana` - Тест UI с событиями маны (Этап 3.2)
- `/toom config` - Открыть окно настроек
- `/toom export` - Экспортировать настройки в чат
- `/toom lang <en/ru>` - Изменить язык
- `/toom help` - Показать это сообщение помощи

## Особенности
- Команды не чувствительны к регистру
- При неизвестной команде: `T-OoM: Unknown command. Use /toom help`
- Проверка доступности модулей перед выполнением команд
- Все алиасы команд удалены для упрощения (Этап 3.3)
- Команда `/toom status` добавлена для диагностики глобальных функций

## Архитектура команд
- **Основные команды** выполняются через модульную систему `T_OoM_Modules`
- **Тестовые команды** используют глобальные функции из `test_module.lua`:
  - `T_OoM_SettingsOrderTest()`
  - `T_OoM_ManaMonitorTest()`
  - `T_OoM_UIDisplayTest()`
  - `T_OoM_UIDisplayManaEventsTest()`
- **Все тексты** локализованы через систему `L()` с fallback на английский
