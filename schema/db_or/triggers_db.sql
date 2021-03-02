/* historico solicitud */

create or replace trigger solicitud_insert_trigger 
after insert on solicitud
for each row 
declare

t_solicitud VARCHAR2 (10);
begin
 select user into t_solicitud from dual ;
 insert into historico_solicitud
      (id_historico_solicitud,id_solicitud, id_estado_solicitud, modificado_por, fecha)
      values
      (SEQ_HISTORICO_SOLICITUD.NEXTVAL,:new.id_solicitud, :new.id_estado_solicitud, t_solicitud, current_timestamp);
    return ;
end solicitud_insert_trigger; 

-------------------------------------------------------------------------  

create or replace trigger solicitud_updated_trigger
after update on solicitud
for each row
declare 
 t_solicitud VARCHAR2 (10);
begin
if UPDATING THEN 
    select user into t_solicitud from dual ;
    insert into historico_solicitud
          (id_historico_solicitud, id_solicitud, id_estado_solicitud, modificado_por, fecha)
          values
          (SEQ_HISTORICO_SOLICITUD.NEXTVAL,:new.id_solicitud, :new.id_estado_solicitud, t_solicitud, current_timestamp);
    return;
end if ;
end solicitud_updated_trigger;