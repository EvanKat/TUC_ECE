-- Table: public.SchoolRules

-- DROP TABLE IF EXISTS public."SchoolRules";

CREATE TABLE IF NOT EXISTS public."SchoolRules"
(
    year integer NOT NULL,
    committee_members_no integer,
    min_units integer,
    min_courses integer,
    CONSTRAINT "SchoolRules_pkey" PRIMARY KEY (year)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."SchoolRules"
    OWNER to postgres;