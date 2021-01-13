
/* Function which computes the sums of the documnts the students sent */
create or replace function compute_score_solicitud(_id_solicitud integer)
returns dec
language plpgsql
as
$$

declare 
  score dec;
begin
  select sum(ptd.puntaje) 
  into score
  from 
    documento_solicitud as ds, 
    puntaje_tipo_documento as ptd, 
    solicitud as s, estado_solicitud as es  
  where 
    ds.id_solicitud= s.id_solicitud and 
    es.id_estado_solicitud=s.id_estado_solicitud and
    ptd.id_puntaje_tipo_documento = ds.id_puntaje_tipo_documento and
    es.estado='aprobada' and 
    s.id_solicitud=_id_solicitud;

  return score;
end;
$$;

/* Get a cursor of solicitudes of a given convocatory */
create or replace function get_cursor_solicitud(_id_convocatoria integer)
  returns refcursor
  as $$
  declare
    cur refcursor;
  begin
    open cur for 
      select * 
      from solicitud 
      where id_convocatoria = _id_convocatoria;
    return cur;
end; $$ 
language plpgsql;




/* Stored procedure to compute the scores of each solicitud in a given convocatory */
create or replace procedure compute_scores_in_convocatory(
  _id_convocatoria integer
)
language plpgsql
as $$
declare 
    cur refcursor;
    rec record;
    score dec;
begin
  
  cur := get_cursor_solicitud(_id_convocatoria);
  loop 
    fetch cur into rec;
    exit when not found;

    select compute_score_solicitud(rec.id_solicitud) into score;

    raise notice 'id_solicitud= %, id_estudiante= %, score=%', 
                rec.id_solicitud,
                rec.id_estudiante,
                score;
    
    /* update puntaje solicitud */


  end loop;
  commit;
end; $$;

/* debug:
select compute_score_solicitud(2);
select get_cursor_solicitud(1);
call compute_scores_in_convocatory(1);
*/

