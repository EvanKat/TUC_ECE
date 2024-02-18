-- Table: public.Joins

-- DROP TABLE IF EXISTS public."Joins";

CREATE TABLE IF NOT EXISTS public."Joins"
(
    wg_id integer NOT NULL,
    module_no integer NOT NULL,
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    serial_number integer NOT NULL,
    student_amka character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Joins_pkey" PRIMARY KEY (wg_id, module_no, course_code, serial_number, student_amka),
    CONSTRAINT "Student_fkey" FOREIGN KEY (student_amka)
        REFERENCES public."Student" (amka) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "WorkGroup_fkeys" FOREIGN KEY (wg_id, course_code, module_no, serial_number)
        REFERENCES public."WorkGroup" (wg_id, course_code, module_no, serial_number) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Joins"
    OWNER to postgres;

