DROP TABLE IF EXISTS alarms, metrics, events, interfaces, network_elements, event_types, manufacturer, network_elements_type CASCADE;

CREATE TABLE network_elements_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE manufacturer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE event_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    severity VARCHAR(50)
);

CREATE TABLE network_elements (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    ip VARCHAR(255),
    network_element_type_id INT REFERENCES network_elements_type(id),
    manufacturer_id INT REFERENCES manufacturer(id),
    status VARCHAR(50)
);

CREATE TABLE interfaces (
    id SERIAL PRIMARY KEY,
    network_element_id INT REFERENCES network_elements(id),
    if_name VARCHAR(255),
    if_index INT,
    speed INT,
    status VARCHAR(50)
);

CREATE TABLE metrics (
    id SERIAL PRIMARY KEY,
    interface_id INT REFERENCES interfaces(id),
    timestamp TIMESTAMP,
    metric_name VARCHAR(255),
    metric_value INT
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    network_element_id INT REFERENCES network_elements(id),
    event_type_id INT REFERENCES event_types(id),
    is_alarm BOOLEAN,
    timestamp TIMESTAMP,
    message TEXT
);

CREATE TABLE alarms (
    id SERIAL PRIMARY KEY,
    network_element_id INT REFERENCES network_elements(id),
    event_id INT REFERENCES events(id),
    severity VARCHAR(50),
    created_at TIMESTAMP,
    resolved_at TIMESTAMP
);