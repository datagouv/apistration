DROP TABLE IF EXISTS public.tokens;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE public.tokens (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    iat integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    exp integer NOT NULL,
    version character varying,
    blacklisted boolean DEFAULT false,
    -- days_left_notification_sent json DEFAULT '[]'::json NOT NULL,
    archived boolean DEFAULT false,
    temp_use_case character varying,
    -- authorization_request_id character varying,
    -- authorization_request_model_id uuid NOT NULL,
    extra_info json,
    scopes jsonb DEFAULT '[]'::jsonb NOT NULL
);

ALTER TABLE ONLY public.tokens ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);
