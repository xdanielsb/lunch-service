
create or replace function compute_score_solicitud (pid_solicitud in solicitud.id_solicitud%TYPE)
                                                   return number

    as 
    score number; 
    begin 
         select sum(ptd.puntaje) into score 
         from documento_solicitud ds, puntaje_tipo_documento ptd, solicitud  s, estado_solicitud  es
         where ds.id_solicitud= s.id_solicitud and 
               es.id_estado_solicitud=s.id_estado_solicitud and
               ptd.id_puntaje_tipo_documento = ds.id_puntaje_tipo_documento and
               es.estado='aprobada' and 
               s.id_solicitud =pid_solicitud;

    return score;
end compute_score_solicitud;


create or replace procedure compute_scores_in_convocatory (pid_convocatoria in convocatoria.id_convocatoria%TYPE)

is
cursor c_solicitud is 
        select * from solicitud 
        where id_convocatoria= pid_convocatoria order by puntaje;
        lc_solicitud c_solicitud%ROWTYPE;

--c_comp_score solicitud%ROWTYPE;
--lc_comp_score c_comp_score%rowtype ;
score number ; 

begin
    open c_solicitud;
    loop
    fetch c_solicitud into lc_solicitud;
    exit when c_solicitud%notfound ;
        --select compute_score_solicitud(lc_solicitud.id_solicitud)into score from solicitud;
        score := compute_score_solicitud(lc_solicitud.id_solicitud);
        DBMS_OUTPUT.PUT_LINE('score:'|| score);
        update solicitud set puntaje = score where id_solicitud = lc_solicitud.id_solicitud;
    end loop;
end compute_scores_in_convocatory;