-- Table: public.LabModule

-- DROP TABLE IF EXISTS public."LabModule";

CREATE TABLE IF NOT EXISTS public."LabModule"
(
    module_no integer NOT NULL,
    serial_number integer NOT NULL,
    percentage numeric,
    max_members numeric,
    title character varying COLLATE pg_catalog."default",
    course_code character(7) COLLATE pg_catalog."default" NOT NULL,
    type "labModule_type",
    CONSTRAINT "LabModule_pkey" PRIMARY KEY (course_code, module_no, serial_number),
    CONSTRAINT "CourseRun_fkeys" FOREIGN KEY (course_code, serial_number)
        REFERENCES public."CourseRun" (course_code, serial_number) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."LabModule"
    OWNER to postgres;