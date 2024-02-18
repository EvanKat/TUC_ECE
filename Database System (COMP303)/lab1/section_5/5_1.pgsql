
-- question 5.1

-- *** committee_members ***

-- drop FUNCTION and TRIGGER
drop TRIGGER if EXISTS max_committee_members_51 on "Committee";
drop FUNCTION if EXISTS check_max_committee_members_51;

CREATE OR REPLACE FUNCTION check_max_committee_members_51()  
RETURNS TRIGGER
AS 
$$
-- TODO: from which the year the rules apply!? 
DECLARE max_committee_members INTEGER := (SELECT committee_members_no FROM "SchoolRules" sr WHERE sr.year = extract(year from CURRENT_DATE));
BEGIN 
    -- check if new.prof_amka exceeds committee_members_no
    IF EXISTS(
        SELECT c.student_amka, c.diploma_num, count(*) com_memb_no
        FROM "Committee" c
        WHERE c.student_amka = new.student_amka and c.diploma_num = new.diploma_num
        group by c.student_amka, c.diploma_num
        HAVING count(*) >= max_committee_members
    ) THEN
        RAISE NOTICE 'Committee members exceed the SchoolRules limit';
        RETURN NULL;
    ELSE
        RAISE NOTICE 'Professor successfully inserted in committee members';
        RETURN NEW ;
    END IF;
END;   
$$  
LANGUAGE plpgsql;

-- trigger
CREATE TRIGGER trigger_max_committe_members_51 
BEFORE INSERT ON "Committee"
FOR EACH ROW
EXECUTE PROCEDURE check_max_committee_members_51();


-- *** labModule_max_members ***

-- drop FUNCTION and TRIGGER
DROP TRIGGER IF EXISTS trigger_max_workgroup_members_51 on "Joins"; 
DROP FUNCTION IF EXISTS check_max_workgroup_members_51;


CREATE OR REPLACE FUNCTION check_max_workgroup_members_51()  
RETURNS TRIGGER
AS 
$$
DECLARE max_wg_members INTEGER := (SELECT max_members FROM "LabModule" sr WHERE module_no = NEW.module_no);
BEGIN 
    -- check if new.student_amka exceeds max_members of
    IF EXISTS(
        SELECT module_no, wg_id, count(*) wg_memb_no
        from "Joins" j
        WHERE j.wg_id = NEW.wg_id and j.module_no = NEW.module_no 
        and j.course_code = NEW.course_code and j.serial_number = NEW.serial_number
        group by j.module_no, j.wg_id
        HAVING count(*) >= max_wg_members
    ) THEN
        RAISE NOTICE 'Workgroup members exceed the LabModule limit!';
        RETURN NULL;
    ELSE
        RAISE NOTICE 'Student successfully inserted in committee members!';
        RETURN NEW ;
    END IF;
END;   
$$  
LANGUAGE plpgsql;

-- trigger
CREATE TRIGGER trigger_max_workgroup_members_51 
BEFORE INSERT ON "Joins"
FOR EACH ROW
EXECUTE PROCEDURE check_max_workgroup_members_51();

