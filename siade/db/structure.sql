DROP TABLE IF EXISTS public.authorization_request_security_settings;
DROP TABLE IF EXISTS public.tokens;
DROP TABLE IF EXISTS public.authorization_requests;
DROP MATERIALIZED VIEW IF EXISTS public.admin_apientreprise_test_access_logs_last_10_minutes;
DROP TABLE IF EXISTS public.access_logs;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE public.tokens (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    iat integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    exp integer NOT NULL,
    version character varying,
    blacklisted_at timestamp without time zone DEFAULT NULL,
    -- days_left_notification_sent json DEFAULT '[]'::json NOT NULL,
    archived boolean DEFAULT false,
    temp_use_case character varying,
    authorization_request_model_id uuid NOT NULL,
    extra_info json,
    scopes jsonb DEFAULT '[]'::jsonb NOT NULL,
    mcp boolean DEFAULT false
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
    siret character varying,
    -- api character varying NOT NULL,
    -- demarche character varying
    scopes jsonb DEFAULT '[]'::jsonb NOT NULL
);

ALTER TABLE ONLY public.authorization_requests ADD CONSTRAINT authorization_requests_pkey PRIMARY KEY (id);

CREATE TABLE public.authorization_request_security_settings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    authorization_request_id uuid NOT NULL,
    rate_limit_per_minute integer,
    allowed_ips jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE ONLY public.authorization_request_security_settings ADD CONSTRAINT authorization_request_security_settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.authorization_request_security_settings ADD CONSTRAINT fk_authorization_request FOREIGN KEY (authorization_request_id) REFERENCES public.authorization_requests(id);
CREATE UNIQUE INDEX index_arss_on_authorization_request_id ON public.authorization_request_security_settings USING btree (authorization_request_id);

CREATE TABLE public.access_logs (
  timestamp timestamp with time zone,
  route character varying,
  status character varying,
  path character varying,
  cached boolean
);

CREATE MATERIALIZED VIEW public.admin_apientreprise_test_access_logs_last_10_minutes AS
  SELECT "timestamp",
    route,
    status
  FROM
    public.access_logs
  WHERE
    ("timestamp" >= (now() + '-00:10:00'::interval))
;
