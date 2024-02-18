
-- question 2.1
drop FUNCTION IF EXISTS assign_random_dipTitle_21;

CREATE OR REPLACE FUNCTION assign_random_dipTitle_21()  
RETURNS  void AS 
$$

BEGIN  
    -- Insert students in the "Diploma" table
    INSERT INTO "Diploma" (diploma_num, student_amka, thesis_title, thesis_grade, diploma_grade, graduation_date)
    SELECT row_number() OVER()::integer, st.amka, NULL, NULL, NULL, NULL
    FROM "Student" st
    -- Find Students with the required criteria
    WHERE extract(year from CURRENT_DATE) - extract(year from entry_date) >= 4 
    and 
    EXISTS
    (SELECT r.amka FROM "Register" r WHERE register_status='approved' and st.amka = r.amka) and
    NOT EXISTS 
    (SELECT student_amka FROM "Diploma" d
    WHERE d.student_amka = st.amka);

    -- update "Diploma" table with titles
    UPDATE "Diploma" 
    SET thesis_title = (SELECT title FROM "DiplomaTitles" ORDER BY random()+diploma_num LIMIT 1)
    WHERE thesis_title IS NULL 
    ; 
END;   
$$  
LANGUAGE plpgsql VOLATILE;  

-- [UPDATE]: should have added members to the Committee also

-- **** Helper code ****

-- Call function
-- SELECT assign_random_dipTitle_21();