
-- question 5.5


DROP TRIGGER IF EXISTS trigger_semester_courses_link_55 on "Semester"; 
DROP FUNCTION IF EXISTS check_semester_courses_link_55;


-- trigger function
create or replace function check_semester_courses_link_55()
returns trigger as 
$$
DECLARE serial_no_var INTEGER := ceil(NEW.semester_id::decimal / 2)::INTEGER;
DECLARE max_professors_per_course INTEGER := 3;
DECLARE max_labteachers_per_course INTEGER := 4;
DECLARE min_labteachers_per_course INTEGER := 2;
-- DECLARE semester_id_var INTEGER := NEW.semester_id;
BEGIN
    IF (NEW.semester_status != 'future') THEN
        RAISE NOTICE 'Invalid semester_status %', NEW.semester_status;
        RETURN NULL; 
    END IF;
    -- Make entries to "CourseRun" table
    insert into "CourseRun" (course_code, serial_number, exam_min, lab_min, exam_percentage, labuses,semesterrunsin)
    -- course_code            serial_number                                                                                              
    SELECT c.course_code, serial_no_var,
        --  exam_min            
        coalesce(floor( (fl.lab_code - fl.lab_code + 1) * random() * 10 + 1),0)::numeric,
        -- lab_min        
        coalesce(floor( (fl.lab_code - fl.lab_code + 1) * random() * 10 + 1),0)::numeric, 
        -- exam_percentage                                                            labuses
        coalesce( (floor( (fl.lab_code - fl.lab_code + 1) * random() * 10 + 1)*10), 0 )::numeric, fl.lab_code, new.semester_id
    
    from "Course" c left join (
        SELECT distinct on (cov.field_code) cov.field_code, cov.lab_code
        from "Covers" cov
        order by  cov.field_code, random()
    ) fl
    on (left(c.course_code,3) = fl.field_code and c.lab_hours!=0 )
    where c.typical_season = new.academic_season;
    RAISE NOTICE 'New courses inserted to CourseRun';
    
    -- Make Links between LabTeachers and courses
    insert into "Supports"(amka,serial_number,course_code)
    SELECT a.amka, a.serial_number, a.course_code from(
        -- Make every combination 
        SELECT row_number() over (partition by course_code order by random()) as r, cr.*, lt.*
        from "CourseRun" cr 
        
        inner join
            
        "LabTeacher" lt 
        on lt.labworks = cr.labuses
        where cr.labuses is not null  and  cr.serial_number = serial_no_var
    ) a 
    -- Limits to different labTeachers per course 
    where a.r <= floor(random()* (max_labteachers_per_course - min_labteachers_per_course + 1) + min_labteachers_per_course);
    RAISE NOTICE 'New labTeachers-courses inserted into Support';

    
    INSERT INTO "Teaches" (amka, serial_number, course_code)
    SELECT * from (
        -- select Professor based on labuses
        SELECT amka, serial_number, course_code FROM(
            SELECT ROW_NUMBER() OVER (PARTITION BY course_code ORDER BY random()) as r, course_code, serial_number, p.amka, labuses
            from "CourseRun" cr
            INNER JOIN
            "Lab" l
            ON l.lab_code = cr.labuses
            INNER JOIN
            "Professor" p
            ON lab_code = labjoins
            WHERE semesterrunsin = NEW.semester_id
        ) a 
        WHERE a.r <= ceil(random()*max_professors_per_course)
        UNION
        -- select Professors for null labuses courses
        SELECT amka, serial_number, course_code FROM(

            SELECT ROW_NUMBER() OVER (PARTITION BY course_code ORDER BY random()) as r, amka , co.*, cr.course_code, serial_number, labuses
            -- SELECT *
            from "Professor" p
            INNER JOIN
            "Covers" co
            ON lab_code = labjoins
            INNER JOIN
            "CourseRun" cr
            ON left(course_code, 3) = field_code
            WHERE labuses is null AND semesterrunsin = NEW.semester_id
        ) b
        WHERE b.r <= ceil(random()*max_professors_per_course)
    ) prof_courses;
    RAISE NOTICE 'New Professors assigned to semester courses';
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;


-- trigger
create trigger trigger_semester_courses_link_55
after insert on "Semester" 
FOR EACH ROW 
EXECUTE PROCEDURE check_semester_courses_link_55();

