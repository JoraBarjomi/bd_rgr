INSERT INTO events (network_element_id, event_type_id, is_alarm, timestamp, message)
VALUES (1, 1, FALSE, NOW(), 'Routine health check');

INSERT INTO events (network_element_id, event_type_id, is_alarm, timestamp, message)
VALUES (2, 4, TRUE, NOW(), 'Critical: uplink lost');

SELECT 'Автосозданные алармы:' AS info;
SELECT * FROM alarms ORDER BY id DESC LIMIT 3;

SELECT 'Статистика устройства id=1:' AS info;
SELECT * FROM fn_get_device_stats(1);

SELECT 'Длительность активного аларма id=2:' AS info,
    fn_get_alarm_duration(2) AS duration;


-- UPDATE alarms SET resolved_at = created_at WHERE id = 2;

UPDATE alarms SET resolved_at = NOW() WHERE id = 2;

SELECT 'Длительность разрешённого аларма id=2:' AS info,
    fn_get_alarm_duration(2) AS duration;