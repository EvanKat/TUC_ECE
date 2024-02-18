-- Table: public.WorkGroup

-- DROP TABLE IF EXISTS public."WorkGroup";

CREATE TABLE IF NOT EXISTS public."WorkGroup"
(
    wg_id integer NOT NULL,
    module_no integer NOT NULL,
    serial_number integer NOT NULL,
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    grade numeric,
    CONSTRAINT "WorkGroup_pkey" PRIMARY KEY (wg_id, module_no, serial_number, course_code),
    CONSTRAINT "LabModule_fkeys" FOREIGN KEY (course_code, module_no, serial_number)
        REFERENCES public."LabModule" (course_code, module_no, serial_number) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."WorkGroup"
    OWNER to postgres;