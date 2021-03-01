CREATE OR REPLACE TRIGGER TG_CONV_FECHA
BEFORE INSERT or UPDATE ON CONVOCATORIA
FOR EACH ROW
-- Variables
BEGIN
    DBMS_OUTPUT.PUT_LINE('TRIGGER DE FECHAS');

    IF INSERTING THEN
        --INSERT INTO CONVOCATORIA(id_convocatoria, fecha_creacion, fecha_abierta, fecha_cerrada, fecha_publicacion_resultados, id_periodo) 
        --VALUES (seq_id_convocatoria.nextval,TO_DATE(':new.fecha_creacion', 'yyyy-mm-dd'), TO_DATE (':new.fecha_abierta', 'yyyy-mm-dd'), TO_DATE (':new.fecha_cerrada', 'yyyy-mm-dd'), TO_DATE (':new.fecha_publicacion_resultados', 'yyyy-mm-dd'), :new.id_periodo)
        :new.id_convocatoria := seq_id_convocatoria.nextval;
        :new.fecha_creacion := TO_DATE (':new.fecha_abierta', 'yyyy-mm-dd');
        :new.fecha_abierta := TO_DATE (':new.fecha_abierta', 'yyyy-mm-dd');
        :new.fecha_cerrada := TO_DATE (':new.fecha_cerrada', 'yyyy-mm-dd');
        :new.fecha_cerrada := TO_DATE (':new.fecha_publicacion_resultados', 'yyyy-mm-dd');
    END IF;

    IF UPDATING THEN
        :new.fecha_abierta := TO_DATE (':new.fecha_abierta', 'yyyy-mm-dd');
        :new.fecha_cerrada := TO_DATE (':new.fecha_cerrada', 'yyyy-mm-dd');
        :new.fecha_cerrada := TO_DATE (':new.fecha_publicacion_resultados', 'yyyy-mm-dd');
    END IF;
    
END TG_CONV_FECHA;

insert into convocatoria values (2, '2021-02-28', '2021-02-24', '2021-02-25', '2021-02-26', 1)