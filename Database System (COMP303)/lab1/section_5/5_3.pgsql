

DROP TRIGGER IF EXISTS trigger_set_student_grade_status_53 on "Register"; 
DROP FUNCTION IF EXISTS check_set_student_grade_status_53;

-- question 5.3
create or replace function check_set_student_grade_status_53()
returns trigger as 
$$
BEGIN
    --     Check if trying to cheat
    --     If old variables not the same as the new ones, then abord
    --     At insert old. have NULL values 
    --    At update have the previous values

    if (new.final_grade!= old.final_grade or new.register_status ='pass' or new.register_status ='fail') THEN
        RAISE NOTICE 'Trying to insert final_grade or register_status';
        return null;
    elseif (new.register_status = 'approved' and ( new.exam_grade is not null or new.lab_grade is not null) ) then
        RAISE NOTICE 'New entry with amka: %',new.amka;
        -- Set final grade for each case
        new.final_grade := 
            case -- case: is lab
                when cr.labuses is not null then 
                    case -- case: that have the minimum of lab.
                        when COALESCE(new.lab_grade,0) >= cr.lab_min then -- if lab_uses, lab_min \in {0, limit}
                            case -- case: have greater than exam
                                when COALESCE(new.exam_grade,0) >= cr.exam_min then -- if lab_uses, exam_min \in {0, limit} and exam_percentage \in {0, limit}
                                    ( ( (cr.exam_percentage * COALESCE(new.exam_grade,0)) + 
                                        (100 - cr.exam_percentage * COALESCE(new.lab_grade,0)) )/100) --case 4
                                else COALESCE(new.exam_grade,0) -- case 3
                            end
                        else 0 --case 2
                    end
                else COALESCE(new.exam_grade,0) --case 1 : no lab and no grade at exam
            end
        from "CourseRun" cr
        where cr.course_code = new.course_code and cr.serial_number = new.serial_number;

        -- set register status
        new.register_status := 
            case
                when new.final_grade>=5 then 'pass'
                else 'fail'
            end;
        -- make entry
        return new;
    else
        return new;
    end if;
END;
$$
LANGUAGE plpgsql;


-- Trigger
create trigger trigger_set_student_grade_status_53
before insert or update on "Register" 
FOR EACH ROW 
EXECUTE PROCEDURE check_set_student_grade_status_53();

