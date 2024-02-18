
-- question 3.4
Drop FUNCTION if EXISTS return_registed_students_in_labMod_34;

-- select insert_users_into_labteams(1, 2);
CREATE OR REPLACE FUNCTION return_registed_students_in_labMod_34(st_amka varchar)  
RETURNS table(  mod_no INTEGER,
                is_member text
) AS 
$$
BEGIN  
    RETURN query
    SELECT DISTINCT on (module_no) module_no as mod_no, participates as is_member from( 
        SELECT student_amka, module_no, course_code,
        CASE student_amka
            WHEN st_amka THEN 'NAI'
            ELSE 'OXI'
        END participates       
        From "Joins" 
        ORDER BY module_no, participates ASC
    ) as sub_quer;
END;   
$$  
LANGUAGE plpgsql STABLE;

-- function call
-- SELECT * from return_registed_students_in_labMod_34('15109904380');
