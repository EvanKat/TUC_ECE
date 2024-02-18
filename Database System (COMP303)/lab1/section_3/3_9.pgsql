
-- function 3.9

DROP FUNCTION IF EXISTS find_all_main_of_dependent_39;

create or replace function find_all_main_of_dependent_39(depend_course character(7)) 
returns table(course_code character(7), course_title character(100))
as
$$
begin
    
    return query
    with recursive depend_tree as (
    select dependent, main 
    from "Course_depends"
    where dependent = depend_course
    
    union all
    
    select cd.dependent, cd.main
    from "Course_depends" cd
    inner join
    "depend_tree" dt 
    on cd.dependent = dt.main
    )
    select distinct  d.main, c.course_title from depend_tree d, "Course" c where c.course_code = d.main;


end;
$$
language plpgsql stable;

-- Function Call
select * from find_all_main_of_dependent_39('ΑΓΓ 202'); 