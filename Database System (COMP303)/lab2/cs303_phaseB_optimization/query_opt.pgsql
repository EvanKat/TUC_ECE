SET max_parallel_workers_per_gather = 2;
SET max_parallel_workers_per_gather = 0;

VACUUM ANALYSE

set enable_hashjoin=off;
set enable_hashjoin=on;


CREATE INDEX Lab_type_btree ON "LabModule" USING btree(type);
-- Drop index Lab_type_btree;
cluster "LabModule" using Lab_type_btree;
CREATE INDEX Lab_type_hash ON "LabModule" USING hash(type);
-- Drop index Lab_type_hash;

-----------------------------

CREATE INDEX Workgroup_grade_btree ON "Workgroup" USING btree(grade);
-- Drop index Workgroup_grade_btree
cluster "Workgroup" using Workgroup_grade_btree;
-- CREATE INDEX Workgroup_grade_hash ON "Workgroup" USING hash(grade);
-- Drop index Workgroup_grade_hash;
-- CREATE INDEX Workgroup_module_hash ON "Workgroup" USING hash(module_no);
-- Drop index Workgroup_module_hash;

------------------------------

CREATE INDEX Joins_module_btree ON "Joins" USING btree(module_no);
cluster "Joins" using Joins_module_btree;
-- Drop index Joins_module_btree
-- CREATE INDEX Joins_module_hash ON "Joins" USING hash(module_no);
-- Drop index Joins_module_hash;

-------------------------------

CREATE INDEX Stud_date_btree ON "Student" USING btree(entry_date);
-- Drop index Stud_date_btree;
cluster "Student" using Stud_date_btree;

-------------------------------

CREATE INDEX Per_amka_btree ON "Person" USING btree(amka);
-- Drop index Per_amka_btree;
cluster "Person" using Per_amka_btree;
-- CREATE INDEX Per_amka_hash ON "Person" USING hash(amka);
-- Drop index Per_amka_hash;



-- Drop index Lab_type_btree;
Drop index Lab_type_hash;
Drop index Workgroup_grade_btree;
Drop index Joins_module_btree;
Drop index Stud_date_btree;
Drop index Per_amka_btree;

-----------------------------------

select * from "LabModule";
select * from "Workgroup";
select * from "Joins";

-----------------------------------

explain analyze 
select per.surname, per.name from
(
    select st.amka from "Student" st
    inner join 
    (
        select j.amka from 
        "Joins" j
        inner join 
        (
            select wg."wgID", wg.module_no from
            "Workgroup" wg
            inner join 
            "LabModule" lm
            on lm.module_no = wg.module_no
            where lm.type = 'project' and wg.grade > 8
        ) wg
        on wg."wgID" = j."wgID" and wg.module_no = j.module_no
    ) j

    on j.amka = st.amka
    where entry_date between '2010-09-01' and '2011-09-01'
) wg

inner join

"Person" per
on wg.amka = per.amka
