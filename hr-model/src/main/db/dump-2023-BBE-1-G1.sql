--
-- PostgreSQL database dump
--

-- Dumped from database version 11.16 (Debian 11.16-0+deb10u1)
-- Dumped by pg_dump version 14.2

-- Started on 2023-07-27 08:05:31

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

DROP DATABASE "2023-BBE-1-G1";
--
-- TOC entry 3055 (class 1262 OID 206202)
-- Name: 2023-BBE-1-G1; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "2023-BBE-1-G1" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


\connect -reuse-previous=on "dbname='2023-BBE-1-G1'"

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

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 3056 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 611 (class 1247 OID 230402)
-- Name: day; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.day AS ENUM (
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
);


--
-- TOC entry 665 (class 1247 OID 224368)
-- Name: shift; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.shift AS ENUM (
    'first',
    'second',
    'third'
);


SET default_tablespace = '';

--
-- TOC entry 204 (class 1259 OID 220655)
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    room_id integer NOT NULL,
    arrival_date date NOT NULL,
    departure_date date NOT NULL,
    user_login_name character varying(255) NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 220653)
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3057 (class 0 OID 0)
-- Dependencies: 203
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- TOC entry 201 (class 1259 OID 220632)
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 220630)
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3058 (class 0 OID 0)
-- Dependencies: 200
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- TOC entry 218 (class 1259 OID 263577)
-- Name: employees_entry_departure; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees_entry_departure (
    id integer NOT NULL,
    login_name character varying NOT NULL,
    working_day date NOT NULL,
    entry time without time zone NOT NULL,
    departure time without time zone
);


--
-- TOC entry 217 (class 1259 OID 263575)
-- Name: employees_entry_departure_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employees_entry_departure_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3059 (class 0 OID 0)
-- Dependencies: 217
-- Name: employees_entry_departure_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employees_entry_departure_id_seq OWNED BY public.employees_entry_departure.id;


--
-- TOC entry 197 (class 1259 OID 220608)
-- Name: hotels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hotels (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    number_of_floors integer NOT NULL
);


--
-- TOC entry 196 (class 1259 OID 220606)
-- Name: hotels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hotels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3060 (class 0 OID 0)
-- Dependencies: 196
-- Name: hotels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hotels_id_seq OWNED BY public.hotels.id;


--
-- TOC entry 206 (class 1259 OID 220675)
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    rolename character varying(255) NOT NULL,
    xml_client_permission character varying(10485760) DEFAULT '<?xml version="1.0" encoding="UTF-8"?><security></security>'::character varying NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 220673)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3061 (class 0 OID 0)
-- Dependencies: 205
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.role_id;


--
-- TOC entry 210 (class 1259 OID 220695)
-- Name: roles_server_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles_server_permissions (
    id integer NOT NULL,
    role_id integer,
    server_permission_id integer
);


--
-- TOC entry 209 (class 1259 OID 220693)
-- Name: roles_server_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_server_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3062 (class 0 OID 0)
-- Dependencies: 209
-- Name: roles_server_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_server_permissions_id_seq OWNED BY public.roles_server_permissions.id;


--
-- TOC entry 212 (class 1259 OID 220713)
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles_users (
    id integer NOT NULL,
    login_name character varying(255),
    role_id integer
);


--
-- TOC entry 211 (class 1259 OID 220711)
-- Name: roles_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3063 (class 0 OID 0)
-- Dependencies: 211
-- Name: roles_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_users_id_seq OWNED BY public.roles_users.id;


--
-- TOC entry 199 (class 1259 OID 220616)
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    room_number integer NOT NULL,
    hotel_id integer NOT NULL,
    number_of_beds integer NOT NULL,
    base_price numeric NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 220614)
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3064 (class 0 OID 0)
-- Dependencies: 198
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- TOC entry 208 (class 1259 OID 220687)
-- Name: server_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.server_permissions (
    server_permission_id integer NOT NULL,
    method character varying(255) NOT NULL
);


--
-- TOC entry 207 (class 1259 OID 220685)
-- Name: server_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.server_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3065 (class 0 OID 0)
-- Dependencies: 207
-- Name: server_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.server_permissions_id_seq OWNED BY public.server_permissions.server_permission_id;


--
-- TOC entry 214 (class 1259 OID 230437)
-- Name: shifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shifts (
    id integer NOT NULL,
    role_id integer,
    monday character varying(23),
    tuesday character varying(23),
    wednesday character varying(23),
    thursday character varying(23),
    friday character varying(23),
    saturday character varying(23),
    sunday character varying(23),
    hotel_id integer
);


--
-- TOC entry 213 (class 1259 OID 230435)
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shifts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3066 (class 0 OID 0)
-- Dependencies: 213
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;


--
-- TOC entry 202 (class 1259 OID 220638)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    login_name character varying(255) NOT NULL,
    user_name character varying(255) NOT NULL,
    surname1 character varying(255) NOT NULL,
    surname2 character varying(255),
    id_document character varying(255) NOT NULL,
    country_id integer NOT NULL,
    phone_number character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    user_password character varying(255) NOT NULL,
    shift_id integer,
    hotel_id integer
);


--
-- TOC entry 216 (class 1259 OID 230450)
-- Name: users_days_off; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_days_off (
    id integer NOT NULL,
    login_name character varying(255) NOT NULL,
    day character varying(9) NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 230448)
-- Name: users_days_off_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_days_off_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3067 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_days_off_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_days_off_id_seq OWNED BY public.users_days_off.id;


--
-- TOC entry 2852 (class 2604 OID 220658)
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- TOC entry 2851 (class 2604 OID 220635)
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- TOC entry 2860 (class 2604 OID 263580)
-- Name: employees_entry_departure id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees_entry_departure ALTER COLUMN id SET DEFAULT nextval('public.employees_entry_departure_id_seq'::regclass);


--
-- TOC entry 2849 (class 2604 OID 220611)
-- Name: hotels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels ALTER COLUMN id SET DEFAULT nextval('public.hotels_id_seq'::regclass);


--
-- TOC entry 2853 (class 2604 OID 220678)
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 2856 (class 2604 OID 220698)
-- Name: roles_server_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_server_permissions ALTER COLUMN id SET DEFAULT nextval('public.roles_server_permissions_id_seq'::regclass);


--
-- TOC entry 2857 (class 2604 OID 220716)
-- Name: roles_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_users ALTER COLUMN id SET DEFAULT nextval('public.roles_users_id_seq'::regclass);


--
-- TOC entry 2850 (class 2604 OID 220619)
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- TOC entry 2855 (class 2604 OID 220690)
-- Name: server_permissions server_permission_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.server_permissions ALTER COLUMN server_permission_id SET DEFAULT nextval('public.server_permissions_id_seq'::regclass);


--
-- TOC entry 2858 (class 2604 OID 230440)
-- Name: shifts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);


--
-- TOC entry 2859 (class 2604 OID 230453)
-- Name: users_days_off id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_days_off ALTER COLUMN id SET DEFAULT nextval('public.users_days_off_id_seq'::regclass);


--
-- TOC entry 3035 (class 0 OID 220655)
-- Dependencies: 204
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.bookings VALUES (6, 3, '2023-09-14', '2023-09-20', 'jorge_fernandez');
INSERT INTO public.bookings VALUES (7, 3, '2023-10-14', '2023-10-20', 'jorge_fernandez');


--
-- TOC entry 3032 (class 0 OID 220632)
-- Dependencies: 201
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.countries VALUES (1, 'Spain');


--
-- TOC entry 3049 (class 0 OID 263577)
-- Dependencies: 218
-- Data for Name: employees_entry_departure; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.employees_entry_departure VALUES (14, 'manager', '2023-07-21', '09:49:07', NULL);
INSERT INTO public.employees_entry_departure VALUES (15, 'CopenAna', '2023-07-21', '09:57:24', NULL);
INSERT INTO public.employees_entry_departure VALUES (16, 'alba_torres', '2023-07-24', '13:00:14', '13:21:28');
INSERT INTO public.employees_entry_departure VALUES (17, 'alba_torres', '2023-07-25', '10:44:18', '10:47:48');
INSERT INTO public.employees_entry_departure VALUES (21, 'antonio_gude', '2023-07-26', '10:30:09', NULL);
INSERT INTO public.employees_entry_departure VALUES (20, 'alba_torres', '2023-07-26', '10:27:14', '10:32:06');


--
-- TOC entry 3028 (class 0 OID 220608)
-- Dependencies: 197
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.hotels VALUES (5, 'Grand Palace Hotel', 15);
INSERT INTO public.hotels VALUES (6, 'Sunset View Resort', 8);
INSERT INTO public.hotels VALUES (7, 'Ocean Breeze Inn', 10);
INSERT INTO public.hotels VALUES (8, 'Mountain Retreat Lodge', 5);
INSERT INTO public.hotels VALUES (9, 'City Lights Tower', 20);
INSERT INTO public.hotels VALUES (10, 'Island Paradise Resort', 12);
INSERT INTO public.hotels VALUES (11, 'Serenity Spa & Hotel', 6);
INSERT INTO public.hotels VALUES (12, 'Riverside Lodge', 3);
INSERT INTO public.hotels VALUES (13, 'Golden Sands Resort', 18);
INSERT INTO public.hotels VALUES (14, 'Forest Haven Retreat', 7);


--
-- TOC entry 3037 (class 0 OID 220675)
-- Dependencies: 206
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.roles VALUES (1, 'root', '<?xml version="1.0" encoding="UTF-8"?><security></security>');
INSERT INTO public.roles VALUES (2, 'admin', '<?xml version="1.0" encoding="UTF-8"?><security></security>');
INSERT INTO public.roles VALUES (3, 'manager', '<?xml version="1.0" encoding="UTF-8"?><security></security>');
INSERT INTO public.roles VALUES (4, 'client', '<?xml version="1.0" encoding="UTF-8"?><security></security>');
INSERT INTO public.roles VALUES (6, 'employee', '<?xml version="1.0" encoding="UTF-8"?><security></security>');
INSERT INTO public.roles VALUES (7, 'receptionist', '<?xml version="1.0" encoding="UTF-8"?><security></security>');
INSERT INTO public.roles VALUES (8, 'waiter', '<?xml version="1.0" encoding="UTF-8"?><security></security>');
INSERT INTO public.roles VALUES (9, 'cook', '<?xml version="1.0" encoding="UTF-8"?><security></security>');


--
-- TOC entry 3041 (class 0 OID 220695)
-- Dependencies: 210
-- Data for Name: roles_server_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.roles_server_permissions VALUES (1, 3, 1);
INSERT INTO public.roles_server_permissions VALUES (2, 3, 2);
INSERT INTO public.roles_server_permissions VALUES (3, 3, 3);
INSERT INTO public.roles_server_permissions VALUES (4, 3, 4);
INSERT INTO public.roles_server_permissions VALUES (5, 3, 18);
INSERT INTO public.roles_server_permissions VALUES (6, 3, 5);
INSERT INTO public.roles_server_permissions VALUES (7, 3, 6);
INSERT INTO public.roles_server_permissions VALUES (8, 3, 7);
INSERT INTO public.roles_server_permissions VALUES (11, 3, 13);
INSERT INTO public.roles_server_permissions VALUES (12, 3, 10);
INSERT INTO public.roles_server_permissions VALUES (13, 3, 20);
INSERT INTO public.roles_server_permissions VALUES (14, 3, 21);
INSERT INTO public.roles_server_permissions VALUES (15, 3, 22);
INSERT INTO public.roles_server_permissions VALUES (16, 3, 23);
INSERT INTO public.roles_server_permissions VALUES (17, 3, 24);
INSERT INTO public.roles_server_permissions VALUES (18, 3, 25);
INSERT INTO public.roles_server_permissions VALUES (19, 3, 26);
INSERT INTO public.roles_server_permissions VALUES (20, 6, 27);
INSERT INTO public.roles_server_permissions VALUES (21, 6, 28);
INSERT INTO public.roles_server_permissions VALUES (22, 3, 29);
INSERT INTO public.roles_server_permissions VALUES (23, 4, 13);
INSERT INTO public.roles_server_permissions VALUES (24, 4, 15);
INSERT INTO public.roles_server_permissions VALUES (25, 4, 6);
INSERT INTO public.roles_server_permissions VALUES (26, 4, 14);
INSERT INTO public.roles_server_permissions VALUES (27, 4, 16);
INSERT INTO public.roles_server_permissions VALUES (29, 3, 11);
INSERT INTO public.roles_server_permissions VALUES (30, 3, 12);


--
-- TOC entry 3043 (class 0 OID 220713)
-- Dependencies: 212
-- Data for Name: roles_users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.roles_users VALUES (80, 'PruebaPresentacion', 4);
INSERT INTO public.roles_users VALUES (84, 'manager', 6);
INSERT INTO public.roles_users VALUES (85, 'manager', 3);
INSERT INTO public.roles_users VALUES (86, 'jcook', 6);
INSERT INTO public.roles_users VALUES (87, 'jcook', 9);
INSERT INTO public.roles_users VALUES (88, 'CopenAna', 6);
INSERT INTO public.roles_users VALUES (89, 'CopenAna', 7);
INSERT INTO public.roles_users VALUES (90, 'FranRego', 4);
INSERT INTO public.roles_users VALUES (91, 'FranPego', 4);
INSERT INTO public.roles_users VALUES (92, 'VanesaRego', 4);
INSERT INTO public.roles_users VALUES (93, 'vannyHappy', 6);
INSERT INTO public.roles_users VALUES (94, 'vannyHappy', 7);
INSERT INTO public.roles_users VALUES (95, 'maria_gomez', 4);
INSERT INTO public.roles_users VALUES (97, 'pedro_romero', 4);
INSERT INTO public.roles_users VALUES (98, 'alba_torres', 6);
INSERT INTO public.roles_users VALUES (99, 'alba_torres', 3);
INSERT INTO public.roles_users VALUES (115, 'antonio_gude', 6);
INSERT INTO public.roles_users VALUES (116, 'antonio_gude', 7);
INSERT INTO public.roles_users VALUES (117, 'jorge_romero', 4);


--
-- TOC entry 3030 (class 0 OID 220616)
-- Dependencies: 199
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.rooms VALUES (2, 413, 5, 4, 150);
INSERT INTO public.rooms VALUES (3, 421, 5, 2, 100);
INSERT INTO public.rooms VALUES (4, 678, 6, 4, 80);
INSERT INTO public.rooms VALUES (5, 698, 6, 3, 90);
INSERT INTO public.rooms VALUES (6, 398, 7, 2, 125);
INSERT INTO public.rooms VALUES (7, 134, 8, 2, 95);
INSERT INTO public.rooms VALUES (8, 145, 10, 1, 75);
INSERT INTO public.rooms VALUES (9, 125, 5, 4, 122);
INSERT INTO public.rooms VALUES (10, 168, 6, 4, 110);
INSERT INTO public.rooms VALUES (11, 179, 5, 4, 100);
INSERT INTO public.rooms VALUES (15, 314, 5, 3, 100);


--
-- TOC entry 3039 (class 0 OID 220687)
-- Dependencies: 208
-- Data for Name: server_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.server_permissions VALUES (4, 'com.ontimize.hr.api.core.service.IHotelService/hotelDelete');
INSERT INTO public.server_permissions VALUES (2, 'com.ontimize.hr.api.core.service.IHotelService/hotelQuery');
INSERT INTO public.server_permissions VALUES (1, 'com.ontimize.hr.api.core.service.IHotelService/hotelInsert');
INSERT INTO public.server_permissions VALUES (5, 'com.ontimize.hr.api.core.service.IUserService/userUpdate');
INSERT INTO public.server_permissions VALUES (6, 'com.ontimize.hr.api.core.service.IUserService/userQuery');
INSERT INTO public.server_permissions VALUES (7, 'com.ontimize.hr.api.core.service.IUserService/userDelete');
INSERT INTO public.server_permissions VALUES (10, 'com.ontimize.hr.api.core.service.IRoomService/roomInsert');
INSERT INTO public.server_permissions VALUES (11, 'com.ontimize.hr.api.core.service.IRoomService/roomUpdate');
INSERT INTO public.server_permissions VALUES (12, 'com.ontimize.hr.api.core.service.IRoomService/roomDelete');
INSERT INTO public.server_permissions VALUES (13, 'com.ontimize.hr.api.core.service.IBookingService/bookingInsert');
INSERT INTO public.server_permissions VALUES (14, 'com.ontimize.hr.api.core.service.IBookingService/bookingUpdate');
INSERT INTO public.server_permissions VALUES (15, 'com.ontimize.hr.api.core.service.IBookingService/bookingQuery');
INSERT INTO public.server_permissions VALUES (16, 'com.ontimize.hr.api.core.service.IBookingService/bookingDelete');
INSERT INTO public.server_permissions VALUES (3, 'com.ontimize.hr.api.core.service.IHotelService/hotelUpdate');
INSERT INTO public.server_permissions VALUES (19, 'com.ontimize.hr.api.core.service.IUserService/userInsert');
INSERT INTO public.server_permissions VALUES (21, 'com.ontimize.hr.api.core.service.IEmployeeService/employeeUpdate');
INSERT INTO public.server_permissions VALUES (18, 'com.ontimize.hr.api.core.service.IEmployeeService/employeeInsert');
INSERT INTO public.server_permissions VALUES (20, 'com.ontimize.hr.api.core.service.IEmployeeService/employeeDelete');
INSERT INTO public.server_permissions VALUES (22, 'com.ontimize.hr.api.core.service.IEmployeeService/employeeQuery');
INSERT INTO public.server_permissions VALUES (23, 'com.ontimize.hr.api.core.service.IShiftService/shiftInsert');
INSERT INTO public.server_permissions VALUES (24, 'com.ontimize.hr.api.core.service.IShiftService/shiftUpdate');
INSERT INTO public.server_permissions VALUES (25, 'com.ontimize.hr.api.core.service.IShiftService/shiftQuery');
INSERT INTO public.server_permissions VALUES (26, 'com.ontimize.hr.api.core.service.IShiftService/shiftDelete');
INSERT INTO public.server_permissions VALUES (27, 'com.ontimize.hr.api.core.service.IEmployeeService/clockInInsert');
INSERT INTO public.server_permissions VALUES (28, 'com.ontimize.hr.api.core.service.IEmployeeService/clockOutUpdate');
INSERT INTO public.server_permissions VALUES (29, 'com.ontimize.hr.api.core.service.IEmployeeService/employeesPerShiftQuery');


--
-- TOC entry 3045 (class 0 OID 230437)
-- Dependencies: 214
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.shifts VALUES (33, 7, '09:00-15:00', '09:00-15:00', '09:00-15:00', '09:00-15:00', '14:00-15:00', '14:00-15:00', NULL, 5);
INSERT INTO public.shifts VALUES (35, 7, NULL, NULL, '10:00-19:00', '10:00-19:00', NULL, NULL, NULL, 5);


--
-- TOC entry 3033 (class 0 OID 220638)
-- Dependencies: 202
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES ('PruebaPresentacion', 'Juan', 'Perez', NULL, '66955662V', 1, '666666666', 'pruebaPresentacion@micorreo.com', 'Juana1234', NULL, NULL);
INSERT INTO public.users VALUES ('manager', 'Alberto', 'Martinez', NULL, '66955662V', 1, '666888555', 'manager@marinehotels.com', 'Manager1234', NULL, 2);
INSERT INTO public.users VALUES ('jcook', 'Juan', 'Cook', NULL, '66955662V', 1, '666666666', 'jcook@example.org', 'Abc1234.', NULL, NULL);
INSERT INTO public.users VALUES ('admin', 'admin', '', NULL, '73297774V', 1, '666555444', 'admin@example.org', 'Abc1234.', NULL, NULL);
INSERT INTO public.users VALUES ('maria_gomez', 'María', 'Gómez', 'Sánchez', '25333197P', 1, '987654321', 'maria.gomez@example.com', 'SecurePass1', NULL, NULL);
INSERT INTO public.users VALUES ('carlos_lopez', 'Carlos', 'López', 'Martínez', '29604935W', 1, '654321987', 'carlos.lopez@example.com', 'StrongPass2', NULL, NULL);
INSERT INTO public.users VALUES ('ana_martin', 'Ana', 'Martín', 'Hernández', 'X7685720V', 1, '789654123', 'ana.martin@example.com', 'SafePass3', NULL, NULL);
INSERT INTO public.users VALUES ('david_ruiz', 'David', 'Ruiz', 'González', 'Y3423862G', 1, '123987456', 'david.ruiz@example.com', 'Protected4', NULL, NULL);
INSERT INTO public.users VALUES ('isabel_fernandez', 'Isabel', 'Fernández', 'Rodríguez', '66275968L', 1, '456123789', 'isabel.fernandez@example.com', 'Secure123', NULL, NULL);
INSERT INTO public.users VALUES ('sergio_gonzalez', 'Sergio', 'González', 'Gómez', 'X2674289X', 1, '789456123', 'sergio.gonzalez@example.com', 'StrongPass2023', NULL, NULL);
INSERT INTO public.users VALUES ('laura_perez', 'Laura', 'Pérez', 'Ramírez', '42622452W', 1, '321987654', 'laura.perez@example.com', 'ProtectedPass', NULL, NULL);
INSERT INTO public.users VALUES ('javier_rodriguez', 'Javier', 'Rodríguez', 'García', '37883335N', 1, '654789321', 'javier.rodriguez@example.com', 'SafePassword', NULL, NULL);
INSERT INTO public.users VALUES ('nuria_martinez', 'Nuria', 'Martínez', 'López', '15254033L', 1, '789321654', 'nuria.martinez@example.com', 'Strong1234', NULL, NULL);
INSERT INTO public.users VALUES ('victor_sanchez', 'Víctor', 'Sánchez', 'Fernández', '94399622D', 1, '987321654', 'victor.sanchez@example.com', 'Protected2023', NULL, NULL);
INSERT INTO public.users VALUES ('FranRego', 'Fran', 'Rego', NULL, '66955662V', 1, '666666666', 'franrego@micorreo.com', 'Abcd1234', NULL, NULL);
INSERT INTO public.users VALUES ('FranPego', 'Fran', 'Rego', NULL, '66955662V', 1, '666666666', 'franpego@micorreo.com', 'Abcd1234', NULL, NULL);
INSERT INTO public.users VALUES ('VanesaRego', 'Vanesa', 'Rego', NULL, '66955662V', 1, '666666666', 'vanesarego@micorreo.com', 'Abcd1234', NULL, NULL);
INSERT INTO public.users VALUES ('jorge_fernandez', 'Jorge', 'Fernández', NULL, '66955662V', 1, '666666666', 'juan.fernandez@example.com', 'Jorge123', NULL, NULL);
INSERT INTO public.users VALUES ('pedro_romero', 'Pedro', 'Romero', NULL, '66955662V', 1, '666666666', 'pedro.romero@example.com', 'Pedro123', NULL, NULL);
INSERT INTO public.users VALUES ('alba_torres', 'Alba', 'Torres', NULL, '32897962G', 1, '615269471', 'albatorres@example.org', 'Abc1234.', NULL, 5);
INSERT INTO public.users VALUES ('vannyHappy', 'Vanesa', 'Rego', NULL, '66955662V', 1, '666888666', 'vannyhappy@example.org', 'Abc1234.', NULL, NULL);
INSERT INTO public.users VALUES ('CopenAna', 'Ana', 'copena', NULL, '35581834Y', 1, '666666666', 'anacopena@example.org', 'Hola12345', 33, 5);
INSERT INTO public.users VALUES ('antonio_gude', 'Antonio', 'Gude', NULL, '26907766C', 1, '627592780', 'antonio_gude@example.org', 'Abc1234.', 35, 5);
INSERT INTO public.users VALUES ('jorge_romero', 'Jorge', 'Romero', NULL, '66955662V', 1, '666666666', 'jorge.romero@example.com', 'Jorge123', NULL, NULL);


--
-- TOC entry 3047 (class 0 OID 230450)
-- Dependencies: 216
-- Data for Name: users_days_off; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users_days_off VALUES (63, 'jcook', 'sunday');
INSERT INTO public.users_days_off VALUES (64, 'jcook', 'saturday');
INSERT INTO public.users_days_off VALUES (65, 'CopenAna', 'monday');
INSERT INTO public.users_days_off VALUES (67, 'vannyHappy', 'tuesday');
INSERT INTO public.users_days_off VALUES (71, 'antonio_gude', 'sunday');


--
-- TOC entry 3068 (class 0 OID 0)
-- Dependencies: 203
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bookings_id_seq', 17, true);


--
-- TOC entry 3069 (class 0 OID 0)
-- Dependencies: 200
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.countries_id_seq', 1, true);


--
-- TOC entry 3070 (class 0 OID 0)
-- Dependencies: 217
-- Name: employees_entry_departure_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employees_entry_departure_id_seq', 21, true);


--
-- TOC entry 3071 (class 0 OID 0)
-- Dependencies: 196
-- Name: hotels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.hotels_id_seq', 14, true);


--
-- TOC entry 3072 (class 0 OID 0)
-- Dependencies: 205
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_id_seq', 9, true);


--
-- TOC entry 3073 (class 0 OID 0)
-- Dependencies: 209
-- Name: roles_server_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_server_permissions_id_seq', 30, true);


--
-- TOC entry 3074 (class 0 OID 0)
-- Dependencies: 211
-- Name: roles_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_users_id_seq', 117, true);


--
-- TOC entry 3075 (class 0 OID 0)
-- Dependencies: 198
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rooms_id_seq', 15, true);


--
-- TOC entry 3076 (class 0 OID 0)
-- Dependencies: 207
-- Name: server_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.server_permissions_id_seq', 29, true);


--
-- TOC entry 3077 (class 0 OID 0)
-- Dependencies: 213
-- Name: shifts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shifts_id_seq', 35, true);


--
-- TOC entry 3078 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_days_off_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_days_off_id_seq', 71, true);


--
-- TOC entry 2874 (class 2606 OID 220660)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- TOC entry 2868 (class 2606 OID 220637)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- TOC entry 2890 (class 2606 OID 263585)
-- Name: employees_entry_departure employees_entry_departure_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees_entry_departure
    ADD CONSTRAINT employees_entry_departure_pkey PRIMARY KEY (id);


--
-- TOC entry 2862 (class 2606 OID 220613)
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- TOC entry 2876 (class 2606 OID 220684)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 2880 (class 2606 OID 220700)
-- Name: roles_server_permissions roles_server_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_server_permissions
    ADD CONSTRAINT roles_server_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2882 (class 2606 OID 220718)
-- Name: roles_users roles_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_users
    ADD CONSTRAINT roles_users_pkey PRIMARY KEY (id);


--
-- TOC entry 2864 (class 2606 OID 220624)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 2878 (class 2606 OID 220692)
-- Name: server_permissions server_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.server_permissions
    ADD CONSTRAINT server_permissions_pkey PRIMARY KEY (server_permission_id);


--
-- TOC entry 2884 (class 2606 OID 230442)
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- TOC entry 2892 (class 2606 OID 263634)
-- Name: employees_entry_departure u_employee_work_day; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees_entry_departure
    ADD CONSTRAINT u_employee_work_day UNIQUE (login_name, working_day);


--
-- TOC entry 2866 (class 2606 OID 220672)
-- Name: rooms u_hotel_id_room_number; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT u_hotel_id_room_number UNIQUE (hotel_id, room_number);


--
-- TOC entry 2886 (class 2606 OID 262638)
-- Name: users_days_off u_login_name_day; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_days_off
    ADD CONSTRAINT u_login_name_day UNIQUE (login_name, day);


--
-- TOC entry 2888 (class 2606 OID 230455)
-- Name: users_days_off users_days_off_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_days_off
    ADD CONSTRAINT users_days_off_pkey PRIMARY KEY (id);


--
-- TOC entry 2870 (class 2606 OID 220647)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 2872 (class 2606 OID 220645)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (login_name);


--
-- TOC entry 2897 (class 2606 OID 220666)
-- Name: bookings bookings_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2896 (class 2606 OID 220661)
-- Name: bookings bookings_user_login_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_login_name_fkey FOREIGN KEY (user_login_name) REFERENCES public.users(login_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2905 (class 2606 OID 263586)
-- Name: employees_entry_departure employees_entry_departure_login_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees_entry_departure
    ADD CONSTRAINT employees_entry_departure_login_name_fkey FOREIGN KEY (login_name) REFERENCES public.users(login_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2903 (class 2606 OID 263731)
-- Name: shifts fk_hotel; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT fk_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2904 (class 2606 OID 262655)
-- Name: users_days_off fk_login_name_days_off; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_days_off
    ADD CONSTRAINT fk_login_name_days_off FOREIGN KEY (login_name) REFERENCES public.users(login_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2895 (class 2606 OID 261105)
-- Name: users fk_shift_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_shift_id FOREIGN KEY (shift_id) REFERENCES public.shifts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2898 (class 2606 OID 220701)
-- Name: roles_server_permissions roles_server_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_server_permissions
    ADD CONSTRAINT roles_server_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2899 (class 2606 OID 220706)
-- Name: roles_server_permissions roles_server_permissions_server_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_server_permissions
    ADD CONSTRAINT roles_server_permissions_server_permission_id_fkey FOREIGN KEY (server_permission_id) REFERENCES public.server_permissions(server_permission_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2901 (class 2606 OID 220724)
-- Name: roles_users roles_users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_users
    ADD CONSTRAINT roles_users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2900 (class 2606 OID 220719)
-- Name: roles_users roles_users_user_login_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles_users
    ADD CONSTRAINT roles_users_user_login_name_fkey FOREIGN KEY (login_name) REFERENCES public.users(login_name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2893 (class 2606 OID 220625)
-- Name: rooms rooms_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2902 (class 2606 OID 230443)
-- Name: shifts shifts_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2894 (class 2606 OID 220648)
-- Name: users users_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2023-07-27 08:05:35

--
-- PostgreSQL database dump complete
--

