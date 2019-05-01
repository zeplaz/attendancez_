--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.4
-- Dumped by pg_dump version 9.6.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: attendants; Type: SCHEMA; Schema: -; Owner: mduffy
--

CREATE SCHEMA attendants;


ALTER SCHEMA attendants OWNER TO mduffy;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = attendants, pg_catalog;

--
-- Name: tikt_gen(); Type: FUNCTION; Schema: attendants; Owner: mduffy
--

CREATE FUNCTION tikt_gen() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
ticket_num int;

begin 
if (new.is_event = true) then 

ticket_num := (new.frkey_id_guest +  new.frkey_id_guest + new.id_contri);
insert into guest_list  (ticket_number, frkey_id_guest, frkey_id_event) values (ticket_num, new.frkey_id_guest, new.frkey_id_event); 

return new; 
end if; 
return new; 
end;
 $$;


ALTER FUNCTION attendants.tikt_gen() OWNER TO mduffy;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: contributions; Type: TABLE; Schema: attendants; Owner: mduffy
--

CREATE TABLE contributions (
    id_contri bigint NOT NULL,
    is_event boolean,
    c_date timestamp without time zone NOT NULL,
    c_amount numeric(18,4) DEFAULT 0.00 NOT NULL,
    c_type character(10),
    frkey_id_guest bigint,
    frkey_id_event bigint,
    CONSTRAINT chk_ife_then_ekeyid CHECK ((NOT ((is_event = true) AND (frkey_id_event IS NULL)))),
    CONSTRAINT chk_ifnote_then_noev CHECK ((NOT ((NOT (is_event = true)) AND (frkey_id_event IS NOT NULL))))
);


ALTER TABLE contributions OWNER TO mduffy;

--
-- Name: data_schedule; Type: TABLE; Schema: attendants; Owner: mduffy
--

CREATE TABLE data_schedule (
    frkey_id_event bigint NOT NULL,
    frkey_id_loc bigint NOT NULL
);


ALTER TABLE data_schedule OWNER TO mduffy;

--
-- Name: events; Type: TABLE; Schema: attendants; Owner: mduffy
--

CREATE TABLE events (
    id_event bigint NOT NULL,
    e_name character varying(250),
    begin_event timestamp without time zone,
    end_event timestamp without time zone,
    e_budget numeric(18,4),
    e_revune numeric(18,4),
    CONSTRAINT chk_begin_end_valid CHECK ((end_event > begin_event))
);


ALTER TABLE events OWNER TO mduffy;

--
-- Name: guest_list; Type: TABLE; Schema: attendants; Owner: mduffy
--

CREATE TABLE guest_list (
    ticket_number bigint NOT NULL,
    frkey_id_guest bigint,
    frkey_id_event bigint,
    attend boolean DEFAULT false,
    coatcheck boolean DEFAULT false,
    coatcheck_num bigint
);


ALTER TABLE guest_list OWNER TO mduffy;

--
-- Name: guests; Type: TABLE; Schema: attendants; Owner: mduffy
--

CREATE TABLE guests (
    g_name character varying(100),
    g_email character varying(100),
    total_contrabution numeric(18,4),
    id_guest bigint NOT NULL
);


ALTER TABLE guests OWNER TO mduffy;

--
-- Name: locations; Type: TABLE; Schema: attendants; Owner: mduffy
--

CREATE TABLE locations (
    id_loc bigint NOT NULL,
    l_name character varying(120),
    capacity integer
);


ALTER TABLE locations OWNER TO mduffy;

SET search_path = public, pg_catalog;

--
-- Name: players; Type: TABLE; Schema: public; Owner: mduffy
--

CREATE TABLE players (
    id_player character(999),
    birthday date,
    fkey_id_team character(999)
);


ALTER TABLE players OWNER TO mduffy;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: mduffy
--

CREATE TABLE teams (
    id_team character(999) NOT NULL,
    t_name character(99) NOT NULL
);


ALTER TABLE teams OWNER TO mduffy;

SET search_path = attendants, pg_catalog;

--
-- Data for Name: contributions; Type: TABLE DATA; Schema: attendants; Owner: mduffy
--

COPY contributions (id_contri, is_event, c_date, c_amount, c_type, frkey_id_guest, frkey_id_event) FROM stdin;
1	t	1242-11-23 12:12:12	33.3300	event     	1	1
22	t	1893-04-27 17:37:13	2.3300	event     	3	53
4	t	8391-10-27 01:07:13	3.3300	event     	2	53
\.


--
-- Data for Name: data_schedule; Type: TABLE DATA; Schema: attendants; Owner: mduffy
--

COPY data_schedule (frkey_id_event, frkey_id_loc) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: attendants; Owner: mduffy
--

COPY events (id_event, e_name, begin_event, end_event, e_budget, e_revune) FROM stdin;
1	zodp	\N	\N	\N	\N
53	elanr	\N	\N	\N	\N
555	kalz	\N	\N	\N	\N
\.


--
-- Data for Name: guest_list; Type: TABLE DATA; Schema: attendants; Owner: mduffy
--

COPY guest_list (ticket_number, frkey_id_guest, frkey_id_event, attend, coatcheck, coatcheck_num) FROM stdin;
3	1	1	f	f	\N
28	3	53	f	f	\N
8	2	53	f	f	\N
\.


--
-- Data for Name: guests; Type: TABLE DATA; Schema: attendants; Owner: mduffy
--

COPY guests (g_name, g_email, total_contrabution, id_guest) FROM stdin;
zamlmz	dhkabom@fh.dfh	\N	1
erlaiz	dakalmz@fkjhdsf.fd	\N	2
tielaz	alamkrza@fholz.je8	\N	3
olvna	ovrkvilan@slemab.g51	\N	4
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: attendants; Owner: mduffy
--

COPY locations (id_loc, l_name, capacity) FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: mduffy
--

COPY players (id_player, birthday, fkey_id_team) FROM stdin;
1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	1975-03-12	1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	1972-03-12	1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	1979-03-12	1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	1971-03-12	2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	1971-04-12	2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	1972-04-12	3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: mduffy
--

COPY teams (id_team, t_name) FROM stdin;
1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	teama                                                                                              
2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	teamb                                                                                              
3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	teamc                                                                                              
\.


SET search_path = attendants, pg_catalog;

--
-- Name: contributions contributions_pkey; Type: CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT contributions_pkey PRIMARY KEY (id_contri);


--
-- Name: data_schedule data_schedule_pkey; Type: CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY data_schedule
    ADD CONSTRAINT data_schedule_pkey PRIMARY KEY (frkey_id_event, frkey_id_loc);


--
-- Name: guest_list guest_list_pkey; Type: CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY guest_list
    ADD CONSTRAINT guest_list_pkey PRIMARY KEY (ticket_number);


--
-- Name: events id_ekey; Type: CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY events
    ADD CONSTRAINT id_ekey PRIMARY KEY (id_event);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id_loc);


--
-- Name: guests pk_guest; Type: CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY guests
    ADD CONSTRAINT pk_guest PRIMARY KEY (id_guest);


SET search_path = public, pg_catalog;

--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: mduffy
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id_team);


--
-- Name: teams teams_t_name_key; Type: CONSTRAINT; Schema: public; Owner: mduffy
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_t_name_key UNIQUE (t_name);


SET search_path = attendants, pg_catalog;

--
-- Name: contributions trg_ticket_genrator; Type: TRIGGER; Schema: attendants; Owner: mduffy
--

CREATE TRIGGER trg_ticket_genrator AFTER INSERT ON contributions FOR EACH ROW EXECUTE PROCEDURE tikt_gen();


--
-- Name: contributions fk_contri_guest; Type: FK CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT fk_contri_guest FOREIGN KEY (frkey_id_guest) REFERENCES guests(id_guest);


--
-- Name: data_schedule fkey_dats_evnt; Type: FK CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY data_schedule
    ADD CONSTRAINT fkey_dats_evnt FOREIGN KEY (frkey_id_event) REFERENCES events(id_event);


--
-- Name: data_schedule fkey_dats_loc; Type: FK CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY data_schedule
    ADD CONSTRAINT fkey_dats_loc FOREIGN KEY (frkey_id_loc) REFERENCES locations(id_loc);


--
-- Name: guest_list fkey_gl_event; Type: FK CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY guest_list
    ADD CONSTRAINT fkey_gl_event FOREIGN KEY (frkey_id_event) REFERENCES events(id_event);


--
-- Name: guest_list fkey_gl_guest; Type: FK CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY guest_list
    ADD CONSTRAINT fkey_gl_guest FOREIGN KEY (frkey_id_guest) REFERENCES guests(id_guest);


--
-- Name: contributions frkey_contri_event; Type: FK CONSTRAINT; Schema: attendants; Owner: mduffy
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT frkey_contri_event FOREIGN KEY (frkey_id_event) REFERENCES events(id_event);


SET search_path = public, pg_catalog;

--
-- Name: players fkey_pteam; Type: FK CONSTRAINT; Schema: public; Owner: mduffy
--

ALTER TABLE ONLY players
    ADD CONSTRAINT fkey_pteam FOREIGN KEY (fkey_id_team) REFERENCES teams(id_team);


--
-- PostgreSQL database dump complete
--

