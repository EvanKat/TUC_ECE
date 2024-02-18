
DROP FUNCTION if EXISTS return_not_teached_courses_33;

-- question 3.3
CREATE OR REPLACE FUNCTION return_not_teached_courses_33()  
RETURNS table(  course_code CHARACTER(7),
                course_title CHARACTER(100)
) AS
$$
DECLARE current_semester_id INTEGER := (SELECT sem.semester_id FROM "Semester" sem WHERE sem.semester_status = 'present');
DECLARE current_academic_season semester_season_type := (SELECT  sem.academic_season FROM "Semester" sem WHERE sem.semester_status = 'present');
BEGIN  

-- raise notice 'sem: %, type: %',current_semester_id,current_academic_season semester_season_type;

    return query
    SELECT c.course_code, c.course_title
    FROM  (
        SELECT * FROM "Course" 
        WHERE typical_season = current_academic_season AND obligatory = 'false'
    ) c
    WHERE not exists (
        SELECT  cr.course_code FROM "CourseRun" cr 
        WHERE  cr.course_code = c.course_code AND cr.semesterrunsin = current_semester_id
    );



END;   
$$
LANGUAGE plpgsql STABLE;

-- function call
-- SELECT * FROM return_not_teached_courses_33();
