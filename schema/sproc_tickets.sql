/* Stored procedure to assign tickets & activities to 'beneficiarios' */


/* Get a cursor of solicitudes of a given convocatory */
create or replace function get_cursor_beneficiarios(
  _id_convocatoria integer
)
  returns refcursor
  as $$
  declare
    cur refcursor;
  begin
    open cur for 
      select * 
      from beneficiario as b, solicitud as s 
      where 
       b.id_solicitud=s.id_solicitud and 
      id_convocatoria=_id_convocatoria;
    return cur;
end; $$ 
language plpgsql;


create or replace procedure assign_tickets(
  _id_convocatoria integer
)
language plpgsql
as $$
declare
    cur refcursor;
    rec record;
    end_date  timestamp;
    total integer;
begin
  cur := get_cursor_beneficiarios(_id_convocatoria);
  loop 
    fetch cur into rec;
    exit when not found;
    raise notice 'id_beneficiario=  %',rec.id_beneficiario;

    select fecha_fin into end_date from periodo as p, convocatoria as c 
    where p.id_periodo = c.id_periodo and id_convocatoria = _id_convocatoria;

    total := trunc(date_part('day'::text,fecha_fin-current_timestamp)/7) * 5;

    for i in 1..total loop
      insert into ticket(id_beneficiario, tipo_ticket) 
      values(rec.id_beneficiario, 'almuerzo');
      rec.cantidad_tickets_asignados := cantidad_tickets_asignados +1;
    end loop;

    for i in 1..total loop
      insert into ticket(id_beneficiario, tipo_ticket) 
      values(rec.id_beneficiario, 'refrigerio');
      rec.cantidad_tickets_asignados := cantidad_tickets_asignados +1;
    end loop;

  end loop;
  close cur;
end;
$$;


create or replace procedure assign_activities(
  _id_convocatoria integer
)
language plpgsql
as $$
declare
    cur refcursor;
    rec record;
    end_date  timestamp;
    total integer;
    rnd_activity integer:=1;
begin
  cur := get_cursor_beneficiarios(_id_convocatoria);
  loop 
    fetch cur into rec;
    exit when not found;
    raise notice 'id_beneficiario=  %',rec.id_beneficiario;


    select fecha_fin into end_date from periodo as p, convocatoria as c 
    where p.id_periodo = c.id_periodo and id_convocatoria = _id_convocatoria;

    total := trunc(date_part('day'::text,fecha_fin-current_timestamp)/7) * 5;

    for i in 1..total loop
      insert into actividad_beneficiario(id_beneficiario, id_actividad, id_estado_actividad) values(rec.id_beneficiario,1,rnd_activity);
    end loop;

  end loop;
  close cur;
end;
$$;

call assign_tickets(1);
call assign_activities(1);

