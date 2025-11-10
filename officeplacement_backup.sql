--
-- PostgreSQL database dump
--

\restrict SznYWgFAWBZxnaWjbfmW56oR6GtOWLTBIPE3S6B0duPIJauifp1c2vK1PAW1gim

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-10-29 17:44:10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5460 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA "public"; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA "public" IS 'standard public schema';


--
-- TOC entry 2 (class 3079 OID 40960)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "btree_gist" WITH SCHEMA "public";


--
-- TOC entry 5461 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "btree_gist"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "btree_gist" IS 'support for indexing common datatypes in GiST';


SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 271 (class 1259 OID 50421)
-- Name: buildings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."buildings" (
    "building_id" integer NOT NULL,
    "code" "text" NOT NULL,
    "name" "text",
    "description" "text"
);


ALTER TABLE "public"."buildings" OWNER TO "postgres";

--
-- TOC entry 270 (class 1259 OID 50420)
-- Name: buildings_building_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."buildings_building_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."buildings_building_id_seq" OWNER TO "postgres";

--
-- TOC entry 5462 (class 0 OID 0)
-- Dependencies: 270
-- Name: buildings_building_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."buildings_building_id_seq" OWNED BY "public"."buildings"."building_id";


--
-- TOC entry 269 (class 1259 OID 50403)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."departments" (
    "department_id" integer NOT NULL,
    "name" "text" NOT NULL,
    "faculty_id" integer
);


ALTER TABLE "public"."departments" OWNER TO "postgres";

--
-- TOC entry 268 (class 1259 OID 50402)
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."departments_department_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."departments_department_id_seq" OWNER TO "postgres";

--
-- TOC entry 5463 (class 0 OID 0)
-- Dependencies: 268
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."departments_department_id_seq" OWNED BY "public"."departments"."department_id";


--
-- TOC entry 289 (class 1259 OID 50614)
-- Name: equipment_request_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."equipment_request_items" (
    "request_item_id" integer NOT NULL,
    "request_id" integer NOT NULL,
    "equipment_type_id" integer NOT NULL,
    "quantity" integer NOT NULL,
    "notes" "text"
);


ALTER TABLE "public"."equipment_request_items" OWNER TO "postgres";

--
-- TOC entry 288 (class 1259 OID 50613)
-- Name: equipment_request_items_request_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."equipment_request_items_request_item_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."equipment_request_items_request_item_id_seq" OWNER TO "postgres";

--
-- TOC entry 5464 (class 0 OID 0)
-- Dependencies: 288
-- Name: equipment_request_items_request_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."equipment_request_items_request_item_id_seq" OWNED BY "public"."equipment_request_items"."request_item_id";


--
-- TOC entry 287 (class 1259 OID 50589)
-- Name: equipment_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."equipment_requests" (
    "request_id" integer NOT NULL,
    "requester_id" integer NOT NULL,
    "target_room_id" integer,
    "requested_at" timestamp without time zone DEFAULT "now"() NOT NULL,
    "needed_by" "date",
    "status" "text" NOT NULL,
    "notes" "text",
    CONSTRAINT "equipment_requests_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'approved'::"text", 'rejected'::"text", 'fulfilled'::"text", 'cancelled'::"text"])))
);


ALTER TABLE "public"."equipment_requests" OWNER TO "postgres";

--
-- TOC entry 286 (class 1259 OID 50588)
-- Name: equipment_requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."equipment_requests_request_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."equipment_requests_request_id_seq" OWNER TO "postgres";

--
-- TOC entry 5465 (class 0 OID 0)
-- Dependencies: 286
-- Name: equipment_requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."equipment_requests_request_id_seq" OWNED BY "public"."equipment_requests"."request_id";


--
-- TOC entry 284 (class 1259 OID 50559)
-- Name: equipment_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."equipment_types" (
    "equipment_type_id" integer NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."equipment_types" OWNER TO "postgres";

--
-- TOC entry 283 (class 1259 OID 50558)
-- Name: equipment_types_equipment_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."equipment_types_equipment_type_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."equipment_types_equipment_type_id_seq" OWNER TO "postgres";

--
-- TOC entry 5466 (class 0 OID 0)
-- Dependencies: 283
-- Name: equipment_types_equipment_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."equipment_types_equipment_type_id_seq" OWNED BY "public"."equipment_types"."equipment_type_id";


--
-- TOC entry 267 (class 1259 OID 50390)
-- Name: faculties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."faculties" (
    "faculty_id" integer NOT NULL,
    "name" "text" NOT NULL
);


ALTER TABLE "public"."faculties" OWNER TO "postgres";

--
-- TOC entry 266 (class 1259 OID 50389)
-- Name: faculties_faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."faculties_faculty_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."faculties_faculty_id_seq" OWNER TO "postgres";

--
-- TOC entry 5467 (class 0 OID 0)
-- Dependencies: 266
-- Name: faculties_faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."faculties_faculty_id_seq" OWNED BY "public"."faculties"."faculty_id";


--
-- TOC entry 273 (class 1259 OID 50434)
-- Name: floors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."floors" (
    "floor_id" integer NOT NULL,
    "building_id" integer NOT NULL,
    "floor_number" integer NOT NULL
);


ALTER TABLE "public"."floors" OWNER TO "postgres";

--
-- TOC entry 272 (class 1259 OID 50433)
-- Name: floors_floor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."floors_floor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."floors_floor_id_seq" OWNER TO "postgres";

--
-- TOC entry 5468 (class 0 OID 0)
-- Dependencies: 272
-- Name: floors_floor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."floors_floor_id_seq" OWNED BY "public"."floors"."floor_id";


--
-- TOC entry 285 (class 1259 OID 50571)
-- Name: room_equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."room_equipment" (
    "room_id" integer NOT NULL,
    "equipment_type_id" integer NOT NULL,
    "quantity" integer
);


ALTER TABLE "public"."room_equipment" OWNER TO "postgres";

--
-- TOC entry 275 (class 1259 OID 50451)
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."rooms" (
    "room_id" integer NOT NULL,
    "room_number" "text" NOT NULL,
    "capacity" integer,
    "department_id" integer,
    "building_id" integer,
    "floor_id" integer
);


ALTER TABLE "public"."rooms" OWNER TO "postgres";

--
-- TOC entry 274 (class 1259 OID 50450)
-- Name: rooms_room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."rooms_room_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."rooms_room_id_seq" OWNER TO "postgres";

--
-- TOC entry 5469 (class 0 OID 0)
-- Dependencies: 274
-- Name: rooms_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."rooms_room_id_seq" OWNED BY "public"."rooms"."room_id";


--
-- TOC entry 279 (class 1259 OID 50492)
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."staff" (
    "staff_id" integer NOT NULL,
    "full_name" "text" NOT NULL,
    "title_id" integer,
    "primary_department_id" integer
);


ALTER TABLE "public"."staff" OWNER TO "postgres";

--
-- TOC entry 280 (class 1259 OID 50514)
-- Name: staff_department_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."staff_department_roles" (
    "staff_id" integer NOT NULL,
    "department_id" integer NOT NULL,
    "role" "text",
    "valid_from" "date" NOT NULL,
    "valid_to" "date",
    "is_primary" boolean
);


ALTER TABLE "public"."staff_department_roles" OWNER TO "postgres";

--
-- TOC entry 282 (class 1259 OID 50535)
-- Name: staff_room_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."staff_room_history" (
    "history_id" integer NOT NULL,
    "staff_id" integer NOT NULL,
    "room_id" integer NOT NULL,
    "valid_from" "date",
    "valid_to" "date",
    "notes" "text"
);


ALTER TABLE "public"."staff_room_history" OWNER TO "postgres";

--
-- TOC entry 281 (class 1259 OID 50534)
-- Name: staff_room_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."staff_room_history_history_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."staff_room_history_history_id_seq" OWNER TO "postgres";

--
-- TOC entry 5470 (class 0 OID 0)
-- Dependencies: 281
-- Name: staff_room_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."staff_room_history_history_id_seq" OWNED BY "public"."staff_room_history"."history_id";


--
-- TOC entry 278 (class 1259 OID 50491)
-- Name: staff_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."staff_staff_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."staff_staff_id_seq" OWNER TO "postgres";

--
-- TOC entry 5471 (class 0 OID 0)
-- Dependencies: 278
-- Name: staff_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."staff_staff_id_seq" OWNED BY "public"."staff"."staff_id";


--
-- TOC entry 277 (class 1259 OID 50479)
-- Name: titles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "public"."titles" (
    "title_id" integer NOT NULL,
    "title_name" "text" NOT NULL
);


ALTER TABLE "public"."titles" OWNER TO "postgres";

--
-- TOC entry 276 (class 1259 OID 50478)
-- Name: titles_title_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "public"."titles_title_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."titles_title_id_seq" OWNER TO "postgres";

--
-- TOC entry 5472 (class 0 OID 0)
-- Dependencies: 276
-- Name: titles_title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "public"."titles_title_id_seq" OWNED BY "public"."titles"."title_id";


--
-- TOC entry 5204 (class 2604 OID 50424)
-- Name: buildings building_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."buildings" ALTER COLUMN "building_id" SET DEFAULT "nextval"('"public"."buildings_building_id_seq"'::"regclass");


--
-- TOC entry 5203 (class 2604 OID 50406)
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."departments" ALTER COLUMN "department_id" SET DEFAULT "nextval"('"public"."departments_department_id_seq"'::"regclass");


--
-- TOC entry 5213 (class 2604 OID 50617)
-- Name: equipment_request_items request_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_request_items" ALTER COLUMN "request_item_id" SET DEFAULT "nextval"('"public"."equipment_request_items_request_item_id_seq"'::"regclass");


--
-- TOC entry 5211 (class 2604 OID 50592)
-- Name: equipment_requests request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_requests" ALTER COLUMN "request_id" SET DEFAULT "nextval"('"public"."equipment_requests_request_id_seq"'::"regclass");


--
-- TOC entry 5210 (class 2604 OID 50562)
-- Name: equipment_types equipment_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_types" ALTER COLUMN "equipment_type_id" SET DEFAULT "nextval"('"public"."equipment_types_equipment_type_id_seq"'::"regclass");


--
-- TOC entry 5202 (class 2604 OID 50393)
-- Name: faculties faculty_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."faculties" ALTER COLUMN "faculty_id" SET DEFAULT "nextval"('"public"."faculties_faculty_id_seq"'::"regclass");


--
-- TOC entry 5205 (class 2604 OID 50437)
-- Name: floors floor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."floors" ALTER COLUMN "floor_id" SET DEFAULT "nextval"('"public"."floors_floor_id_seq"'::"regclass");


--
-- TOC entry 5206 (class 2604 OID 50454)
-- Name: rooms room_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."rooms" ALTER COLUMN "room_id" SET DEFAULT "nextval"('"public"."rooms_room_id_seq"'::"regclass");


--
-- TOC entry 5208 (class 2604 OID 50495)
-- Name: staff staff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff" ALTER COLUMN "staff_id" SET DEFAULT "nextval"('"public"."staff_staff_id_seq"'::"regclass");


--
-- TOC entry 5209 (class 2604 OID 50538)
-- Name: staff_room_history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_room_history" ALTER COLUMN "history_id" SET DEFAULT "nextval"('"public"."staff_room_history_history_id_seq"'::"regclass");


--
-- TOC entry 5207 (class 2604 OID 50482)
-- Name: titles title_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."titles" ALTER COLUMN "title_id" SET DEFAULT "nextval"('"public"."titles_title_id_seq"'::"regclass");


--
-- TOC entry 5436 (class 0 OID 50421)
-- Dependencies: 271
-- Data for Name: buildings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (1, '(No', '(No,', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (2, 'AS', 'AS', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (3, 'Arts', 'Arts', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (4, 'Economics', 'Economics', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (5, 'Education', 'Education', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (6, 'Engineering', 'Engineering', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (7, 'Law', 'Law', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (8, 'Medicosocial', 'Medicosocial', NULL);
INSERT INTO "public"."buildings" ("building_id", "code", "name", "description") VALUES (9, 'Rector', 'Rector', NULL);


--
-- TOC entry 5434 (class 0 OID 50403)
-- Dependencies: 269
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (1, '(Unspecified)', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (2, 'Dean''s Office (Faculty of Architecture and Fine Arts) (Including Vice Dean)', 1);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (3, 'Dean''s Office (Faculty of Health Sciences)', 7);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (4, 'Dean''s Office - Faculty of Arts and Sciences', 3);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (5, 'Dean''s Office - Faculty of Economics and Administrative Sciences', 4);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (6, 'Dean''s Office - Faculty of Educational Sciences', 5);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (7, 'Dean''s Office - Faculty of Engineering', 6);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (8, 'Dean''s Office - Faculty of Law', 8);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (9, 'Faculty of Architecture', 1);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (10, 'Faculty of Arts and Sciences', 3);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (11, 'Faculty of Economics and Administrative Sciences', 4);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (12, 'Faculty of Educational Sciences', 5);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (13, 'Faculty of Educational Sciences & School of Foreign Languages', 5);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (14, 'Faculty of Educational Sciences & Vice Dean', 5);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (15, 'Faculty of Engineering', 6);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (16, 'Faculty of Engineering & Faculty of Architecture', 1);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (17, 'Faculty of Law & Faculty of Architecture', 1);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (18, 'Health Center & Vocational School Director', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (19, 'Institute of Graduate Studies Director (Including Vice Director)', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (20, 'Kitchen', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (21, 'Rector Coordinator', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (22, 'Rector Yardimcisi / Vice Rector', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (23, 'School of Foreign Languages', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (24, 'School of Physical Education and Sports Director', NULL);
INSERT INTO "public"."departments" ("department_id", "name", "faculty_id") VALUES (25, 'Yunus Emre Institute', NULL);


--
-- TOC entry 5454 (class 0 OID 50614)
-- Dependencies: 289
-- Data for Name: equipment_request_items; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5452 (class 0 OID 50589)
-- Dependencies: 287
-- Data for Name: equipment_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5449 (class 0 OID 50559)
-- Dependencies: 284
-- Data for Name: equipment_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."equipment_types" ("equipment_type_id", "name") VALUES (1, 'Desk');
INSERT INTO "public"."equipment_types" ("equipment_type_id", "name") VALUES (2, 'Chair');
INSERT INTO "public"."equipment_types" ("equipment_type_id", "name") VALUES (3, 'Cabinet');


--
-- TOC entry 5432 (class 0 OID 50390)
-- Dependencies: 267
-- Data for Name: faculties; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (1, 'Faculty of Architecture');
INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (2, 'Faculty of Architecture and Fine Arts) (Including Vice Dean)');
INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (3, 'Faculty of Arts and Sciences');
INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (4, 'Faculty of Economics and Administrative Sciences');
INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (5, 'Faculty of Educational Sciences');
INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (6, 'Faculty of Engineering');
INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (7, 'Faculty of Health Sciences)');
INSERT INTO "public"."faculties" ("faculty_id", "name") VALUES (8, 'Faculty of Law');


--
-- TOC entry 5438 (class 0 OID 50434)
-- Dependencies: 273
-- Data for Name: floors; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (1, 1, 2);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (2, 2, 2);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (3, 3, 1);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (4, 4, 1);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (5, 5, 1);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (6, 6, 1);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (7, 7, 1);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (8, 8, 1);
INSERT INTO "public"."floors" ("floor_id", "building_id", "floor_number") VALUES (9, 9, 1);


--
-- TOC entry 5450 (class 0 OID 50571)
-- Dependencies: 285
-- Data for Name: room_equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (1, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (1, 2, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (1, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (2, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (2, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (2, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (3, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (3, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (3, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (4, 1, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (4, 2, 6);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (4, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (5, 1, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (5, 2, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (5, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (6, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (6, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (6, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (7, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (7, 2, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (7, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (8, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (8, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (8, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (9, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (9, 2, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (9, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (10, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (10, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (10, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (11, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (11, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (11, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (12, 1, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (12, 2, 6);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (12, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (13, 1, 7);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (13, 2, 8);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (13, 3, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (14, 1, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (14, 2, 7);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (14, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (15, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (15, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (15, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (16, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (16, 2, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (16, 3, 1);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (17, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (17, 2, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (17, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (18, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (18, 2, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (18, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (19, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (19, 2, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (19, 3, 1);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (20, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (20, 2, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (20, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (21, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (21, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (21, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (22, 1, 1);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (22, 2, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (22, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (23, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (23, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (23, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (24, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (24, 2, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (24, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (25, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (25, 2, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (25, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (26, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (26, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (26, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (27, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (27, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (27, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (28, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (28, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (28, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (29, 1, 6);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (29, 2, 8);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (29, 3, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (30, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (30, 2, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (30, 3, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (31, 1, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (31, 2, 7);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (31, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (32, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (32, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (32, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (33, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (33, 2, 6);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (33, 3, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (34, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (34, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (34, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (35, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (35, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (35, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (36, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (36, 2, 4);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (36, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (37, 1, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (37, 2, 5);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (37, 3, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (38, 1, 2);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (38, 2, 3);
INSERT INTO "public"."room_equipment" ("room_id", "equipment_type_id", "quantity") VALUES (38, 3, 2);


--
-- TOC entry 5440 (class 0 OID 50451)
-- Dependencies: 275
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (1, 'AS - 111', 6, 1, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (2, 'AS - 112', 8, 19, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (3, 'AS - 113', 5, 11, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (4, 'AS - 114', 8, 11, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (5, 'AS - 115', 7, 15, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (6, 'AS - 116', 5, 10, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (7, 'AS - 117', 7, 15, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (8, 'AS - 118', 6, 10, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (9, 'AS - 119', 6, 16, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (10, 'AS - 120', 7, 11, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (11, 'AS - 121', 6, 11, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (12, 'AS - 122', 8, 17, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (13, 'AS - 123', 10, 1, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (14, 'AS - 123A', 8, 23, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (15, 'AS - 124', 5, 15, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (16, 'AS - 125', 4, 9, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (17, 'AS - 126', 4, 12, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (18, 'AS - 127', 5, 15, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (19, 'AS - 128', 4, 13, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (20, 'AS - 129', 5, 11, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (21, 'AS - 130', 6, 1, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (22, 'AS - 131', 4, 14, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (23, 'AS - 132', 5, 25, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (24, 'AS - 133', 6, 21, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (25, 'AS - 134', 5, 2, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (26, 'AS - 135', 5, 1, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (27, 'AS - 136', 6, 3, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (28, 'AS - 137', 5, 24, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (29, 'AS - 138', 9, 1, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (30, 'AS - 139', 6, 1, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (31, 'AS - 140', 8, 1, 2, 2);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (32, 'Rector Office', 6, 22, 9, 9);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (33, 'Engineering Dean', 8, 7, 6, 6);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (34, 'Education Dean', 6, 6, 5, 5);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (35, 'Law Dean', 6, 8, 7, 7);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (36, 'Economics Dean', 6, 5, 4, 4);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (37, 'Arts & Sciences Dean', 7, 4, 4, 3);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (38, 'Medicosocial', 5, 18, 8, 1);
INSERT INTO "public"."rooms" ("room_id", "room_number", "capacity", "department_id", "building_id", "floor_id") VALUES (39, '(No Door Sign)', 0, 20, 1, 1);


--
-- TOC entry 5444 (class 0 OID 50492)
-- Dependencies: 279
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (1, 'Assoc. Prof. Dr. Aprel ATAMGAZIYEV', 2, 11);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (2, 'Assist. Prof. Dr. Ayse S. BEYLI', 4, 11);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (3, 'Assist. Prof. Dr. Isme ROSYIDAH', 3, 11);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (4, 'Assist. Prof. Dr. Lokman GOKCE', 3, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (5, 'Assist. Prof. Dr. Mostafa Ayazali Mobarhan', 3, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (6, 'Assist. Prof. Dr. Murat ATES', 3, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (7, 'Assist. Prof. Dr. Rasime KAPTANLAR', 3, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (8, 'Assist. Prof. Dr. Saqra KAIN', 3, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (9, 'Assist. Prof. Dr. Sultan KARA', 3, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (10, 'Assist. Prof. Dr. Tojara LALIZO', 3, 15);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (11, 'Asst. Prof. Dr. Wael JABUR', 4, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (12, 'Assoc. Prof. Dr. Aminreza RAMMANESH', 2, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (13, 'Assoc. Prof. Dr. Basil OKIY', 2, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (14, 'Assoc. Prof. Dr. Fevad KARIM GHALEH JOUGI', 2, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (15, 'Assoc. Prof. Dr. Firat OZAL', 2, 21);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (16, 'Assoc. Prof. Dr. Hourakhsh A. NIAZOURY', 2, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (17, 'Assoc. Prof. Dr. Pejman LOTFIABADI', 2, 9);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (18, 'Assoc. Prof. Dr. Pouya ZAFARI', 2, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (19, 'Asst. Derya GEVEN', 3, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (20, 'Asst. Prof. Dr. Ali Hayye Beyoglu TAHIROGLU', 4, 15);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (21, 'Asst. Prof. Dr. Cemaliye BEYLI', 4, 11);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (22, 'Asst. Prof. Dr. Dervis USTUNYER', 4, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (23, 'Asst. Prof. Dr. E. LALE TIRELI', 4, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (24, 'Asst. Prof. Dr. Farit RIANE', 4, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (25, 'Asst. Prof. Dr. Gulnur AYDIN', 4, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (26, 'Asst. Prof. Dr. Hande DURMUSOGLU', 4, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (27, 'Asst. Prof. Dr. H. M. Pinar SALI', 4, 15);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (28, 'Asst. Prof. Dr. Hasan OZDAL', 4, 17);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (29, 'Asst. Prof. Dr. K. M. O. OBIOLA', 4, 11);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (30, 'Asst. Prof. Dr. Meryem KAMIL', 4, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (31, 'Asst. Prof. Dr. Pinar OZCAN', 4, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (32, 'Asst. Prof. Dr. R. GHAFFARZADEHNAHAVAND', 4, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (33, 'Asst. Prof. Dr. Vecide KOSE', 4, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (34, 'Asst. Prof. Dr. Zeina ATASSI', 4, 12);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (35, 'Asst. Prof. Dr. Ziba ASSININI', 4, 12);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (36, 'Asst. Prof. A. R. O. JABUR', 4, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (37, 'Asst. Prof. Merve KAMIL', 4, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (38, 'Asst. Prof. Merve UYSAL', 4, 11);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (39, 'Dr. ALEKSANDR LAKTIONOV', 6, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (40, 'Dr. ALIREZA MAGHSOUD LOU', 6, 15);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (41, 'Dr. A. P. E. OJO', 6, 12);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (42, 'Dr. Alex GONC', 6, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (43, 'Dr. Ammar MENDJIA', 6, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (44, 'Dr. Kamil O. OBIOLA', 6, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (45, 'Dr. Marie BAMBA', 6, 21);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (46, 'Dr. MUSTAFA AL BARDI', 6, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (47, 'Dr. Olumidebe Mukwel KWONKKE', 6, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (48, 'Dr. Tarek ELSALEH', 6, 10);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (49, 'Instructor Ali BAHADIR', 7, 20);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (50, 'Instructor Esma Deren Ozdalcin', 7, 20);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (51, 'Instructor Nil AGABEYOGLU', 7, 12);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (52, 'Lecturer Fatma D. KAZIMOGLU', 8, 12);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (53, 'Lecturer Gokce OZKARAN', 8, 12);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (54, 'Lecturer Berfu CELEBI', 8, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (55, 'Lecturer Bulent AYTAC', 8, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (56, 'Lecturer Gabriel NIENDHI', 8, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (57, 'Lecturer Ibrahim Y. GUNERI', 8, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (58, 'Lecturer Olatehan EBIWOWO', 8, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (59, 'Lecturer Salar FARAJI', 8, 15);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (60, 'Lecturer Sengul AYGUN', 8, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (61, 'Lecturer Ugurcan TASDELEN', 8, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (62, 'Lecturer Yesim M. P. GUNAY', 8, 15);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (63, 'Lecturer Zeynep DILNIHIN BAYRAM', 8, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (64, 'Prof. Dr. ABDELKADIR GUL', 9, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (65, 'Prof. Dr. Abdulkadir OZDE', 9, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (66, 'Prof. Dr. Ali Murat KUNZI', 9, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (67, 'Prof. Dr. BASHIR A. OMAR', 9, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (68, 'Prof. Dr. BIDO', 9, 22);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (69, 'Prof. Dr. E. Osman EGESIOGLU', 9, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (70, 'Prof. Dr. Elif Yesim USTUN', 9, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (71, 'Prof. Dr. Evren HINCAL', 9, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (72, 'Prof. Dr. Gsemra OKSUZOGLU', 9, 10);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (73, 'Prof. Dr. Ibrahim Levent TANMAN', 9, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (74, 'Prof. Dr. Isa DAURA', 9, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (75, 'R. Asst. Alireza KERMANI', 10, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (76, 'R. Asst. Dr. Aytac Y. P. UCANSUOGLU', 10, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (77, 'R. Asst. Caralekwa Nnveka ONYEZEU', 10, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (78, 'R. Asst. E. D. GORMEZLI', 10, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (79, 'R. Asst. Imane BOUMEDINA', 10, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (80, 'R. Asst. M. A. ISLAM', 10, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (81, 'Sen. Inst. ABBAZ BABAYI', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (82, 'Sen. Inst. Ata CELEBI', 13, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (83, 'Sen. Inst. Ayla B. B. DURAN', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (84, 'Sen. Inst. Ayse OZKOLAY', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (85, 'Sen. Inst. Cigdem M. CILASUN', 13, 20);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (86, 'Sen. Inst. Derk KABA', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (87, 'Sen. Inst. DICLE SOZER', 13, 9);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (88, 'Sen. Inst. Ece UYSAL', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (89, 'Sen. Inst. Ecem SUHYACINA', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (90, 'Sen. Inst. FUNDA BAGCI', 13, 21);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (91, 'Sen. Inst. Gaelle YOUBI', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (92, 'Sen. Inst. I. U. BASSEY', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (93, 'Sen. Inst. Hussein BAHMANIAN', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (94, 'Sen. Inst. Josephat Ayobamidele VAUGHAN', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (95, 'Sen. Inst. Levent ISANOVA', 13, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (96, 'Sen. Inst. M. B. JALLOW', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (97, 'Sen. Inst. Musret K. KAHVECIOGLU', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (98, 'Sen. Inst. Nihat BUYUKOGLU', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (99, 'Sen. Inst. Nurcan S. R. BILGE', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (100, 'Sen. Inst. Dennis UZUN', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (101, 'Sen. Inst. Ozlem D. CEYLAN', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (102, 'Sen. Inst. Rozan DOSTRES', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (103, 'Sen. Inst. Sacra GAGA', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (104, 'Sen. Inst. Salomeh DEHGHAN', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (105, 'Sen. Inst. Silvia SIMKA', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (106, 'Sen. Inst. Sohila E. TALEBNIA', 13, 2);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (107, 'Sen. Inst. Sonia SHOAR', 13, 1);
INSERT INTO "public"."staff" ("staff_id", "full_name", "title_id", "primary_department_id") VALUES (108, 'Sen. Inst. SUNDAY CHIBONN TASONG', 13, 2);


--
-- TOC entry 5445 (class 0 OID 50514)
-- Dependencies: 280
-- Data for Name: staff_department_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (83, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (63, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (74, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (15, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (41, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (26, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (24, 11, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (31, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (23, 15, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (3, 11, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (43, 15, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (4, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (42, 10, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (44, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (10, 15, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (60, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (61, 10, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (64, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (65, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (53, 16, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (54, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (7, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (5, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (33, 11, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (37, 11, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (30, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (40, 15, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (27, 17, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (25, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (46, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (11, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (21, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (22, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (80, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (55, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (98, 23, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (100, 23, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (103, 15, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (101, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (81, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (19, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (35, 12, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (52, 12, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (104, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (92, 13, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (69, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (58, 11, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (73, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (97, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (56, 14, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (57, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (51, 25, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (17, 21, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (45, 21, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (14, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (20, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (48, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (76, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (79, 3, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (12, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (8, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (38, 12, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (50, 24, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (49, 20, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (93, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (89, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (77, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (107, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (96, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (84, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (108, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (82, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (105, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (99, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (70, 22, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (6, 1, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (16, 7, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (67, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (87, 4, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (91, 4, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (66, 2, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (2, 18, NULL, '2015-01-10', '2028-01-10', true);
INSERT INTO "public"."staff_department_roles" ("staff_id", "department_id", "role", "valid_from", "valid_to", "is_primary") VALUES (78, 1, NULL, '2015-01-10', '2028-01-10', true);


--
-- TOC entry 5447 (class 0 OID 50535)
-- Dependencies: 282
-- Data for Name: staff_room_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (3, 3, 39, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (4, 4, 11, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (5, 5, 10, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (6, 6, 7, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (7, 7, 12, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (8, 8, 4, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (9, 9, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (10, 10, 12, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (11, 11, 5, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (12, 12, 28, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (13, 13, 32, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (14, 14, 25, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (15, 15, 6, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (16, 16, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (17, 17, 24, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (18, 18, 34, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (19, 19, 16, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (20, 20, 13, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (21, 21, 13, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (22, 22, 10, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (23, 23, 5, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (24, 24, 4, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (25, 25, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (26, 26, 4, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (27, 27, 5, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (28, 28, 28, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (29, 29, 38, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (30, 30, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (31, 31, 15, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (32, 32, 3, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (33, 33, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (34, 34, 12, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (35, 35, 17, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (36, 36, 7, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (37, 37, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (38, 38, 20, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (39, 39, 15, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (40, 40, 19, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (41, 41, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (42, 42, 6, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (43, 43, 15, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (44, 44, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (45, 45, 21, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (46, 46, 18, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (47, 47, 24, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (48, 48, 16, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (49, 49, 11, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (50, 50, 26, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (51, 51, 2, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (52, 52, 23, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (53, 53, 2, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (54, 54, 17, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (55, 55, 14, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (56, 56, 23, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (57, 57, 3, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (58, 58, 2, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (59, 59, 16, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (60, 60, 14, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (61, 61, 8, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (62, 62, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (63, 63, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (64, 64, 12, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (65, 65, 8, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (66, 66, 8, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (67, 67, 8, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (68, 68, 35, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (69, 69, 27, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (70, 70, 3, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (71, 71, 37, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (72, 72, 21, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (73, 73, 36, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (74, 74, 33, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (75, 75, 3, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (76, 76, 33, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (77, 77, 10, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (78, 78, 6, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (79, 79, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (80, 80, 27, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (81, 81, 31, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (82, 82, 13, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (83, 83, 31, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (84, 84, 3, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (85, 85, 31, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (86, 86, 30, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (87, 87, 30, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (88, 88, 31, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (89, 89, 30, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (90, 90, 38, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (91, 91, 30, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (92, 92, 14, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (93, 93, 29, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (94, 94, 29, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (95, 95, 32, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (96, 96, 29, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (97, 97, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (98, 98, 29, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (99, 99, 21, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (100, 100, 30, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (101, 101, 31, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (102, 102, 30, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (103, 103, 29, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (104, 104, 19, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (105, 105, 18, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (106, 106, 27, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (107, 107, 1, '2015-01-10', '2028-01-10', NULL);
INSERT INTO "public"."staff_room_history" ("history_id", "staff_id", "room_id", "valid_from", "valid_to", "notes") VALUES (108, 108, 31, '2015-01-10', '2028-01-10', NULL);


--
-- TOC entry 5442 (class 0 OID 50479)
-- Dependencies: 277
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (1, 'Assist. Prof.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (2, 'Assoc. Prof. Dr.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (3, 'Asst. Prof.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (4, 'Asst. Prof. Dr.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (5, 'Asst.Prof.Dr.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (6, 'Dr.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (7, 'Instructor');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (8, 'Lecturer');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (9, 'Prof. Dr.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (10, 'R. Asst.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (11, 'R.Asst.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (12, 'Res. Asst.');
INSERT INTO "public"."titles" ("title_id", "title_name") VALUES (13, 'Sen. Inst.');


--
-- TOC entry 5473 (class 0 OID 0)
-- Dependencies: 270
-- Name: buildings_building_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."buildings_building_id_seq"', 1, false);


--
-- TOC entry 5474 (class 0 OID 0)
-- Dependencies: 268
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."departments_department_id_seq"', 1, false);


--
-- TOC entry 5475 (class 0 OID 0)
-- Dependencies: 288
-- Name: equipment_request_items_request_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."equipment_request_items_request_item_id_seq"', 1, false);


--
-- TOC entry 5476 (class 0 OID 0)
-- Dependencies: 286
-- Name: equipment_requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."equipment_requests_request_id_seq"', 1, false);


--
-- TOC entry 5477 (class 0 OID 0)
-- Dependencies: 283
-- Name: equipment_types_equipment_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."equipment_types_equipment_type_id_seq"', 1, false);


--
-- TOC entry 5478 (class 0 OID 0)
-- Dependencies: 266
-- Name: faculties_faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."faculties_faculty_id_seq"', 1, false);


--
-- TOC entry 5479 (class 0 OID 0)
-- Dependencies: 272
-- Name: floors_floor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."floors_floor_id_seq"', 1, false);


--
-- TOC entry 5480 (class 0 OID 0)
-- Dependencies: 274
-- Name: rooms_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."rooms_room_id_seq"', 1, false);


--
-- TOC entry 5481 (class 0 OID 0)
-- Dependencies: 281
-- Name: staff_room_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."staff_room_history_history_id_seq"', 1, false);


--
-- TOC entry 5482 (class 0 OID 0)
-- Dependencies: 278
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."staff_staff_id_seq"', 1, false);


--
-- TOC entry 5483 (class 0 OID 0)
-- Dependencies: 276
-- Name: titles_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."titles_title_id_seq"', 1, false);


--
-- TOC entry 5224 (class 2606 OID 50432)
-- Name: buildings buildings_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."buildings"
    ADD CONSTRAINT "buildings_code_key" UNIQUE ("code");


--
-- TOC entry 5226 (class 2606 OID 50430)
-- Name: buildings buildings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."buildings"
    ADD CONSTRAINT "buildings_pkey" PRIMARY KEY ("building_id");


--
-- TOC entry 5220 (class 2606 OID 50414)
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."departments"
    ADD CONSTRAINT "departments_name_key" UNIQUE ("name");


--
-- TOC entry 5222 (class 2606 OID 50412)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."departments"
    ADD CONSTRAINT "departments_pkey" PRIMARY KEY ("department_id");


--
-- TOC entry 5264 (class 2606 OID 50625)
-- Name: equipment_request_items equipment_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_request_items"
    ADD CONSTRAINT "equipment_request_items_pkey" PRIMARY KEY ("request_item_id");


--
-- TOC entry 5266 (class 2606 OID 50627)
-- Name: equipment_request_items equipment_request_items_request_id_equipment_type_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_request_items"
    ADD CONSTRAINT "equipment_request_items_request_id_equipment_type_id_key" UNIQUE ("request_id", "equipment_type_id");


--
-- TOC entry 5261 (class 2606 OID 50602)
-- Name: equipment_requests equipment_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_requests"
    ADD CONSTRAINT "equipment_requests_pkey" PRIMARY KEY ("request_id");


--
-- TOC entry 5255 (class 2606 OID 50570)
-- Name: equipment_types equipment_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_types"
    ADD CONSTRAINT "equipment_types_name_key" UNIQUE ("name");


--
-- TOC entry 5257 (class 2606 OID 50568)
-- Name: equipment_types equipment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_types"
    ADD CONSTRAINT "equipment_types_pkey" PRIMARY KEY ("equipment_type_id");


--
-- TOC entry 5216 (class 2606 OID 50401)
-- Name: faculties faculties_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."faculties"
    ADD CONSTRAINT "faculties_name_key" UNIQUE ("name");


--
-- TOC entry 5218 (class 2606 OID 50399)
-- Name: faculties faculties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."faculties"
    ADD CONSTRAINT "faculties_pkey" PRIMARY KEY ("faculty_id");


--
-- TOC entry 5228 (class 2606 OID 50444)
-- Name: floors floors_building_id_floor_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."floors"
    ADD CONSTRAINT "floors_building_id_floor_number_key" UNIQUE ("building_id", "floor_number");


--
-- TOC entry 5230 (class 2606 OID 50442)
-- Name: floors floors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."floors"
    ADD CONSTRAINT "floors_pkey" PRIMARY KEY ("floor_id");


--
-- TOC entry 5259 (class 2606 OID 50577)
-- Name: room_equipment room_equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."room_equipment"
    ADD CONSTRAINT "room_equipment_pkey" PRIMARY KEY ("room_id", "equipment_type_id");


--
-- TOC entry 5234 (class 2606 OID 50460)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."rooms"
    ADD CONSTRAINT "rooms_pkey" PRIMARY KEY ("room_id");


--
-- TOC entry 5236 (class 2606 OID 50462)
-- Name: rooms rooms_room_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."rooms"
    ADD CONSTRAINT "rooms_room_number_key" UNIQUE ("room_number");


--
-- TOC entry 5251 (class 2606 OID 50557)
-- Name: staff_room_history srh_no_overlap; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_room_history"
    ADD CONSTRAINT "srh_no_overlap" EXCLUDE USING "gist" ("staff_id" WITH =, "daterange"("valid_from", COALESCE("valid_to", 'infinity'::"date"), '[]'::"text") WITH &&);


--
-- TOC entry 5248 (class 2606 OID 50523)
-- Name: staff_department_roles staff_department_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_department_roles"
    ADD CONSTRAINT "staff_department_roles_pkey" PRIMARY KEY ("staff_id", "department_id", "valid_from");


--
-- TOC entry 5242 (class 2606 OID 50503)
-- Name: staff staff_full_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff"
    ADD CONSTRAINT "staff_full_name_key" UNIQUE ("full_name");


--
-- TOC entry 5244 (class 2606 OID 50501)
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff"
    ADD CONSTRAINT "staff_pkey" PRIMARY KEY ("staff_id");


--
-- TOC entry 5253 (class 2606 OID 50545)
-- Name: staff_room_history staff_room_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_room_history"
    ADD CONSTRAINT "staff_room_history_pkey" PRIMARY KEY ("history_id");


--
-- TOC entry 5238 (class 2606 OID 50488)
-- Name: titles titles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."titles"
    ADD CONSTRAINT "titles_pkey" PRIMARY KEY ("title_id");


--
-- TOC entry 5240 (class 2606 OID 50490)
-- Name: titles titles_title_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."titles"
    ADD CONSTRAINT "titles_title_name_key" UNIQUE ("title_name");


--
-- TOC entry 5262 (class 1259 OID 50643)
-- Name: idx_req_requester; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_req_requester" ON "public"."equipment_requests" USING "btree" ("requester_id", "status");


--
-- TOC entry 5231 (class 1259 OID 50639)
-- Name: idx_rooms_building; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_rooms_building" ON "public"."rooms" USING "btree" ("building_id");


--
-- TOC entry 5232 (class 1259 OID 50638)
-- Name: idx_rooms_dept; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_rooms_dept" ON "public"."rooms" USING "btree" ("department_id");


--
-- TOC entry 5245 (class 1259 OID 50641)
-- Name: idx_sdr_dept; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_sdr_dept" ON "public"."staff_department_roles" USING "btree" ("department_id");


--
-- TOC entry 5246 (class 1259 OID 50640)
-- Name: idx_sdr_staff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_sdr_staff" ON "public"."staff_department_roles" USING "btree" ("staff_id");


--
-- TOC entry 5249 (class 1259 OID 50642)
-- Name: idx_srh_staff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "idx_srh_staff" ON "public"."staff_room_history" USING "btree" ("staff_id");


--
-- TOC entry 5267 (class 2606 OID 50415)
-- Name: departments departments_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."departments"
    ADD CONSTRAINT "departments_faculty_id_fkey" FOREIGN KEY ("faculty_id") REFERENCES "public"."faculties"("faculty_id");


--
-- TOC entry 5282 (class 2606 OID 50633)
-- Name: equipment_request_items equipment_request_items_equipment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_request_items"
    ADD CONSTRAINT "equipment_request_items_equipment_type_id_fkey" FOREIGN KEY ("equipment_type_id") REFERENCES "public"."equipment_types"("equipment_type_id");


--
-- TOC entry 5283 (class 2606 OID 50628)
-- Name: equipment_request_items equipment_request_items_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_request_items"
    ADD CONSTRAINT "equipment_request_items_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "public"."equipment_requests"("request_id") ON DELETE CASCADE;


--
-- TOC entry 5280 (class 2606 OID 50603)
-- Name: equipment_requests equipment_requests_requester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_requests"
    ADD CONSTRAINT "equipment_requests_requester_id_fkey" FOREIGN KEY ("requester_id") REFERENCES "public"."staff"("staff_id");


--
-- TOC entry 5281 (class 2606 OID 50608)
-- Name: equipment_requests equipment_requests_target_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."equipment_requests"
    ADD CONSTRAINT "equipment_requests_target_room_id_fkey" FOREIGN KEY ("target_room_id") REFERENCES "public"."rooms"("room_id");


--
-- TOC entry 5268 (class 2606 OID 50445)
-- Name: floors floors_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."floors"
    ADD CONSTRAINT "floors_building_id_fkey" FOREIGN KEY ("building_id") REFERENCES "public"."buildings"("building_id");


--
-- TOC entry 5278 (class 2606 OID 50583)
-- Name: room_equipment room_equipment_equipment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."room_equipment"
    ADD CONSTRAINT "room_equipment_equipment_type_id_fkey" FOREIGN KEY ("equipment_type_id") REFERENCES "public"."equipment_types"("equipment_type_id");


--
-- TOC entry 5279 (class 2606 OID 50578)
-- Name: room_equipment room_equipment_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."room_equipment"
    ADD CONSTRAINT "room_equipment_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("room_id") ON DELETE CASCADE;


--
-- TOC entry 5269 (class 2606 OID 50468)
-- Name: rooms rooms_building_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."rooms"
    ADD CONSTRAINT "rooms_building_id_fkey" FOREIGN KEY ("building_id") REFERENCES "public"."buildings"("building_id");


--
-- TOC entry 5270 (class 2606 OID 50463)
-- Name: rooms rooms_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."rooms"
    ADD CONSTRAINT "rooms_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "public"."departments"("department_id") ON DELETE SET NULL;


--
-- TOC entry 5271 (class 2606 OID 50473)
-- Name: rooms rooms_floor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."rooms"
    ADD CONSTRAINT "rooms_floor_id_fkey" FOREIGN KEY ("floor_id") REFERENCES "public"."floors"("floor_id");


--
-- TOC entry 5274 (class 2606 OID 50529)
-- Name: staff_department_roles staff_department_roles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_department_roles"
    ADD CONSTRAINT "staff_department_roles_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "public"."departments"("department_id");


--
-- TOC entry 5275 (class 2606 OID 50524)
-- Name: staff_department_roles staff_department_roles_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_department_roles"
    ADD CONSTRAINT "staff_department_roles_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "public"."staff"("staff_id") ON DELETE CASCADE;


--
-- TOC entry 5272 (class 2606 OID 50509)
-- Name: staff staff_primary_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff"
    ADD CONSTRAINT "staff_primary_department_id_fkey" FOREIGN KEY ("primary_department_id") REFERENCES "public"."departments"("department_id") ON DELETE SET NULL;


--
-- TOC entry 5276 (class 2606 OID 50551)
-- Name: staff_room_history staff_room_history_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_room_history"
    ADD CONSTRAINT "staff_room_history_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."rooms"("room_id") ON DELETE CASCADE;


--
-- TOC entry 5277 (class 2606 OID 50546)
-- Name: staff_room_history staff_room_history_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff_room_history"
    ADD CONSTRAINT "staff_room_history_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "public"."staff"("staff_id") ON DELETE CASCADE;


--
-- TOC entry 5273 (class 2606 OID 50504)
-- Name: staff staff_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "public"."staff"
    ADD CONSTRAINT "staff_title_id_fkey" FOREIGN KEY ("title_id") REFERENCES "public"."titles"("title_id");


-- Completed on 2025-10-29 17:44:10

--
-- PostgreSQL database dump complete
--

\unrestrict SznYWgFAWBZxnaWjbfmW56oR6GtOWLTBIPE3S6B0duPIJauifp1c2vK1PAW1gim

