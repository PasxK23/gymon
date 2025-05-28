--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Debian 16.9-1.pgdg120+1)
-- Dumped by pg_dump version 17.0

-- Started on 2025-05-28 19:07:51

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
-- TOC entry 3435 (class 1262 OID 16389)
-- Name: gymon_db; Type: DATABASE; Schema: -; Owner: gymon_db_user
--

CREATE DATABASE gymon_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF8';


ALTER DATABASE gymon_db OWNER TO gymon_db_user;

\connect gymon_db

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
-- TOC entry 3436 (class 0 OID 0)
-- Name: gymon_db; Type: DATABASE PROPERTIES; Schema: -; Owner: gymon_db_user
--

ALTER DATABASE gymon_db SET "TimeZone" TO 'utc';


\connect gymon_db

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: gymon_db_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO gymon_db_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16407)
-- Name: CATEGORY; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."CATEGORY" (
    "DURATION" integer NOT NULL
);


ALTER TABLE public."CATEGORY" OWNER TO gymon_db_user;

--
-- TOC entry 215 (class 1259 OID 16398)
-- Name: GYM; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."GYM" (
    "Location" text NOT NULL,
    "Address" character varying NOT NULL,
    "Phone" character varying NOT NULL,
    "Email" character varying NOT NULL,
    "Schedule" character varying NOT NULL
);


ALTER TABLE public."GYM" OWNER TO gymon_db_user;

--
-- TOC entry 221 (class 1259 OID 16548)
-- Name: GYM_PROVIDES_PROGRAM_SESSION; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."GYM_PROVIDES_PROGRAM_SESSION" (
    "PROGRAM_Name" character varying NOT NULL,
    "GYM_Location" text NOT NULL,
    "SESSION_ID" integer NOT NULL
);


ALTER TABLE public."GYM_PROVIDES_PROGRAM_SESSION" OWNER TO gymon_db_user;

--
-- TOC entry 217 (class 1259 OID 16472)
-- Name: PROGRAM; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."PROGRAM" (
    "Name" character varying NOT NULL,
    "Description" text,
    "Price_ana_Session" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."PROGRAM" OWNER TO gymon_db_user;

--
-- TOC entry 220 (class 1259 OID 16542)
-- Name: SESSION; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."SESSION" (
    "ID" integer NOT NULL,
    "Max_Number_Of_People" integer DEFAULT 0 NOT NULL,
    "Date" date NOT NULL,
    "Time" time without time zone NOT NULL
);


ALTER TABLE public."SESSION" OWNER TO gymon_db_user;

--
-- TOC entry 225 (class 1259 OID 16604)
-- Name: SESSION_ID_seq; Type: SEQUENCE; Schema: public; Owner: gymon_db_user
--

ALTER TABLE public."SESSION" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."SESSION_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 16497)
-- Name: SUBSCRIPTION; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."SUBSCRIPTION" (
    "Description" text,
    "Price" integer DEFAULT 0 NOT NULL,
    "ID" integer NOT NULL,
    "CATEGORY_Duration" integer NOT NULL,
    "gym_Location" text NOT NULL
);


ALTER TABLE public."SUBSCRIPTION" OWNER TO gymon_db_user;

--
-- TOC entry 219 (class 1259 OID 16515)
-- Name: USER; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."USER" (
    "Name" character varying NOT NULL,
    "ID" integer NOT NULL,
    "Email" character varying NOT NULL,
    "Password" character varying NOT NULL,
    "Phone" character varying NOT NULL,
    "Location" character varying NOT NULL,
    "Surname" character varying NOT NULL,
    CONSTRAINT "PASS_CHECK" CHECK ((length(("Password")::text) >= 5))
);


ALTER TABLE public."USER" OWNER TO gymon_db_user;

--
-- TOC entry 224 (class 1259 OID 16603)
-- Name: USER_ID_seq; Type: SEQUENCE; Schema: public; Owner: gymon_db_user
--

ALTER TABLE public."USER" ALTER COLUMN "ID" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."USER_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16570)
-- Name: USER_RESERVES_SESSION; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."USER_RESERVES_SESSION" (
    "USER-ID" integer NOT NULL,
    "SESSION-ID" integer NOT NULL
);


ALTER TABLE public."USER_RESERVES_SESSION" OWNER TO gymon_db_user;

--
-- TOC entry 223 (class 1259 OID 16585)
-- Name: USER_SUBSCRIPTION; Type: TABLE; Schema: public; Owner: gymon_db_user
--

CREATE TABLE public."USER_SUBSCRIPTION" (
    "USER-ID" integer NOT NULL,
    "SUBSCRIPTION-ID" integer NOT NULL,
    "Start_Date" date NOT NULL,
    "End_Date" date NOT NULL,
    "gym_Location" text NOT NULL,
    CONSTRAINT "DATE_CHECK" CHECK (("Start_Date" < "End_Date"))
);


ALTER TABLE public."USER_SUBSCRIPTION" OWNER TO gymon_db_user;

--
-- TOC entry 3420 (class 0 OID 16407)
-- Dependencies: 216
-- Data for Name: CATEGORY; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."CATEGORY" VALUES (1);
INSERT INTO public."CATEGORY" VALUES (3);
INSERT INTO public."CATEGORY" VALUES (6);
INSERT INTO public."CATEGORY" VALUES (12);


--
-- TOC entry 3419 (class 0 OID 16398)
-- Dependencies: 215
-- Data for Name: GYM; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."GYM" VALUES ('Αθήνα (Μαρούσι)', 'Λεωφόρος Κηφισίας 101', '210-1234567', 'gym_on_marousi@gymon.gr', 'Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή 10:00-17:00');
INSERT INTO public."GYM" VALUES ('Αθήνα (Περιστέρι)', 'Σταδίου 10', '210-1111111', 'gym_on_peristeri@gymon.gr', 'Δευτέρα-Παρασκευή 07:00-22:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Αθήνα (Χαλάνδρι)', 'Ιεραποστόλου 12', '210-2222222', 'gym_on_chalandri@gymon.gr', 'Δευτέρα-Παρασκευή 07:00-22:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Θεσσαλονίκη (Κέντρο)', 'Τσιμισκή 22', '2310-123456', 'gym_on_thess_cender@gymon.gr', 'Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Πάτρα', 'Κορίνθου 50', '2610-000000', 'gym_on_patra@gymon.gr', 'Δευτέρα-Παρασκευή 09:00-20:00, Σάββατο 10:00-14:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Ηράκλειο', 'Λεωφόρος Κνωσού 33', '2810-123456', 'gym_on_irakleio@gymon.gr', 'Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 09:00-15:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Λάρισα', 'Αχιλλέως 90', '2410-123456', 'gym_on_larisa@gymon.gr', 'Δευτέρα-Παρασκευή 09:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Χανιά', 'Τζανακάκη 14', '28210-123456', 'gym_on_chania@gymon.gr', 'Δευτέρα-Παρασκευή 08:00-21:00, Σάββατο 10:00-16:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Θεσσαλονίκη (Τούμπα)', 'Λεωφόρος Γεωργικής Σχολής 45', '2310-987654', 'gym_on_thess_toumpa@gymon.gr', 'Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή Κλειστά');
INSERT INTO public."GYM" VALUES ('Αθήνα (Γλυφάδα)', 'Λεωφόρος Βουλιαγμένης 100', '210-3333333', 'gym_on_glyfada@gymon.gr', 'Δευτέρα-Παρασκευή 08:00-22:00, Σάββατο 09:00-17:00, Κυριακή Κλειστά');


--
-- TOC entry 3425 (class 0 OID 16548)
-- Dependencies: 221
-- Data for Name: GYM_PROVIDES_PROGRAM_SESSION; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Χαλάνδρι)', 1);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Μαρούσι)', 2);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Λάρισα', 3);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Αθήνα (Περιστέρι)', 4);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Αθήνα (Γλυφάδα)', 5);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Μαρούσι)', 6);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Αθήνα (Γλυφάδα)', 7);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Μαρούσι)', 8);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Χανιά', 9);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Πάτρα', 10);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Λάρισα', 11);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Περιστέρι)', 12);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Περιστέρι)', 13);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Ηράκλειο', 14);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Χανιά', 15);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Χανιά', 16);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Μαρούσι)', 17);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Θεσσαλονίκη (Τούμπα)', 18);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Αθήνα (Γλυφάδα)', 19);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Θεσσαλονίκη (Τούμπα)', 20);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Ηράκλειο', 21);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Αθήνα (Χαλάνδρι)', 22);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Λάρισα', 23);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Περιστέρι)', 24);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Χανιά', 25);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Χανιά', 26);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Γλυφάδα)', 27);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Θεσσαλονίκη (Τούμπα)', 28);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Θεσσαλονίκη (Τούμπα)', 29);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Χανιά', 30);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Πάτρα', 31);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit', 'Αθήνα (Χαλάνδρι)', 32);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Χαλάνδρι)', 33);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Περιστέρι)', 34);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Αθήνα (Χαλάνδρι)', 35);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit', 'Αθήνα (Περιστέρι)', 36);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit', 'Ηράκλειο', 37);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Θεσσαλονίκη (Τούμπα)', 38);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Αθήνα (Γλυφάδα)', 39);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Περιστέρι)', 40);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Γλυφάδα)', 41);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Θεσσαλονίκη (Τούμπα)', 42);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Χανιά', 43);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Πάτρα', 44);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit', 'Θεσσαλονίκη (Κέντρο)', 45);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Γλυφάδα)', 46);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Χαλάνδρι)', 47);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Χανιά', 48);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Χαλάνδρι)', 49);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Αθήνα (Περιστέρι)', 50);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Θεσσαλονίκη (Κέντρο)', 51);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Αθήνα (Γλυφάδα)', 52);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Λάρισα', 53);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Χαλάνδρι)', 54);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Πάτρα', 55);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Αθήνα (Χαλάνδρι)', 56);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Θεσσαλονίκη (Τούμπα)', 57);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Θεσσαλονίκη (Τούμπα)', 58);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Θεσσαλονίκη (Κέντρο)', 59);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Ηράκλειο', 60);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Ηράκλειο', 61);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Χαλάνδρι)', 62);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Πάτρα', 63);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Περιστέρι)', 64);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Χανιά', 65);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Αθήνα (Μαρούσι)', 66);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Γλυφάδα)', 67);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Χαλάνδρι)', 68);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Γλυφάδα)', 69);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Θεσσαλονίκη (Τούμπα)', 70);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Χανιά', 71);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Αθήνα (Χαλάνδρι)', 72);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Χανιά', 73);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Ηράκλειο', 74);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Spinning', 'Αθήνα (Περιστέρι)', 75);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Χανιά', 76);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Πάτρα', 77);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Θεσσαλονίκη (Κέντρο)', 78);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Χανιά', 79);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Pilates', 'Αθήνα (Γλυφάδα)', 80);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Kickboxing', 'Θεσσαλονίκη (Τούμπα)', 81);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit', 'Αθήνα (Γλυφάδα)', 82);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Yoga', 'Λάρισα', 83);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Zumba', 'Αθήνα (Χαλάνδρι)', 84);
INSERT INTO public."GYM_PROVIDES_PROGRAM_SESSION" VALUES ('Crossfit', 'Ηράκλειο', 85);


--
-- TOC entry 3421 (class 0 OID 16472)
-- Dependencies: 217
-- Data for Name: PROGRAM; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."PROGRAM" VALUES ('Yoga', 'Μια χαλαρωτική και αναζωογονητική πρακτική που συνδυάζει διατάσεις, ενδυνάμωση, αναπνοές και διαλογισμό. Περιλαμβάνει στάσεις (asanas) που βοηθούν στην ευλυγισία, την ισορροπία και τη μυϊκή σταθερότητα.

Οφέλη για την υγεία:
– Μειώνει το άγχος και ενισχύει τη νοητική διαύγεια
– Βελτιώνει τη στάση σώματος και την κινητικότητα των αρθρώσεων
– Ρυθμίζει την αναπνοή και μειώνει την αρτηριακή πίεση
– Συμβάλλει στη συναισθηματική ισορροπία', 10);
INSERT INTO public."PROGRAM" VALUES ('Spinning', 'Ένα δυναμικό πρόγραμμα ποδηλασίας σε στατικό ποδήλατο, με εναλλαγές έντασης και ρυθμού υπό μουσική. Ιδανικό για την τόνωση της καρδιάς και των ποδιών.

Οφέλη για την υγεία:
– Ενισχύει την καρδιοαναπνευστική ικανότητα
– Καίει πολλές θερμίδες και βοηθά στην απώλεια βάρους
– Τονώνει τα πόδια, τους γλουτούς και τον κορμό
– Μειώνει τον κίνδυνο καρδιοπαθειών', 12);
INSERT INTO public."PROGRAM" VALUES ('Kickboxing', 'Ένα έντονο πρόγραμμα αυτοάμυνας και γυμναστικής που συνδυάζει κινήσεις από πολεμικές τέχνες και αερόβια άσκηση.

Οφέλη για την υγεία:
– Ενισχύει τη δύναμη, την ταχύτητα και την ευλυγισία
– Αυξάνει την αυτοπεποίθηση και μειώνει το στρες
– Βοηθά στην απώλεια βάρους μέσω έντονης καύσης θερμίδων
– Βελτιώνει την ισορροπία και τον συντονισμό σώματος-νου', 15);
INSERT INTO public."PROGRAM" VALUES ('Zumba', 'Ένα διασκεδαστικό πρόγραμμα χορού με έντονη μουσική λάτιν και διεθνή ρυθμούς. Ιδανικό για άτομα που αγαπούν την κίνηση και τη διασκέδαση ενώ γυμνάζονται.

Οφέλη για την υγεία:
– Ενισχύει το καρδιοαναπνευστικό σύστημα
– Βοηθά στη μείωση του άγχους και αυξάνει τα επίπεδα ενέργειας
– Βελτιώνει την αντοχή, την ισορροπία και την ευλυγισία
– Ενισχύει τη διάθεση μέσω της μουσικοχορευτικής έκφρασης', 12);
INSERT INTO public."PROGRAM" VALUES ('Pilates', 'Πρόγραμμα χαμηλής έντασης που στοχεύει στην ενδυνάμωση του πυρήνα (κοιλιακοί, ράχη, λεκάνη) και στη σταθερότητα. Επικεντρώνεται στον έλεγχο της αναπνοής και της κίνησης.

Οφέλη για την υγεία:
– Δυναμώνει τον κορμό και βελτιώνει τη στάση του σώματος
– Μειώνει τον πόνο στη μέση και τις κακώσεις
– Ενισχύει τη συγκέντρωση και την ισορροπία
– Βελτιώνει την κινητικότητα και τη σωματική ευαισθητοποίηση', 13);
INSERT INTO public."PROGRAM" VALUES ('Crossfit', 'Ένα εντατικό και απαιτητικό πρόγραμμα που συνδυάζει βάρη, καρδιοαναπνευστική άσκηση, άλματα, κωπηλασία και γυμναστική. Κάθε προπόνηση είναι διαφορετική και προσαρμοσμένη.

Οφέλη για την υγεία:
– Αυξάνει τη γενική φυσική κατάσταση και την αντοχή
– Αναπτύσσει δύναμη, ταχύτητα και έκρηξη
– Βοηθά στη διαχείριση του στρες μέσω εντατικής δραστηριότητας
– Δημιουργεί αίσθημα κοινότητας και πειθαρχίας', 20);


--
-- TOC entry 3424 (class 0 OID 16542)
-- Dependencies: 220
-- Data for Name: SESSION; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (1, 10, '2025-05-28', '08:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (2, 5, '2025-05-28', '09:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (3, 7, '2025-05-28', '10:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (4, 12, '2025-05-28', '11:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (5, 5, '2025-05-28', '12:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (6, 15, '2025-05-28', '13:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (7, 12, '2025-05-28', '14:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (8, 10, '2025-05-28', '15:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (9, 13, '2025-05-28', '16:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (10, 13, '2025-05-28', '17:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (11, 8, '2025-05-28', '18:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (12, 10, '2025-05-28', '19:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (13, 5, '2025-05-28', '20:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (14, 6, '2025-05-28', '21:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (15, 14, '2025-05-29', '08:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (16, 15, '2025-05-29', '09:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (17, 9, '2025-05-29', '10:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (18, 6, '2025-05-29', '11:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (19, 9, '2025-05-29', '12:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (20, 15, '2025-05-29', '13:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (21, 11, '2025-05-29', '14:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (22, 10, '2025-05-29', '15:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (23, 11, '2025-05-29', '16:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (24, 7, '2025-05-29', '17:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (25, 12, '2025-05-29', '18:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (26, 5, '2025-05-29', '19:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (27, 11, '2025-05-29', '20:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (28, 12, '2025-05-29', '21:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (29, 14, '2025-05-30', '08:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (30, 6, '2025-05-30', '09:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (31, 5, '2025-05-30', '10:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (32, 8, '2025-05-30', '11:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (33, 15, '2025-05-30', '12:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (34, 15, '2025-05-30', '13:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (35, 14, '2025-05-30', '14:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (36, 8, '2025-05-30', '15:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (37, 12, '2025-05-30', '16:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (38, 15, '2025-05-30', '17:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (39, 8, '2025-05-30', '18:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (40, 14, '2025-05-30', '19:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (41, 8, '2025-05-30', '20:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (42, 9, '2025-05-30', '21:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (43, 7, '2025-05-31', '09:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (44, 14, '2025-05-31', '10:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (45, 13, '2025-05-31', '11:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (46, 6, '2025-05-31', '12:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (47, 6, '2025-05-31', '13:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (48, 5, '2025-05-31', '14:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (49, 15, '2025-06-02', '08:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (50, 15, '2025-06-02', '09:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (51, 8, '2025-06-02', '10:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (52, 11, '2025-06-02', '11:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (53, 5, '2025-06-02', '12:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (54, 13, '2025-06-02', '13:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (55, 10, '2025-06-02', '14:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (56, 8, '2025-06-02', '15:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (57, 11, '2025-06-02', '16:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (58, 8, '2025-06-02', '17:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (59, 10, '2025-06-02', '18:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (60, 6, '2025-06-02', '19:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (61, 5, '2025-06-02', '20:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (62, 6, '2025-06-02', '21:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (63, 10, '2025-06-03', '08:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (64, 5, '2025-06-03', '09:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (65, 9, '2025-06-03', '10:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (66, 10, '2025-06-03', '11:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (68, 9, '2025-06-03', '13:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (70, 11, '2025-06-03', '15:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (71, 13, '2025-06-03', '16:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (72, 8, '2025-06-03', '17:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (67, 0, '2025-06-03', '12:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (69, 2, '2025-06-03', '14:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (73, 13, '2025-06-03', '18:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (74, 12, '2025-06-03', '19:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (75, 13, '2025-06-03', '20:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (76, 5, '2025-06-03', '21:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (77, 9, '2025-06-04', '08:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (78, 8, '2025-06-04', '09:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (79, 7, '2025-06-04', '10:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (80, 10, '2025-06-04', '11:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (81, 10, '2025-06-04', '12:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (82, 7, '2025-06-04', '13:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (83, 14, '2025-06-04', '14:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (84, 13, '2025-06-04', '15:00:00');
INSERT INTO public."SESSION" OVERRIDING SYSTEM VALUE VALUES (85, 8, '2025-06-04', '16:00:00');


--
-- TOC entry 3422 (class 0 OID 16497)
-- Dependencies: 218
-- Data for Name: SUBSCRIPTION; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Αθήνα (Μαρούσι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Αθήνα (Μαρούσι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Αθήνα (Μαρούσι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Αθήνα (Μαρούσι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Αθήνα (Περιστέρι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Αθήνα (Περιστέρι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Αθήνα (Περιστέρι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Αθήνα (Περιστέρι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Θεσσαλονίκη (Κέντρο)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Θεσσαλονίκη (Κέντρο)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Θεσσαλονίκη (Κέντρο)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Θεσσαλονίκη (Κέντρο)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Πάτρα');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Πάτρα');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Πάτρα');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Ηράκλειο');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Ηράκλειο');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Ηράκλειο');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Ηράκλειο');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Λάρισα');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Λάρισα');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Λάρισα');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Χανιά');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Χανιά');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Χανιά');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 50, 1, 1, 'Χανιά');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο', 40, 2, 3, 'Αθήνα (Γλυφάδα)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες, Προσωπικό πρόγραμμα προπόνησης', 30, 4, 12, 'Αθήνα (Γλυφάδα)');
INSERT INTO public."SUBSCRIPTION" VALUES ('Πρόσβαση σε Αποδητήρια και Ντουζ, Χρήση όλων των Μηχανημάτων, Ελεύθερα Βάρη, Πρόσβαση σε κυλικείο, 3 Δωρεάν Συνεδρίες', 35, 3, 6, 'Αθήνα (Γλυφάδα)');


--
-- TOC entry 3423 (class 0 OID 16515)
-- Dependencies: 219
-- Data for Name: USER; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Γιώργος', 1, 'giorgos1@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$p9XD+Ew6cHKcG5mOMbMPpg$Rz4qOPNLVBJ3cDixcfM/fHacp57K85wVCJt+mg908UE', '6900000001', 'Μεζώνος 23', 'Παπαδόπουλος');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Μαρία', 2, 'maria2@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$8Uw7pIdCvulBOtMI+1SOIA$BDWUhlMGhSUInrWKtMjOKwLpN19HI3oY/UgfKX9uAEw', '6900000002', 'Παπαδημητρίου 49', 'Ιωάννου');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Νίκος', 3, 'nikos3@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$/UKXnUAAkaQEqEqDk69g2w$kT+sh3guA0ewo1pP1HU7KLMnTxTW4PnuQh2+iPmi++A', '6900000003', 'Ζαΐμη 50', 'Δημητρίου');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Έλενα', 4, 'elena4@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$KYXPzhVQEk4xbMPU9vXuUw$lyAaNxq8C1OibU88WXwzXC5UyoZhv41woiTfSf+5q+g', '6900000004', 'Μεγάλου Αλεξάνδρου 32', 'Αλεξίου');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Δήμητρα', 5, 'dimitra5@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$9UOPYwOpIUVPDM6CRNH5sQ$XlZvbGMTmHVCmWrHPUUUjygFqxL9iwfkCLk5XDQreHw', '6900000005', 'Ερμού 13', 'Λεωνίδα');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Σταύρος', 6, 'stavros6@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$J3ik4UzSJOfiwNEKMXzCQw$GkLTwL4qoqXpBKLFYtnertIjEUPk7hbISqQwz54RKs4', '6900000006', 'Αμαλίας 11', 'Χατζής');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Αντώνης', 7, 'antonis7@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$9MVb5gQ6t0AbAFhf4c/OAA$AYEnozuOW2AWh+wQgX73i5UlJ2DMLov4Md0rCDh7bl4', '6900000007', 'Πατησίων 90', 'Μακρής');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Σοφία', 8, 'sofia8@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$NqaioxKhI3w1S5KDE6ZRfw$9f+8zyeVo6Ox3GuyfqMVIJwGnUdqZwlgDbyJE7qI+Do', '6900000008', 'Πανεπιστημίου 70', 'Βασιλείου');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Αγγελική', 9, 'aggeliki9@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$1nnD++CBZO8FqNBsTZP3Yw$nghMHbpbSh5pvEPxI7PJNcPasu8SsI88kovDQ5KH4jU', '6900000009', 'Αχαρνών 9', 'Κωσταντίνου');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Κώστας', 10, 'kostas10@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$gTBmpAgU/RzDwrory2SrPw$IlLvjX9mwscs7OKIEtReLdFCnZY0Xpgc0lZYFTjW/Cs', '6900000010', 'Γεροκωστοπούλου 2', 'Παναγιώτου');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Γιάννης', 11, 'giannis11@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$WFFoq1EFUUuyxGi1Y1Kgrw$iQApqzIvJ4Q4K5JOkk1PiW8277OHubedewj5eaMlDBc', '6900000011', 'Αγίας Σοφίας 5', 'Αναγνωστόπουλος');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Αθηνά', 12, 'athanasia12@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$L90hWX527LrZqYIsQkUN6g$JUvHEr8JpwPzh4hTcrrIxzp/RBORWoqm0HpKpymXX4w', '6900000012', 'Σταδίου 15', 'Αλεξάνδρου');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Πέτρος', 13, 'petros13@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$R68IVWsFVf4w3+AmbHgiUw$IevzYynvD3wypk1Tv68vbtIQVFyMc3xoa+LBlBzuW9s', '6900000013', 'Αριστοτέλους 8', 'Πετρόπουλος');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('ΜΕΓΑΛΟΣ', 16, 'el@g.com', '$argon2id$v=19$m=65536,t=3,p=4$pbYPqs2K8AV0A4S6vP4xZQ$n4A6IZyH0iOwn8auh8XsW9lTchF/D34s1PjMuo9fW7g', 'PAREMETHL', 'MESSOLOGIOY 89', 'ΜΑΓΚΑΣ');
INSERT INTO public."USER" OVERRIDING SYSTEM VALUE VALUES ('Thanasis', 17, 'thanos@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$w8TJSnanSWPf2xMsy4DLkg$0y22L3Q4YrCZjuHXrAWLf/RCpBENY6DK9X7Xx4zJ23U', '6944444444', 'Νόρμαν 3', 'Athanasiou');


--
-- TOC entry 3426 (class 0 OID 16570)
-- Dependencies: 222
-- Data for Name: USER_RESERVES_SESSION; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."USER_RESERVES_SESSION" VALUES (1, 34);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (1, 35);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (1, 54);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 74);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 77);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 70);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (3, 47);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (3, 26);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (3, 16);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (4, 1);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (4, 32);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (4, 84);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (5, 65);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (5, 8);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (5, 74);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (6, 15);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (6, 70);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (6, 42);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (7, 5);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (7, 65);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (8, 65);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (8, 82);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (8, 48);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (8, 68);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (9, 30);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (9, 36);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (9, 18);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (9, 25);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (9, 53);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (10, 58);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (10, 80);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (10, 70);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (10, 30);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (11, 56);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (11, 83);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (11, 81);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (11, 20);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (12, 81);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (12, 64);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (12, 10);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (12, 28);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (13, 18);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (13, 12);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (13, 44);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (16, 69);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (17, 75);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 2);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 43);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 63);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 55);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (2, 80);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (16, 7);
INSERT INTO public."USER_RESERVES_SESSION" VALUES (16, 64);


--
-- TOC entry 3427 (class 0 OID 16585)
-- Dependencies: 223
-- Data for Name: USER_SUBSCRIPTION; Type: TABLE DATA; Schema: public; Owner: gymon_db_user
--

INSERT INTO public."USER_SUBSCRIPTION" VALUES (1, 3, '2024-11-23', '2025-05-22', 'Αθήνα (Περιστέρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (1, 4, '2023-11-19', '2024-11-18', 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (1, 1, '2023-10-15', '2023-11-14', 'Αθήνα (Μαρούσι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (2, 4, '2024-05-22', '2025-05-22', 'Πάτρα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (2, 1, '2024-04-17', '2024-05-17', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (2, 3, '2023-10-15', '2024-04-12', 'Αθήνα (Μαρούσι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (3, 3, '2024-11-23', '2025-05-22', 'Αθήνα (Γλυφάδα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (3, 4, '2023-11-19', '2024-11-18', 'Αθήνα (Γλυφάδα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (3, 2, '2023-08-16', '2023-11-14', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (3, 4, '2025-05-24', '2026-05-24', 'Αθήνα (Μαρούσι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (4, 4, '2024-05-22', '2025-05-22', 'Λάρισα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (4, 2, '2024-02-17', '2024-05-17', 'Αθήνα (Μαρούσι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (4, 1, '2024-01-13', '2024-02-12', 'Πάτρα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (4, 4, '2025-05-24', '2026-05-24', 'Αθήνα (Μαρούσι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (5, 3, '2024-11-23', '2025-05-22', 'Αθήνα (Μαρούσι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (5, 2, '2024-08-20', '2024-11-18', 'Αθήνα (Περιστέρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (5, 3, '2024-02-17', '2024-08-15', 'Θεσσαλονίκη (Κέντρο)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (5, 1, '2025-05-25', '2025-06-24', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (6, 4, '2024-05-22', '2025-05-22', 'Λάρισα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (6, 3, '2023-11-19', '2024-05-17', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (6, 1, '2023-10-15', '2023-11-14', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (6, 3, '2025-05-23', '2025-11-19', 'Αθήνα (Γλυφάδα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (7, 4, '2024-05-22', '2025-05-22', 'Αθήνα (Γλυφάδα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (7, 3, '2023-11-19', '2024-05-17', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (7, 1, '2023-10-15', '2023-11-14', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (7, 3, '2025-05-25', '2025-11-21', 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (8, 3, '2024-11-23', '2025-05-22', 'Αθήνα (Περιστέρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (8, 1, '2024-10-19', '2024-11-18', 'Λάρισα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (8, 4, '2023-10-15', '2024-10-14', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (8, 2, '2025-05-23', '2025-08-21', 'Αθήνα (Περιστέρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (9, 4, '2024-05-22', '2025-05-22', 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (9, 2, '2024-02-17', '2024-05-17', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (9, 2, '2023-11-14', '2024-02-12', 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (9, 3, '2025-05-25', '2025-11-21', 'Πάτρα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (10, 1, '2025-04-22', '2025-05-22', 'Πάτρα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (10, 2, '2025-01-17', '2025-04-17', 'Αθήνα (Γλυφάδα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (10, 4, '2024-01-13', '2025-01-12', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (10, 1, '2025-05-25', '2025-06-24', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (11, 4, '2024-05-22', '2025-05-22', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (11, 2, '2024-02-17', '2024-05-17', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (11, 4, '2023-02-12', '2024-02-12', 'Λάρισα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (11, 3, '2025-05-26', '2025-11-22', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (12, 3, '2024-11-23', '2025-05-22', 'Θεσσαλονίκη (Τούμπα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (12, 3, '2024-05-22', '2024-11-18', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (12, 4, '2023-05-18', '2024-05-17', 'Αθήνα (Γλυφάδα)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (12, 4, '2025-05-25', '2026-05-25', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (13, 2, '2025-02-21', '2025-05-22', 'Λάρισα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (13, 2, '2024-11-18', '2025-02-16', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (13, 4, '2023-11-14', '2024-11-13', 'Αθήνα (Μαρούσι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (13, 1, '2025-05-23', '2025-06-22', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (2, 2, '2025-05-27', '2025-11-27', 'Λάρισα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (2, 4, '2025-05-26', '2027-05-26', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (1, 3, '2025-05-28', '2025-11-28', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (1, 1, '2025-05-28', '2025-07-28', 'Θεσσαλονίκη (Κέντρο)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (17, 1, '2025-05-28', '2025-07-28', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (17, 4, '2025-05-28', '2027-05-28', 'Πάτρα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (17, 2, '2025-05-28', '2025-08-28', 'Ηράκλειο');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (2, 3, '2025-05-27', '2026-05-27', 'Πάτρα');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (2, 1, '2025-05-27', '2025-10-27', 'Αθήνα (Περιστέρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (16, 4, '2025-05-28', '2027-05-28', 'Αθήνα (Χαλάνδρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (16, 1, '2025-05-28', '2025-08-28', 'Αθήνα (Περιστέρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (16, 2, '2025-05-28', '2025-08-28', 'Αθήνα (Περιστέρι)');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (16, 2, '2025-05-28', '2025-08-28', 'Χανιά');
INSERT INTO public."USER_SUBSCRIPTION" VALUES (1, 2, '2025-05-24', '2025-11-22', 'Αθήνα (Περιστέρι)');


--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 225
-- Name: SESSION_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: gymon_db_user
--

SELECT pg_catalog.setval('public."SESSION_ID_seq"', 85, true);


--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 224
-- Name: USER_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: gymon_db_user
--

SELECT pg_catalog.setval('public."USER_ID_seq"', 17, true);


--
-- TOC entry 3250 (class 2606 OID 16411)
-- Name: CATEGORY CATEGORY_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."CATEGORY"
    ADD CONSTRAINT "CATEGORY_pkey" PRIMARY KEY ("DURATION");


--
-- TOC entry 3246 (class 2606 OID 16406)
-- Name: GYM GYM_Email_key; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."GYM"
    ADD CONSTRAINT "GYM_Email_key" UNIQUE ("Email");


--
-- TOC entry 3262 (class 2606 OID 16554)
-- Name: GYM_PROVIDES_PROGRAM_SESSION GYM_PROVIDES_PROGRAM_SESSION_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."GYM_PROVIDES_PROGRAM_SESSION"
    ADD CONSTRAINT "GYM_PROVIDES_PROGRAM_SESSION_pkey" PRIMARY KEY ("PROGRAM_Name", "GYM_Location", "SESSION_ID");


--
-- TOC entry 3248 (class 2606 OID 16404)
-- Name: GYM GYM_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."GYM"
    ADD CONSTRAINT "GYM_pkey" PRIMARY KEY ("Location");


--
-- TOC entry 3252 (class 2606 OID 16479)
-- Name: PROGRAM PROGRAM_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."PROGRAM"
    ADD CONSTRAINT "PROGRAM_pkey" PRIMARY KEY ("Name");


--
-- TOC entry 3260 (class 2606 OID 16547)
-- Name: SESSION SESSION_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."SESSION"
    ADD CONSTRAINT "SESSION_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3254 (class 2606 OID 16504)
-- Name: SUBSCRIPTION SUBSCRIPTION_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."SUBSCRIPTION"
    ADD CONSTRAINT "SUBSCRIPTION_pkey" PRIMARY KEY ("ID", "gym_Location");


--
-- TOC entry 3256 (class 2606 OID 16524)
-- Name: USER USER_Email_key; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_Email_key" UNIQUE ("Email");


--
-- TOC entry 3264 (class 2606 OID 16574)
-- Name: USER_RESERVES_SESSION USER_RESERVES_SESSION_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER_RESERVES_SESSION"
    ADD CONSTRAINT "USER_RESERVES_SESSION_pkey" PRIMARY KEY ("USER-ID", "SESSION-ID");


--
-- TOC entry 3266 (class 2606 OID 16592)
-- Name: USER_SUBSCRIPTION USER_SUBSCRIPTION_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER_SUBSCRIPTION"
    ADD CONSTRAINT "USER_SUBSCRIPTION_pkey" PRIMARY KEY ("USER-ID", "SUBSCRIPTION-ID", "gym_Location");


--
-- TOC entry 3258 (class 2606 OID 16522)
-- Name: USER USER_pkey; Type: CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3269 (class 2606 OID 16555)
-- Name: GYM_PROVIDES_PROGRAM_SESSION GYM_PROVIDES_PROGRAM_SESSION_GYM_Location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."GYM_PROVIDES_PROGRAM_SESSION"
    ADD CONSTRAINT "GYM_PROVIDES_PROGRAM_SESSION_GYM_Location_fkey" FOREIGN KEY ("GYM_Location") REFERENCES public."GYM"("Location") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3270 (class 2606 OID 16560)
-- Name: GYM_PROVIDES_PROGRAM_SESSION GYM_PROVIDES_PROGRAM_SESSION_PROGRAM_Name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."GYM_PROVIDES_PROGRAM_SESSION"
    ADD CONSTRAINT "GYM_PROVIDES_PROGRAM_SESSION_PROGRAM_Name_fkey" FOREIGN KEY ("PROGRAM_Name") REFERENCES public."PROGRAM"("Name") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3271 (class 2606 OID 16565)
-- Name: GYM_PROVIDES_PROGRAM_SESSION GYM_PROVIDES_PROGRAM_SESSION_SESSION_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."GYM_PROVIDES_PROGRAM_SESSION"
    ADD CONSTRAINT "GYM_PROVIDES_PROGRAM_SESSION_SESSION_ID_fkey" FOREIGN KEY ("SESSION_ID") REFERENCES public."SESSION"("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3267 (class 2606 OID 16505)
-- Name: SUBSCRIPTION SUBSCRIPTION_CATEGORY_Duration_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."SUBSCRIPTION"
    ADD CONSTRAINT "SUBSCRIPTION_CATEGORY_Duration_fkey" FOREIGN KEY ("CATEGORY_Duration") REFERENCES public."CATEGORY"("DURATION") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3268 (class 2606 OID 16510)
-- Name: SUBSCRIPTION SUBSCRIPTION_gym_Location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."SUBSCRIPTION"
    ADD CONSTRAINT "SUBSCRIPTION_gym_Location_fkey" FOREIGN KEY ("gym_Location") REFERENCES public."GYM"("Location") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3272 (class 2606 OID 16575)
-- Name: USER_RESERVES_SESSION USER_RESERVES_SESSION_SESSION-ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER_RESERVES_SESSION"
    ADD CONSTRAINT "USER_RESERVES_SESSION_SESSION-ID_fkey" FOREIGN KEY ("SESSION-ID") REFERENCES public."SESSION"("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3273 (class 2606 OID 16580)
-- Name: USER_RESERVES_SESSION USER_RESERVES_SESSION_USER-ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER_RESERVES_SESSION"
    ADD CONSTRAINT "USER_RESERVES_SESSION_USER-ID_fkey" FOREIGN KEY ("USER-ID") REFERENCES public."USER"("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3274 (class 2606 OID 16593)
-- Name: USER_SUBSCRIPTION USER_SUBSCRIPTION_USER-ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER_SUBSCRIPTION"
    ADD CONSTRAINT "USER_SUBSCRIPTION_USER-ID_fkey" FOREIGN KEY ("USER-ID") REFERENCES public."USER"("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3275 (class 2606 OID 16598)
-- Name: USER_SUBSCRIPTION USER_SUBSCRIPTION_gym_Location_SUBSCRIPTION-ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gymon_db_user
--

ALTER TABLE ONLY public."USER_SUBSCRIPTION"
    ADD CONSTRAINT "USER_SUBSCRIPTION_gym_Location_SUBSCRIPTION-ID_fkey" FOREIGN KEY ("gym_Location", "SUBSCRIPTION-ID") REFERENCES public."SUBSCRIPTION"("gym_Location", "ID");


--
-- TOC entry 2072 (class 826 OID 16391)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO gymon_db_user;


--
-- TOC entry 2074 (class 826 OID 16393)
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO gymon_db_user;


--
-- TOC entry 2073 (class 826 OID 16392)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO gymon_db_user;


--
-- TOC entry 2071 (class 826 OID 16390)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO gymon_db_user;


-- Completed on 2025-05-28 19:08:18

--
-- PostgreSQL database dump complete
--

