create or replace procedure assign_tickets(pid_convocatoria in convocatoria.id_convocatoria%TYPE)
is
cursor cur is 
    select b.* from beneficiario b, solicitud s 
    where b.id_solicitud=s.id_solicitud and 
    s.id_convocatoria=pid_convocatoria;
    
    lc_cur cur%ROWTYPE;

    --rec convocatoria%rowtype;

    end_date  date;
    total number(16,4);

begin
    open cur;
    loop 
        fetch cur into lc_cur;
        exit when cur%notfound;
        --raise notice 'id_beneficiario=  %',rec.id_beneficiario;
        DBMS_OUTPUT.PUT_LINE('HOLA: ');
        DBMS_OUTPUT.PUT_LINE('id_beneficiario: ' || CHR(10)|| lc_cur.id_beneficiario );
        
        select fecha_fin into end_date from periodo p, convocatoria c 
        where p.id_periodo = c.id_periodo and c.id_convocatoria = pid_convocatoria;
    
        --total := trunc(date_part('day'::text,end_date-current_timestamp)/7) * 5;
        --SELECT EXTRACT(DAY FROM sysdate) into fecha FROM dual;
        total := DIFERENCIA_2_FECHAS(end_date,sysdate);
        total := trunc(total/7)*5;
        DBMS_OUTPUT.PUT_LINE('dif fechas ' || CHR(10)|| total );
    
        for i in 1 .. total loop
          insert into ticket(id_ticket,id_beneficiario ,id_tipo_ticket) 
          values(SEQ_TICKET.NEXTVAL ,lc_cur.id_beneficiario ,'almuerzo');
          update beneficiario 
          set cantidad_tickets_asignados = (cantidad_tickets_asignados+1) 
          where id_beneficiario=lc_cur.id_beneficiario;
        end loop;
    
        for i in 1..total loop
          insert into ticket(id_ticket,id_beneficiario, id_tipo_ticket) 
          values(SEQ_TICKET.NEXTVAL ,lc_cur.id_beneficiario, 'refrigerio');
          update beneficiario 
          set cantidad_tickets_asignados = (cantidad_tickets_asignados+1) 
          where id_beneficiario=lc_cur.id_beneficiario;
        end loop;
    end loop;
    close cur;
end assign_tickets;



create or replace procedure assign_activities(pid_convocatoria in convocatoria.id_convocatoria%TYPE)
is
cursor cur is 
    select b.* from beneficiario b, solicitud s 
    where b.id_solicitud=s.id_solicitud and 
    s.id_convocatoria=pid_convocatoria;
    
    lc_cur cur%rowtype;
    --rec convocatoria%rowtype;

    end_date  date;
    total number(16,4);
    rnd_activity number(2);

begin
    open cur;
    loop 
        fetch cur into lc_cur;
        exit when cur%notfound;

        DBMS_OUTPUT.PUT_LINE('id_beneficiario: ' || CHR(10)|| lc_cur.id_beneficiario );
    
        select fecha_fin into end_date from periodo p, convocatoria c 
        where p.id_periodo = c.id_periodo and c.id_convocatoria = pid_convocatoria;
    
        total := DIFERENCIA_2_FECHAS(end_date,sysdate);
        total := trunc(total/7)*5;
    
        rnd_activity:= trunc(DBMS_RANDOM.normal)+1;
    
        if rnd_activity<1 and rnd_activity>3 then
            rnd_activity:=1;
        end if;
    
        for i in 1..total loop
          insert into actividad_beneficiario(id_actividad_beneficiario,id_beneficiario, id_actividad, id_estado_actividad) 
          values(SEQ_ACTIVIDAD_BENEFICIARIO.NEXTVAL ,lc_cur.id_beneficiario,1,rnd_activity);
        end loop;

  end loop;
  close cur;
end;