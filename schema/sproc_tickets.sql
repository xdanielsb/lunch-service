/* Stored procedure to assign tickets to 'beneficiarios' */


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
begin
  cur := get_cursor_beneficiarios(_id_convocatoria);
  loop 
    fetch cur into rec;
    exit when not found;
    raise notice 'id_beneficiario=  %',rec.id_beneficiario;

    -- TODO: change 10 by the number of lunchs
    for i in 1..10 loop
      insert into ticket(id_beneficiario, tipo_ticket) 
      values(rec.id_beneficiario, 'almuerzo');
    end loop;

    -- TODO: change 10 by the number of 'refrigerios'
    for i in 1..10 loop
      insert into ticket(id_beneficiario, tipo_ticket) 
      values(rec.id_beneficiario, 'refrigerio');
    end loop;

    /* here update table ticket for student */
  end loop;
  close cur;
end;
$$;

call assign_tickets(1);

