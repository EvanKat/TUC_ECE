
DROP FUNCTION IF EXISTS return_thesis_same_lab_38;

-- function 3.8

CREATE OR REPLACE FUNCTION return_thesis_same_lab_38()  
RETURNS table(  thesis_title CHARACTER VARYING  ) 
AS 
$$
BEGIN  
    RETURN query
    SELECT d.thesis_title from "Diploma" d
    INNER JOIN
    (
        SELECT student_amka, diploma_num, count(*) FROM(
            -- Display st_amkas - diplomas with distinct prof_labjoins
            SELECT DISTINCT on (c.student_amka, c.diploma_num, labjoins) c.student_amka, c.diploma_num, labjoins from "Committee" c 
            INNER JOIN 
            "Professor" p
            ON c.prof_amka = p.amka
            -- WHERE student_amka = '12039907000'  
        ) a
        -- Group the students-diplomas. If a specific student-diploma has only 1 appearance (count = 1), 
        -- this means all Professor(s) join the same lab 
        GROUP BY student_amka, diploma_num
        HAVING count(*) = 1 
    ) b
    -- Joining the subquery from above, with "Diploma", we obtain the thesis titles 
    ON d.student_amka = b.student_amka and d.diploma_num = b.diploma_num
    ;
END;   
$$  
LANGUAGE plpgsql STABLE;

-- Function call
SELECT * FROM return_thesis_same_lab_38();

