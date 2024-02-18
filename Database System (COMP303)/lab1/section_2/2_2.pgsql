-- FUNCTION: public.insert_users_into_labteams_22(integer, integer)

DROP FUNCTION IF EXISTS public.insert_users_into_labteams_22(integer, integer);

-- if EXISTS (select from "WorkGroup" wg where wg.module_no = mod_no) then
--     delete from "WorkGroup"
--     where module_no = mod_no;
-- end if;

CREATE OR REPLACE FUNCTION insert_users_into_labteams_22(mod_no integer, total_teams integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare total_members integer := (select lm.max_members from "LabModule" lm where lm.module_no= mod_no);
declare course_members integer := (select count(r.amka)::integer from "Register" r, "LabModule" lm
	where lm.module_no=mod_no and r.register_status = 'approved' and r.course_code = lm.course_code and r.serial_number = lm.serial_number);  
BEGIN
	-- if exists then drop it and create again
	if EXISTS (select from "WorkGroup" wg where wg.module_no = mod_no) then
        RAISE NOTICE 'There are WorkGroups with same module_no %', mod_no;
    end if;
    
    -- 
    if (total_teams >=  ceil(course_members/total_members)::integer) then
        total_teams = ceil(course_members/total_members)::integer;
        raise notice 'Students can fit at less teams. % teams created', total_teams;
    end if;
    
    -- Make entries to "WorkGroup" table (wg_id)  
    insert into "WorkGroup" (wg_id, module_no, serial_number, course_code, grade)
    select ind1::integer, lm.module_no, lm.serial_number, lm.course_code, null
    from generate_series(1,total_teams) ind1, "LabModule" lm
    where lm.module_no=mod_no;
-- 	RAISE NOTICE 'WorkGroup created with % team',total_teams;
	
	-- Make entries to "Joins" table (amka)
	insert into "Joins" (wg_id, module_no, course_code, serial_number, student_amka) 
	select  ( ((row_number() over (order by random())) +total_members - 1) / total_members )::integer, lm.module_no, lm.course_code, lm.serial_number, r.amka 
	from "Register" r, "LabModule" lm
	where lm.module_no=mod_no and r.register_status = 'approved' and r.course_code = lm.course_code and r.serial_number = lm.serial_number 
	limit (total_teams*total_members);

END;
$BODY$;


-- function CALL
-- select insert_users_into_labteams_22(6,2);
