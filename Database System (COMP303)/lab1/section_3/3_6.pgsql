
drop FUNCTION if EXISTS return_sector_most_thesis_36;

-- function 3.6
CREATE OR REPLACE FUNCTION return_sector_most_thesis_36()  
RETURNS table(  sector_id INTEGER,
                sector CHARACTER(100),
                num_of_thesis INTEGER
) AS 
$$
BEGIN  
    RETURN query
    WITH sector_max_th AS(
        SELECT s.sector_code, s.sector_title, count(s.sector_code)::INTEGER as num_of_th
        from "Diploma" d
        INNER JOIN        -- find postgraduates only
        "Committee" c
        -- Date operation selects only postgraduates students
        ON c.student_amka = d.student_amka and c.diploma_num = d.diploma_num 
        INNER JOIN          
        "Professor" p
        -- select only the professors that supervise the thesis
        ON c.prof_amka = p.amka 
        INNER JOIN          -- obtain sector_code
        "Lab" l
        ON p.labjoins = l.lab_code
        INNER JOIN
        "Sector" s
        ON l.sector_code = s.sector_code
        WHERE c.supervisor = TRUE and (CURRENT_DATE) >= (d.graduation_date) 
        -- group to find the total number of thesis per sector
        GROUP by s.sector_code, s.sector_title
        ORDER BY num_of_th DESC, s.sector_code ASC
    )
    -- alias due to ambiguity
    SELECT sector_code as sector_id, sector_title as sector, num_of_th as num_of_thesis 
    FROM sector_max_th
    -- from the "sector_max_th" sub-query, select only the sector(s) with the most thesis
    WHERE num_of_th = (SELECT max(num_of_th) FROM sector_max_th);
END;   
$$  
LANGUAGE plpgsql VOLATILE;

-- function call
-- SELECT * from return_sector_most_thesis_36();
