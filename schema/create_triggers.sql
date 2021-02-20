/* historico solicitud */
create or replace function solicitud_insert() returns trigger as
$$
  begin
    insert into historico_solicitud
      (id_solicitud, id_estado_solicitud, modificado_por, fecha)
      values
      (new.id_solicitud, new.id_estado_solicitud, current_user, current_timestamp);
    return new;
  end;
$$
language plpgsql;

drop trigger if exists solicitud_insert_trigger on solicitud;

create trigger solicitud_insert_trigger
after insert on solicitud
  for each row execute procedure solicitud_insert();

  
drop trigger if exists solicitud_updated_trigger on solicitud;
create trigger solicitud_updated_trigger
after update of id_estado_solicitud on solicitud
  for each row execute procedure solicitud_insert();
