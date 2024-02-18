
DROP FUNCTION IF EXISTS max_grades_from_semester_35;

-- question 3.5
CREATE OR REPLACE FUNCTION max_grades_from_semester_35(semesterID INTEGER, grade_category varchar)  
RETURNS table(course_code CHARACTER(7), course_grade numeric) AS 
$$
BEGIN
--     Input semesterID and grade_category (lab_grade, exam_grade or final_grade)
--     Returns the table with courses and their maximum given (grade_category) grade
--  If one course is not in register, its grade is null (like for semesterID = 1 or 23 )
--     NULLS come first at the table

	RETURN QUERY
	select cr.course_code,
	case grade_category
		when 'exam_grade' then courses_grades.exam_grade
		when 'lab_grade' then courses_grades.lab_grade
		when 'final_grade' then courses_grades.final_grade
	end  grade_category     -- todo: display the name of the grade category
	from    "CourseRun" cr left join (
		select r.course_code, r.serial_number, max(r.exam_grade) as exam_grade, max(r.lab_grade) as lab_grade, max(r.final_grade) as final_grade
		from "Register" r 
		group by r.course_code, r.serial_number
	) courses_grades
	on (courses_grades.course_code = cr.course_code and courses_grades.serial_number = cr.serial_number)
	where cr.semesterrunsin = semesterID
	order by grade_category DESC NULLS FIRST;

END;   
$$  
LANGUAGE plpgsql stable;

-- function call
-- select * from max_grades_from_semester_35(20,'final_grade');

