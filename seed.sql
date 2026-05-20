TRUNCATE TABLE alarms, metrics, events, interfaces, network_elements, event_types, manufacturer, network_elements_type RESTART IDENTITY CASCADE;

ALTER TABLE events DISABLE TRIGGER trg_event_create_alarm;

INSERT INTO network_elements_type (id, name) VALUES
(1, 'Router'),
(2, 'Switch'),
(3, 'Base Station'),
(4, 'Firewall');

INSERT INTO manufacturer (id, name, email) VALUES
(1, 'Cisco', 'support@cisco.com'),
(2, 'Juniper', 'support@juniper.net'),
(3, 'Huawei', 'support@huawei.com'),
(4, 'Nokia', 'support@nokia.com');

INSERT INTO event_types (id, name, severity) VALUES
(1, 'Device Down', 'critical'),
(2, 'High CPU', 'warning'),
(3, 'Link Flap', 'warning'),
(4, 'Config Change', 'info');

INSERT INTO network_elements (id, name, ip, network_element_type_id, manufacturer_id, status) VALUES
(1, 'Core-Router-01', '10.0.0.1', 1, 1, 'active'),
(2, 'Edge-Switch-02', '10.0.1.2', 2, 3, 'active'),
(3, 'BaseStation-Alpha', '10.0.2.3', 3, 4, 'down'),
(4, 'FW-Perimeter-01', '10.0.3.4', 4, 1, 'maintenance'),
(5, 'Agg-Switch-01', '10.0.4.5', 2, 2, 'active'),
(6, 'BaseStation-Beta', '10.0.5.6', 3, 3, 'active');

INSERT INTO interfaces (id, network_element_id, if_name, if_index, speed, status) VALUES
(1, 1, 'Gi0/0/0', 1, 1000, 'up'),
(2, 1, 'Gi0/0/1', 2, 1000, 'up'),
(3, 1, 'Te0/1/0', 3, 10000, 'up'),
(4, 2, 'eth0', 1, 1000, 'down'),
(5, 2, 'eth1', 2, 1000, 'up'),
(6, 3, 'rf0', 1, 100, 'down'),
(7, 4, 'eth0', 1, 1000, 'testing'),
(8, 5, 'eth0', 1, 10000, 'up');

INSERT INTO metrics (id, interface_id, timestamp, metric_name, metric_value) VALUES
(1, 1, '2025-05-18 10:00:00', 'traffic', 450),
(2, 1, '2025-05-18 11:00:00', 'traffic', 520),
(3, 2, '2025-05-18 10:00:00', 'traffic', 120),
(4, 3, '2025-05-18 10:00:00', 'traffic', 890),
(5, 1, '2025-05-18 10:00:00', 'cpu_load', 35),
(6, 1, '2025-05-18 11:00:00', 'cpu_load', 42),
(7, 2, '2025-05-18 10:00:00', 'cpu_load', 15),
(8, 5, '2025-05-18 10:00:00', 'traffic', 2100),
(9, 5, '2025-05-18 10:00:00', 'cpu_load', 28),
(10, 6, '2025-05-18 10:00:00', 'temperature', 55),
(11, 6, '2025-05-18 11:00:00', 'temperature', 58),
(12, 8, '2025-05-18 10:00:00', 'traffic', 1500);

INSERT INTO events (id, network_element_id, event_type_id, is_alarm, timestamp, message) VALUES
(1, 1, 4, FALSE, '2025-05-18 09:30:00', 'Configuration backup completed'),
(2, 3, 1, TRUE, '2025-05-18 08:15:00', 'Critical: RF module failure'),
(3, 1, 2, TRUE, '2025-05-18 10:45:00', 'CPU load exceeded 80%'),
(4, 2, 3, TRUE, '2025-05-18 07:20:00', 'Link flapping detected on eth0'),
(5, 5, 2, TRUE, '2025-05-18 12:00:00', 'CPU load high'),
(6, 6, 4, FALSE, '2025-05-18 11:30:00', 'Scheduled maintenance window started'),
(7, 4, 1, TRUE, '2025-05-18 06:00:00', 'Firewall unresponsive'),
(8, 1, 3, TRUE, '2025-05-18 13:10:00', 'Uplink unstable');

INSERT INTO alarms (id, network_element_id, event_id, severity, created_at, resolved_at) VALUES
(1, 3, 2, 'critical', '2025-05-18 08:15:00', NULL),
(2, 1, 3, 'warning', '2025-05-18 10:45:00', NULL),
(3, 2, 4, 'warning', '2025-05-18 07:20:00', NULL),
(4, 5, 5, 'warning', '2025-05-18 12:00:00', '2025-05-18 12:30:00'),
(5, 4, 7, 'critical', '2025-05-18 06:00:00', NULL),
(6, 1, 8, 'warning', '2025-05-18 13:10:00', NULL);

ALTER TABLE events ENABLE TRIGGER trg_event_create_alarm;
