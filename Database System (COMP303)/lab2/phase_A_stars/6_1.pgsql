
-- view 6_1

DROP VIEW IF EXISTS view_committee_undergrad_61;

CREATE OR REPLACE VIEW view_committee_undergrad_61(amka, committee) AS(
    SELECT student_amka, string_agg(fullname, ', ') FROM (
        -- Extra fields for debugging
        SELECT d.student_amka, d.diploma_num, concat(p.surname,' ', p.name) AS fullname, supervisor
        FROM "Diploma" d 
        INNER JOIN
        "Committee" c
        ON d.diploma_num = c.diploma_num and d.student_amka = c.student_amka
        INNER JOIN
        "Person" p
        ON c.prof_amka = p.amka 
        WHERE (CURRENT_DATE) < (d.graduation_date) 
        ORDER BY d.diploma_num, c.supervisor DESC
    ) a
    GROUP BY student_amka, diploma_num
);


-- select view
SELECT * FROM view_committee_undergrad_61;


