DROP TABLE IF EXISTS public.tokens;
DROP TABLE IF EXISTS public.authorization_requests;

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
    authorization_request_model_id uuid NOT NULL,
    extra_info json,
    scopes jsonb DEFAULT '[]'::jsonb NOT NULL
);

ALTER TABLE ONLY public.tokens ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);

CREATE TABLE public.authorization_requests (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    -- intitule character varying,
    -- description character varying,
    -- external_id character varying,
    -- status character varying,
    -- last_update timestamp without time zone,
    -- first_submitted_at timestamp without time zone,
    -- validated_at timestamp without time zone,
    created_at timestamp without time zone,
    -- user_id uuid NOT NULL,
    -- previous_external_id character varying,
    siret character varying
    -- api character varying NOT NULL,
    -- demarche character varying
);

ALTER TABLE ONLY public.authorization_requests ADD CONSTRAINT authorization_requests_pkey PRIMARY KEY (id);
