-- Type: labModule_type

-- DROP TYPE IF EXISTS public."labModule_type";

CREATE TYPE public."labModule_type" AS ENUM
    ('project', 'lab_exercise');

ALTER TYPE public."labModule_type"
    OWNER TO postgres;
