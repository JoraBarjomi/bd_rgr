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

ALTER TABLE network_elements
ADD CONSTRAINT chk_ne_status 
CHECK (status IN ('active', 'down', 'maintenance', 'unknown'));

ALTER TABLE interfaces
ADD CONSTRAINT chk_iface_status 
CHECK (status IN ('up', 'down', 'testing'));

ALTER TABLE event_types
ADD CONSTRAINT chk_event_severity 
CHECK (severity IN ('info', 'warning', 'critical'));

ALTER TABLE alarms
ADD CONSTRAINT chk_alarm_severity 
CHECK (severity IN ('warning', 'critical', 'major'));

ALTER TABLE alarms
ADD CONSTRAINT chk_alarm_dates 
CHECK (resolved_at > created_at OR resolved_at IS NULL);

ALTER TABLE network_elements ALTER COLUMN name SET NOT NULL;
ALTER TABLE events ALTER COLUMN network_element_id SET NOT NULL;
ALTER TABLE events ALTER COLUMN event_type_id SET NOT NULL;
ALTER TABLE metrics ALTER COLUMN metric_name SET NOT NULL;
ALTER TABLE metrics ALTER COLUMN metric_value SET NOT NULL;

CREATE INDEX idx_events_timestamp ON events(timestamp);

CREATE INDEX idx_alarms_ne ON alarms(network_element_id);
CREATE INDEX idx_alarms_created ON alarms(created_at);

CREATE INDEX idx_metrics_iface_time ON metrics(interface_id, timestamp);

ALTER TABLE network_elements_type ADD CONSTRAINT uq_net_type_name UNIQUE (name);
ALTER TABLE manufacturer ADD CONSTRAINT uq_manufacturer_name UNIQUE (name);
ALTER TABLE manufacturer ADD CONSTRAINT uq_manufacturer_email UNIQUE (email);
ALTER TABLE event_types ADD CONSTRAINT uq_event_type_name UNIQUE (name);
ALTER TABLE network_elements ADD CONSTRAINT uq_ne_name UNIQUE (name);
ALTER TABLE network_elements ADD CONSTRAINT uq_ne_ip UNIQUE (ip);
ALTER TABLE interfaces ADD CONSTRAINT uq_iface_ne_name UNIQUE (network_element_id, if_name);
ALTER TABLE interfaces ADD CONSTRAINT uq_iface_ne_index UNIQUE (network_element_id, if_index);

CREATE INDEX idx_ne_status ON network_elements(status);