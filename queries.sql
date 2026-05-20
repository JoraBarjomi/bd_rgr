SELECT * FROM network_elements;


SELECT * FROM event_types;


SELECT * FROM interfaces;


SELECT * FROM network_elements WHERE status = 'down';


SELECT * FROM events WHERE is_alarm = true;


SELECT ne.name, ne.ip, t.name AS type, m.name AS manufacturer
FROM network_elements ne
JOIN network_elements_type t ON ne.network_element_type_id = t.id
JOIN manufacturer m ON ne.manufacturer_id = m.id;


SELECT e.timestamp, e.message, et.name AS event_type, ne.name AS device
FROM events e
JOIN event_types et ON e.event_type_id = et.id
JOIN network_elements ne ON e.network_element_id = ne.id;


SELECT et.name, COUNT(*) AS event_count
FROM events e
JOIN event_types et ON e.event_type_id = et.id
GROUP BY et.name;


SELECT i.if_name, AVG(m.metric_value) AS avg_value
FROM metrics m
JOIN interfaces i ON m.interface_id = i.id
WHERE m.metric_name = 'cpu_load'
GROUP BY i.if_name;


SELECT ne.name, SUM(m.metric_value) AS total_traffic
FROM metrics m
JOIN interfaces i ON m.interface_id = i.id
JOIN network_elements ne ON i.network_element_id = ne.id
WHERE m.metric_name = 'traffic'
GROUP BY ne.name;


SELECT 
    ne.name,
    ne.ip,
    COUNT(e.id) AS event_count
FROM network_elements ne
JOIN events e ON ne.id = e.network_element_id
WHERE e.timestamp > NOW() - INTERVAL '30 days'
GROUP BY ne.id, ne.name, ne.ip
HAVING COUNT(e.id) > 5;


WITH ne_iface_count AS (
    SELECT 
        ne.id AS ne_id,
        ne.manufacturer_id,
        COUNT(i.id) AS iface_count
    FROM network_elements ne
    LEFT JOIN interfaces i ON ne.id = i.network_element_id
    GROUP BY ne.id, ne.manufacturer_id
)
SELECT 
    m.name AS manufacturer,
    ROUND(AVG(nic.iface_count), 2) AS avg_interfaces
FROM ne_iface_count nic
JOIN manufacturer m ON nic.manufacturer_id = m.id
GROUP BY m.name;


SELECT 
    ne.name AS device_name,
    ne.ip,
    SUM(m.metric_value) AS total_traffic
FROM network_elements ne
JOIN interfaces i ON ne.id = i.network_element_id
JOIN metrics m ON i.id = m.interface_id
WHERE m.metric_name = 'traffic'
  AND m.timestamp >= CURRENT_DATE
GROUP BY ne.id, ne.name, ne.ip
ORDER BY total_traffic DESC
LIMIT 3;