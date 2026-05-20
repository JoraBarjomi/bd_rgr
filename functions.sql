CREATE OR REPLACE FUNCTION fn_create_alarm_from_event()
RETURNS TRIGGER AS $$
DECLARE
    v_severity VARCHAR(50);
BEGIN
    IF NEW.is_alarm = TRUE THEN
        SELECT et.severity INTO v_severity
        FROM event_types et
        WHERE et.id = NEW.event_type_id;

        INSERT INTO alarms (network_element_id, event_id, severity, created_at, resolved_at)
        VALUES (
            NEW.network_element_id,
            NEW.id,
            COALESCE(v_severity, 'warning'),
            NEW.timestamp,
            NULL
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_device_stats(p_device_id INT)
RETURNS TABLE (
    device_name       VARCHAR(255),
    total_interfaces  BIGINT,
    total_events      BIGINT,
    active_alarms     BIGINT,
    avg_cpu_load      NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ne.name,
        COUNT(DISTINCT i.id),
        COUNT(DISTINCT e.id),
        COUNT(DISTINCT a.id),
        COALESCE(ROUND(AVG(m.metric_value), 2), 0)
    FROM network_elements ne
    LEFT JOIN interfaces i  ON i.network_element_id = ne.id
    LEFT JOIN events e      ON e.network_element_id = ne.id
    LEFT JOIN alarms a      ON a.network_element_id = ne.id AND a.resolved_at IS NULL
    LEFT JOIN metrics m     ON m.interface_id = i.id AND m.metric_name = 'cpu_load'
    WHERE ne.id = p_device_id
    GROUP BY ne.id, ne.name;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_get_alarm_duration(p_alarm_id INT)
RETURNS INTERVAL AS $$
DECLARE
    v_created  TIMESTAMPTZ;
    v_resolved TIMESTAMPTZ;
BEGIN
    SELECT created_at, COALESCE(resolved_at, NOW())
    INTO v_created, v_resolved
    FROM alarms WHERE id = p_alarm_id;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    RETURN v_resolved - v_created;
END;
$$ LANGUAGE plpgsql;