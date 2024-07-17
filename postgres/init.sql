ALTER DATABASE "User" OWNER TO postgres;

\connect "User"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER SCHEMA public OWNER TO pg_database_owner;

CREATE FUNCTION public.add_user(name character varying, email character varying, additional_info json) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_user_id INT;
BEGIN
    INSERT INTO public."User"("Name", "Email", additionalinfo)
    VALUES (name, email, additional_info)
    RETURNING "Id" INTO new_user_id;

    RETURN new_user_id;
END;
$$;


ALTER FUNCTION public.add_user(name character varying, email character varying, additional_info json) OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 16413)
-- Name: add_users(character varying, character varying, json); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_users(IN name character varying, IN email character varying, IN additional_info json, OUT new_user_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "User" ("Name", "Email", AdditionalInfo)
    VALUES (name, email, additional_info)
    RETURNING "Id" INTO new_user_id;
END;
$$;


ALTER PROCEDURE public.add_users(IN name character varying, IN email character varying, IN additional_info json, OUT new_user_id integer) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 16406)
-- Name: get_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_users() RETURNS TABLE(id integer, name character varying, email character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
   SELECT "Id", "Name", "Email"
	FROM public."User";
END;
$$;


ALTER FUNCTION public.get_users() OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 16414)
-- Name: get_users_by_department(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_users_by_department(department character varying) RETURNS TABLE(id integer, name character varying, email character varying, additional_info json)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
     SELECT "Id", "Name", "Email", AdditionalInfo
    FROM "User"
    WHERE AdditionalInfo->>'department' = department;
END;
$$;


ALTER FUNCTION public.get_users_by_department(department character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16400)
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    "Id" integer NOT NULL,
    "Name" character varying,
    "Email" character varying,
    additionalinfo json
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16399)
-- Name: User_Id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_Id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_Id_seq" OWNER TO postgres;

--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 215
-- Name: User_Id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_Id_seq" OWNED BY public."User"."Id";


--
-- TOC entry 4693 (class 2604 OID 16403)
-- Name: User Id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN "Id" SET DEFAULT nextval('public."User_Id_seq"'::regclass);


--
-- TOC entry 4838 (class 0 OID 16400)
-- Dependencies: 216
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."User" VALUES (1, 'Priya', 'priya@yopmail.com', '{"department":"HR"}') ON CONFLICT DO NOTHING;
INSERT INTO public."User" VALUES (2, 'Karan', 'karan@example.com', '{
  "Department": "HR",
  "Phone": "555-555-5555"
}') ON CONFLICT DO NOTHING;
INSERT INTO public."User" VALUES (3, 'Rinkal', 'rinkal@example.com', '{"department":"HR"}') ON CONFLICT DO NOTHING;
INSERT INTO public."User" VALUES (4, 'Nisarg', 'nisarg@example.com', '{
  "Department": "HR",
  "Phone": "555-555-5555"
}') ON CONFLICT DO NOTHING;
INSERT INTO public."User" VALUES (5, 'Samarth', 'samarth@example.com', '{
  "Department": "Finance",
  "Phone": "555-555-5555"
}') ON CONFLICT DO NOTHING;


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 215
-- Name: User_Id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_Id_seq"', 5, true);


-- Completed on 2024-07-11 16:28:00

--
-- PostgreSQL database dump complete
--

