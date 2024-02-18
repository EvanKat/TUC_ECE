

-- question 5.2

-- drop FUNCTION or TRIGGER
DROP TRIGGER IF EXISTS trigger_semester_mod_52 on "Semester"; 
DROP FUNCTION IF EXISTS check_semester_mod_52;


CREATE OR REPLACE FUNCTION check_semester_mod_52()  
RETURNS TRIGGER
AS 
$$
DECLARE season semester_season_type ;
BEGIN 
    IF (EXTRACT(MONTH FROM NEW.start_date) BETWEEN 9 AND 12) AND (EXTRACT(MONTH FROM NEW.end_date) BETWEEN 1 AND 2)
        THEN season = 'winter';
    ELSIF (EXTRACT(MONTH FROM NEW.start_date) BETWEEN 3 AND 6) AND (EXTRACT(MONTH FROM NEW.end_date) BETWEEN 6 AND 8) 
        THEN season = 'spring';
    ELSE 
        RAISE NOTICE 'This is not a valid semester period. Aborting...';
        RETURN NULL;
    END if;
    NEW.academic_year := EXTRACT(YEAR FROM NEW.start_date);
    NEW.academic_season := season;
    RAISE NOTICE 'Semester added to table';
    RETURN NEW;
END;   
$$  
LANGUAGE plpgsql;

-- trigger
CREATE TRIGGER trigger_semester_mod_52
BEFORE INSERT OR UPDATE ON "Semester"
FOR EACH ROW
EXECUTE PROCEDURE check_semester_mod_52();
