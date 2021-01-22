/* historico solicitud */
CREATE OR REPLACE FUNCTION solicitud_insert() RETURNS trigger AS
$$
  BEGIN
    INSERT INTO historico_solicitud
      (id_solicitud, id_estado_solicitud, modificado_por, fecha)
      VALUES
      (NEW.id_solicitud, NEW.id_estado_solicitud, current_user, current_timestamp);
    RETURN NEW;
  END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS solicitud_insert_trigger ON solicitud;

CREATE TRIGGER solicitud_insert_trigger
AFTER INSERT ON solicitud
  FOR EACH ROW EXECUTE PROCEDURE solicitud_insert();

  
DROP TRIGGER IF EXISTS solicitud_updated_trigger ON solicitud;
CREATE TRIGGER solicitud_updated_trigger
AFTER UPDATE OF id_estado_solicitud on solicitud
  FOR EACH ROW EXECUTE PROCEDURE solicitud_insert();
