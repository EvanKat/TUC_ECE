-- FUNCTION: public.grade_students_23(integer)

DROP FUNCTION IF EXISTS public.grade_students_23(integer);

CREATE OR REPLACE FUNCTION public.grade_students_23(semesterid integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN    
    -- TO DO: Understanding if not update hole row IF exam_grade is NULL       
    -- Update query with values at exam table
    update "Register" r
    set exam_grade = 
        case
            when exam_grade is null then floor(random()*10)+1 -- null
            else exam_grade
        end
    from "CourseRun" cr
    where cr.semesterrunsin = semesterid and r.course_code = cr.course_code and 
          r.serial_number = cr.serial_number and r.register_status = 'approved';
--     raise notice 'Random exam grades: Inserted';
    
    
    -- Update query with values at lab table
    update "Register" r
    set lab_grade = 
        case
            when lab_grade is null then
                case 
                    when COALESCE((select r1.lab_grade 
                          from "Register" r1
                          where r1.serial_number = (cr.serial_number-1) and r1.course_code = r.course_code and r1.amka = r.amka
                         ),0) >= 5 then (select r1.lab_grade 
                          from "Register" r1
                          where r1.serial_number = (cr.serial_number-1) and r1.course_code = r.course_code and r1.amka = r.amka
                         )
                    --else 1
                    else floor(random()*10)+1
                end
            else lab_grade
        end
    from "CourseRun" cr
    where cr.semesterrunsin = semesterid and r.course_code = cr.course_code and 
          r.serial_number = cr.serial_number and r.register_status = 'approved';
--     raise notice 'Random lab grades: Inserted';

END;   
$BODY$;

-- function call
-- SELECT grade_students_23(24);

