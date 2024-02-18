
-- question 5.4

-- drop FUNCTION or TRIGGER
DROP TRIGGER IF EXISTS trigger_register_status_54 on "Register"; 
DROP FUNCTION IF EXISTS check_register_status_54;


CREATE OR REPLACE FUNCTION check_register_status_54()  
RETURNS TRIGGER
AS 
$$
DECLARE season semester_season_type ;
BEGIN 
    -- can we insert with register_status='proposed'?!
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        IF (NEW.register_status = 'approved' OR NEW.register_status = 'rejected' OR NEW.register_status = 'proposed'
            OR OLD.register_status = 'approved' OR OLD.register_status = 'rejected' )
        THEN
            RAISE NOTICE 'Illegal move! Cannot change register_status to %', NEW.register_status;
            RETURN NULL;
        END IF;
        
        IF (NEW.register_status = 'pass'  or NEW.register_status = 'fail' or OLD.register_status = 'pass' or OLD.register_status = 'fail')
            THEN RETURN NEW; -- 5.3 trigger will handle it (if not already)
        END IF;
        
        IF EXISTS(
            -- Check if required courses are passed
            WITH required_cs AS(
                WITH union_query AS(
                    -- Add the NEW course to the checking process 
                    SELECT *
                    FROM "Register" 
                    where amka = new.amka
                    AND course_code = NEW.course_code -- will select courses with diffent serial_number (on insert is useless)
                    UNION
                    -- Check new course also (In case of UPDATE new is null)
                    (SELECT NEW.*)  
                )
                SELECT amka, cd.dependent, main, mode
                FROM union_query r
                INNER JOIN
                "CourseRun" cr
                ON r.course_code = cr.course_code 
                and r.serial_number = cr.serial_number 
                INNER JOIN
                "Course" c
                ON cr.course_code = c.course_code
                INNER JOIN
                "Course_depends" cd
                ON c.course_code = cd.dependent 
                -- Filter using only the current Semester
                WHERE
                cr.semesterrunsin = (SELECT semester_id FROM "Semester" WHERE semester_status = 'present')
                and (register_status = 'approved' OR register_status = 'requested')  
            )
            SELECT r_cs.*, re.register_status as main_cs_status from required_cs r_cs 
            LEFT JOIN
            "Register" re
            ON r_cs.main = re.course_code and r_cs.amka = re.amka  
            WHERE mode = 'required' AND (re.register_status = 'fail' or re.register_status is NULL) ) 
        THEN 
            NEW.register_status := 'rejected';
            RAISE NOTICE 'Student cannot register to the course because it is dependent';
            RETURN NEW;
        ELSE 
            -- IF passed , check if total registed courses exceed the limit (num>6 or ECTS>20)
            IF EXISTS(
                -- Find of courses and units exceed limit (6, 20) 
                WITH union_query AS(
                    -- Add the NEW course to the checking process 
                    SELECT *
                    FROM "Register" 
                    where amka = new.amka
                    UNION
                    (SELECT NEW.*)
                )
                SELECT amka, sum(units) total_units, count(*) total_courses
                FROM union_query r
                INNER JOIN
                "CourseRun" cr
                ON r.course_code = cr.course_code 
                and r.serial_number = cr.serial_number 
                INNER JOIN
                "Course" c
                ON cr.course_code = c.course_code
                WHERE semesterrunsin = (SELECT semester_id FROM "Semester" WHERE semester_status = 'present')
                and (register_status = 'approved' OR register_status = 'requested')  
                GROUP BY amka
                HAVING sum(units) > 20 OR count(*) > 6) 
            THEN
                NEW.register_status := 'rejected';
                RAISE NOTICE 'Student cannot register to the course. Too many registered courses or ECTs';
                RETURN NEW; 
            ELSE 
                RAISE NOTICE 'Student successfully registered to the course!';
                NEW.register_status := 'approved';
                RETURN NEW;
            END IF;
        END IF;
    END IF;
    RAISE NOTICE 'Unknown error';
    RETURN NULL;
END;   
$$  
LANGUAGE plpgsql VOLATILE;

-- trigger
CREATE TRIGGER trigger_register_status_54
BEFORE INSERT OR UPDATE ON "Register"
FOR EACH ROW
EXECUTE PROCEDURE check_register_status_54();

