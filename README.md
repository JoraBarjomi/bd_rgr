<a id="readme-top"></a>

<br />
<div align="center">
  <a href="https://github.com/JoraBarjomi/bd_rgr">
    <img src="./logo.svg" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">NMS</h3>

  <p align="center">
    Реляционная база данных для мониторинга и управления телекоммуникационной сетью
    <br />
    <br />
    <a href="https://github.com/JoraBarjomi/bd_rgr/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/JoraBarjomi/bd_rgr/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

<details>
  <summary>Содержание</summary>
  <ol>
    <li><a href="#о-проекте">О проекте</a>
      <ul>
        <li><a href="#описание-предметной-области">Описание предметной области</a></li>
        <li><a href="#функциональные-задачи">Функциональные задачи</a></li>
        <li><a href="#технологии">Технологии</a></li>
      </ul>
    </li>
    <li><a href="#о-проекте">Структура проекта</a></li>
    <li><a href="#быстрый-старт">Быстрый старт</a>
      <ul>
        <li><a href="#требования">Требования</a></li>
        <li><a href="#установка-и-проверка">Установка</a></li>
      </ul>
    </li>
  </ol>
</details>

## О проекте

<div align="center">
  <a href="https://postimg.cc/RqdkN7kW">
    <img src="https://i.postimg.cc/6Q6BMD6c/Diagram-Dark.png" alt="NMS - Database Diagram" width="100%">
  </a>
  <p><em>ER-диаграмма логической модели данных</em></p>
</div>

<br />

### Описание предметной области

**Тема:** Система управления и мониторинга телекоммуникационной сети.

Учёт сетевой инфраструктуры, сбор эксплуатационных метрик, регистрацию событий и обработку аварийных ситуаций в сети оператора связи.

### Функциональные задачи

| Задача                        | Описание                                                                                                                               |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| **Учёт оборудования**         | Ведение реестра сетевых элементов (маршрутизаторы, коммутаторы, базовые станции), их производителей и типов.                           |
| **Учёт портов и интерфейсов** | Хранение информации о физических и логических интерфейсах устройств (скорость, статус, индексы).                                       |
| **Сбор метрик**               | Накопление временных рядов по ключевым показателям (загрузка CPU, трафик на интерфейсе, температура) с привязкой к временной метке.    |
| **Регистрация событий**       | Протоколирование всех системных событий (перезагрузки, изменения конфигурации, обнаружение ошибок) с типизацией и уровнем критичности. |
| **Управление авариями**       | Автоматическое/ручное создание инцидентов на основе критических событий, отслеживание статуса их разрешения.                           |
| **Аналитика и отчётность**    | Формирование агрегированных отчётов по загрузке оборудования, статистике аварий, активности событий за заданный период.                |

### Технологии

![PostgreSQL][PGSQL]
![Docker][Docker]
![Draw.io][Drawio]

## Проектные решения

### Ограничения целостности

| Ограничение | Применение | Обоснование |
|-------------|------------|-------------|
| `PRIMARY KEY` | Все таблицы | Уникальная идентификация каждой сущности |
| `FOREIGN KEY` | Связи между таблицами | Обеспечение ссылочной целостности данных |
| `NOT NULL` | Обязательные атрибуты (`name`, `network_element_id`, `metric_name` и др.) | Исключение неполных записей для критичных полей |
| `UNIQUE` | `ip`, `name`, `email`, пары `NE + интерфейс` | Предотвращение дублирования уникальных идентификаторов оборудования, адресов и учётных данных |
| `CHECK` | Статусы, `severity`, временные интервалы | Контроль бизнес-логики: допустимые значения статусов, корректность диапазонов дат (`resolved_at > created_at`) |

### Стратегия индексации

| Индекс | Поле(я) | Обоснование |
|--------|---------|-------------|
| `idx_events_timestamp` | `events(timestamp)` | Ускорение выборок событий за временной период |
| `idx_alarms_ne` | `alarms(network_element_id)` | Быстрый поиск активных аварий по устройству |
| `idx_alarms_created` | `alarms(created_at)` | Сортировка и фильтрация аварий по дате возникновения |
| `idx_metrics_iface_time` | `metrics(interface_id, timestamp)` | Композитный индекс для аналитики метрик интерфейса во времени |
| `idx_ne_status` | `network_elements(status)` | Фильтрация устройств по статусу (`down`, `maintenance` и т.д.) |

## Быстрый старт

### Требования

- PostgreSQL 14+
- `psql` или любой SQL-клиент (DBeaver, DataGrip, pgAdmin)

### Установка и проверка

1.  Клонировать репозиторий
    ```sh
    git clone https://github.com/JoraBarjomi/bd_rgr
    ```
2.  Создать базу данных
    ```sh
    createdb nms_db
    ```
3.  Инициализировать схему
    ```sh
    psql -d nms_db -f schema.sql
    ```
4.  Наполнить тестовыми данными
    ```sh
    psql -d nms_db -f seed.sql
    ```
5.  Выполнить аналитические запросы
    ```sh
    psql -d nms_db -f queries.sql
    ```
6.  (Опционально) Проверить функции и триггеры
    ```sh
    psql -d nms_db -f demo.sql
    ```

### Авторы:

<a href="https://github.com/JoraBarjomi/bd_rgr/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=JoraBarjomi/bd_rgr" alt="contrib.rocks image" />
</a>

[PGSQL]: https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white
[Docker]: https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white
[Drawio]: https://img.shields.io/badge/Draw.io-F08705?style=for-the-badge&logo=diagrams.net&logoColor=white

