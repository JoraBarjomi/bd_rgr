CREATE TRIGGER trg_event_create_alarm
AFTER INSERT ON events
FOR EACH ROW
EXECUTE FUNCTION fn_create_alarm_from_event();

CREATE OR REPLACE FUNCTION fn_validate_alarm_resolution()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.resolved_at IS NOT NULL AND NEW.resolved_at <= NEW.created_at THEN
        RAISE EXCEPTION 'resolved_at (%) must be greater than created_at (%)',
            NEW.resolved_at, NEW.created_at;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_alarm_validate_resolution
BEFORE UPDATE ON alarms
FOR EACH ROW
EXECUTE FUNCTION fn_validate_alarm_resolution();