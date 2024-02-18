-- Table: public.Diploma

-- DROP TABLE IF EXISTS public."Diploma";

CREATE TABLE IF NOT EXISTS public."Diploma"
(
    diploma_num integer NOT NULL,
    student_amka character varying COLLATE pg_catalog."default" NOT NULL,
    thesis_title character varying COLLATE pg_catalog."default",
    thesis_grade numeric,
    diploma_grade numeric,
    graduation_date date,
    CONSTRAINT "Diploma_pkey" PRIMARY KEY (diploma_num, student_amka),
    CONSTRAINT student_amka_fkey FOREIGN KEY (student_amka)
        REFERENCES public."Student" (amka) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Diploma"
    OWNER to postgres;