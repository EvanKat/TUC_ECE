-- Table: public.Committee

-- DROP TABLE IF EXISTS public."Committee";

CREATE TABLE IF NOT EXISTS public."Committee"
(
    student_amka character varying COLLATE pg_catalog."default" NOT NULL,
    diploma_num integer NOT NULL,
    prof_amka character varying COLLATE pg_catalog."default" NOT NULL,
    supervisor boolean,
    CONSTRAINT "Committee_pkey" PRIMARY KEY (student_amka, diploma_num, prof_amka),
    CONSTRAINT diploma_fkeys FOREIGN KEY (diploma_num, student_amka)
        REFERENCES public."Diploma" (diploma_num, student_amka) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        NOT VALID,
    CONSTRAINT prof_fkey FOREIGN KEY (prof_amka)
        REFERENCES public."Professor" (amka) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Committee"
    OWNER to postgres;
