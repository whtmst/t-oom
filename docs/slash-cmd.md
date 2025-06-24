# Слеш команды T-OoM

## Синтаксис
```
/toom <команда> [параметры]
```

## Команды

| Команда | Описание | Пример |
|---------|----------|--------|
| `test` / `check` | Быстрый тест функциональности | `/toom test` |
| `testorder` / `order` | Тест порядка настроек | `/toom testorder` |
| `config` / `settings` | Окно настроек (🚧 в разработке) | `/toom config` |
| `export` | Экспорт настроек в чат | `/toom export` |
| `lang <код>` / `language <код>` | Смена языка (`en`/`ru`) | `/toom lang ru` |
| `help` / *(пусто)* | Справка по командам | `/toom help` |

## Локализация

**English:**
- `/toom test` - Run quick functionality test
- `/toom export` - Export current settings to chat  
- `/toom lang <en/ru>` - Change language

**Русский:**
- `/toom test` - Запустить быстрый тест функций
- `/toom export` - Экспортировать настройки в чат
- `/toom lang <en/ru>` - Изменить язык

## Особенности
- Команды не чувствительны к регистру
- При ошибке: `T-OoM: Unknown command. Use /toom help`
- Проверка доступности модулей перед выполнением
