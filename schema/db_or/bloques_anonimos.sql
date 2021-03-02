SET serveroutput on

DECLARE
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('Calcular puntajes automaticamente');
	compute_scores_in_convocatory(1);
END;
/


create or replace FUNCTION DIFERENCIA_2_FECHAS
      -- retorna:  AAA.MMDD en decimal (16,4)
    (
     fch_actual     DATE,
     fch_anterior DATE
    )  RETURN NUMBER
    AS     
      p_anios   INTEGER;
      p_meses  INTEGER;
      p_dias   INTEGER; 

  BEGIN

     IF (fch_actual IS NULL) OR (fch_anterior IS NULL) THEN
         RETURN NULL;
     END IF;

    EXECUTE IMMEDIATE 'alter session set NLS_NUMERIC_CHARACTERS = ''.,'' ';

    p_anios  := (EXTRACT(YEAR FROM fch_actual)  - EXTRACT(YEAR FROM fch_anterior));
    p_meses := (EXTRACT(MONTH FROM fch_actual) - EXTRACT(MONTH FROM fch_anterior));
    p_dias  := (EXTRACT(DAY FROM fch_actual)   - EXTRACT(DAY FROM fch_anterior));

     IF p_anios < 0 THEN
         RETURN DIFERENCIA_2_FECHAS( fch_anterior, fch_actual);   
     ELSIF  p_anios = 0 THEN 
         IF  p_meses < 0 THEN   
             RETURN DIFERENCIA_2_FECHAS( fch_anterior, fch_actual);       
         ELSIF  p_meses = 0 THEN
            IF p_dias < 0 THEN          
               RETURN DIFERENCIA_2_FECHAS( fch_anterior, fch_actual);                 
            END IF;
         ELSE
              IF p_dias < 0 THEN
                 p_meses := p_meses - 1;
                 p_dias := 29 + p_dias;
              END IF;
         END IF;        
     ELSE       
        IF  p_meses < 0 THEN       
            p_anios  := p_anios -1;
            p_meses := p_meses + 12;
                  IF p_dias < 0 THEN
                       p_meses := p_meses - 1;
                     p_dias := 29 + p_dias;
                  END IF;                 
        ELSIF  p_meses = 0 THEN
              IF p_dias < 0 THEN
                 p_anios := p_anios -1;
                 p_meses := 11;
                 p_dias := 29 + p_dias;
              END IF;
        ELSE
          IF p_dias < 0 THEN
             p_meses := p_meses - 1;
             p_dias := 29 + p_dias;
          END IF;
        END IF;
     END IF;

     RETURN CAST( (LPAD(TO_CHAR(p_anios), 3 , '0') || '.' || LPAD(TO_CHAR(p_meses), 2 , '0') || LPAD(TO_CHAR(ABS(p_dias)), 2 , '0')) AS NUMBER)*10000 ;

END DIFERENCIA_2_FECHAS;