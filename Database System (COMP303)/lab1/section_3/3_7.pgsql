drop Function if exists total_hours_per_lab_teacher_37;

-- function 3.7
CREATE OR REPLACE FUNCTION total_hours_per_lab_teacher_37(semesterID INTEGER)  
RETURNS table(amka varchar, surname varchar(30), name varchar(30), total_hours smallint) AS 
$$
BEGIN
    RETURN QUERY
    select amka_hours.amka, per.surname, per.name, amka_hours.total_hours::smallint
    from "Person" per inner join (
        
        select lt.amka, lab_hours.total_hours
        from "LabTeacher" lt
        left join 
        -- labuses, total_hours
        (select cl.labuses, sum(COALESCE(cl.lab_hours,0) + COALESCE(wg_hours.teams,0)) as total_hours
            from (
                -- courses, labuses, lab_hours
                select cr.course_code, cr.serial_number,cr.labuses, c.lab_hours  
                from "CourseRun" cr inner join "Course" c
                on cr.course_code = c.course_code
                where cr.semesterrunsin = semesterID and cr.labuses is not null
            ) cl

            left join 

            -- courses, serial_number, team_hours
            (select wg.course_code, wg.serial_number, count(wg.wg_id)::smallint as teams
                from "WorkGroup" wg inner join "CourseRun" cr
                on wg.serial_number = cr.serial_number and wg.course_code = cr.course_code
                where cr.semesterrunsin = semesterID
                group by wg.course_code, wg.serial_number
            ) wg_hours
            on (wg_hours.course_code=cl.course_code)
            group by cl.labuses
        ) lab_hours
        on lt.labworks = lab_hours.labuses
    ) amka_hours
    on amka_hours.amka = per.amka;
END;   
$$  
LANGUAGE plpgsql stable;

-- function call
-- select * from total_hours_per_lab_teacher_37(24)

