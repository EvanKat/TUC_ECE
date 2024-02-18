
drop FUNCTION if EXISTS return_staff_data_31;

-- question 3.1
CREATE OR REPLACE FUNCTION return_staff_data_31(sector_ID INTEGER)  
RETURNS table(  amka CHARACTER VARYING,
                lastname CHARACTER VARYING,
                firstname CHARACTER VARYING
) AS 
$$
-- DECLARE total_members integer := 0;
BEGIN  
    RETURN query
    SELECT p.amka, surname as lastname, name as firstname FROM "Lab" l
    INNER JOIN 
    "Professor" p
    ON l.lab_code = labjoins 
    INNER JOIN
    "Person" pr
    ON pr.amka = p.amka
    WHERE sector_code = sector_ID
    UNION
    SELECT p.amka, surname, name FROM "Lab" l
    INNER JOIN 
    "LabTeacher" p
    ON l.lab_code = labworks 
    INNER JOIN
    "Person" pr
    ON pr.amka = p.amka
    WHERE sector_code = sector_ID
    ;

END;   
$$  
LANGUAGE plpgsql STABLE;

-- function call
-- SELECT * FROM return_staff_data_31(1);

