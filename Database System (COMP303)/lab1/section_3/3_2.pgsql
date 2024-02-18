
Drop FUNCTION if EXISTS return_course_grades_32;

-- question 3.2
CREATE OR REPLACE FUNCTION return_course_grades_32(st_amka CHARACTER VARYING, grade_category CHARACTER VARYING)  
RETURNS table(  course_code CHARACTER(7),
                grade_cat numeric
) AS 
$$
BEGIN  
    RETURN query
    SELECT r.course_code,
    CASE grade_category
        WHEN 'exam_grade' THEN r.exam_grade
        WHEN 'lab_grade' THEN r.lab_grade
        WHEN 'final_grade' THEN r.final_grade
    END grade_cat       
    FROM "Semester" sm
    INNER JOIN
    "CourseRun" cr
    ON cr.semesterrunsin = sm.semester_id
    INNER JOIN 
    "Register" r
    ON cr.course_code=r.course_code and cr.serial_number=r.serial_number
    WHERE r.amka = st_amka and semester_status = 'present';
END;   
$$  
LANGUAGE plpgsql STABLE;

-- Function call
-- SELECT * FROM return_course_grades_32('22050109351', 'lab_grade');