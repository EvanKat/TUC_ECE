
-- view 6_2


DROP VIEW IF EXISTS view_possible_graduates_62;


CREATE OR REPLACE VIEW view_possible_graduates_62(entry_year, amount) AS (
    SELECT sr.year, COALESCE(c.count, 0) FROM (
        SELECT b.entry_date, count(*)
        from (
            -- Find the min_courses and min_units for every Student's entry_date --
            WITH sc_rules AS(
                SELECT s.amka, min_courses, min_units, sr.year
                FROM "Student" s
                INNER JOIN
                "SchoolRules" sr
                ON EXTRACT(year from entry_date) = sr.year
                -- WHERE s.amka = '12039907000'
            )
            -- Select the students that comply with the rules based on entry_date == SchoolRules.year (min_courses and min_units)
            SELECT a.amka, string_agg(num, ',') as tot_agg, sum(num::INTEGER) as tot_cs, sum(ects) as tot_ects, sc_rules.year as entry_date
            , sc_rules.min_courses, sc_rules.min_units
            from (
                -- Count the number of passed courses, obligatory or not, for each student and group them
                SELECT r.amka, count(*)::varchar as num, sum(units) as ects, obligatory
                FROM "Register" r 
                INNER JOIN
                "Course" c
                ON c.course_code = r.course_code
                WHERE register_status = 'pass' 
                -- and amka = '12039907000'
                GROUP BY amka, obligatory
                ORDER BY amka, obligatory DESC
            ) a
            INNER JOIN
            sc_rules
            ON a.amka = sc_rules.amka
            -- They are not in a thesis yet 
            WHERE NOT EXISTS (
                SELECT student_amka FROM "Diploma" d
                WHERE d.student_amka = a.amka
            )
            GROUP BY a.amka, sc_rules.year, sc_rules.min_courses, sc_rules.min_units
            HAVING sum(num::INTEGER) >= sc_rules.min_courses and sum(ects) >= sc_rules.min_units

        ) b
        -- passed obligatory >= total obligatory
        WHERE split_part(tot_agg, ',', 1)::INTEGER >= (SELECT count(*) FROM "Course" WHERE obligatory = TRUE) 
        GROUP BY entry_date 
    ) c
    -- Display 0 values, too
    RIGHT JOIN
    "SchoolRules" sr
    ON c.entry_date = sr.year
    WHERE extract(year from CURRENT_DATE) - 10 < sr.year
    ORDER BY sr.year ASC
);


-- select view
SELECT * FROM view_possible_graduates_62;



