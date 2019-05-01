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
-- Name: attendants; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA attendants;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = attendants, pg_catalog;

--
-- Name: coatcheck_gen(); Type: FUNCTION; Schema: attendants; Owner: -
--

CREATE FUNCTION coatcheck_gen() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
coat_num bigint; 
begin 
IF NEW.attend IS false THEN
RAISE EXCEPTION 'attend cannot be false';
END IF;
coat_num := (old.frkey_id_event + old.frkey_id_guest);
loop
exit when (SELECT count(*) FROM guest_list where frkey_id_event = old.frkey_id_event and coatcheck_num = coat_num group by coatcheck_num) = 0 or (SELECT count(*) FROM guest_list where frkey_id_event = old.frkey_id_event and coatcheck_num = coat_num group by coatcheck_num) is Null ;
coat_num = coat_num +1;
end loop;

new.coatcheck_num = coat_num;
return new; 
end;
$$;


--
-- Name: tikt_gen(); Type: FUNCTION; Schema: attendants; Owner: -
--

CREATE FUNCTION tikt_gen() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare 
ticket_num bigint;

begin 
if (new.is_event = true) then 
ticket_num := (new.frkey_id_guest +  new.frkey_id_guest + new.id_contri + cast(EXTRACT(EPOCH FROM new.c_date) as bigint)  ); 

insert into guest_list  (ticket_number, frkey_id_guest, frkey_id_event) values (ticket_num, new.frkey_id_guest, new.frkey_id_event); 

return new; 
end if; 
return new; 
end;
 $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: contributions; Type: TABLE; Schema: attendants; Owner: -
--

CREATE TABLE contributions (
    id_contri bigint NOT NULL,
    is_event boolean,
    c_date timestamp without time zone NOT NULL,
    c_amount numeric(18,4) DEFAULT 0.00 NOT NULL,
    c_type character(10),
    frkey_id_guest bigint,
    frkey_id_event bigint,
    CONSTRAINT checktype CHECK (((c_type = 'event'::bpchar) OR (c_type = 'donation'::bpchar) OR (c_type = 'other'::bpchar))),
    CONSTRAINT chk_id_guestntnll CHECK ((frkey_id_guest IS NOT NULL)),
    CONSTRAINT chk_ife_then_ekeyid CHECK ((NOT ((is_event = true) AND (frkey_id_event IS NULL)))),
    CONSTRAINT chk_ifnote_then_noev CHECK ((NOT ((NOT (is_event = true)) AND (frkey_id_event IS NOT NULL))))
);


--
-- Name: data_schedule; Type: TABLE; Schema: attendants; Owner: -
--

CREATE TABLE data_schedule (
    frkey_id_event bigint NOT NULL,
    frkey_id_loc bigint NOT NULL
);


--
-- Name: events; Type: TABLE; Schema: attendants; Owner: -
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


--
-- Name: guests; Type: TABLE; Schema: attendants; Owner: -
--

CREATE TABLE guests (
    g_name character varying(100),
    g_email character varying(100),
    id_guest bigint NOT NULL
);


--
-- Name: guest_contrbutional_value; Type: VIEW; Schema: attendants; Owner: -
--

CREATE VIEW guest_contrbutional_value AS
 SELECT count(contributions.frkey_id_guest) AS number_of_contributions,
    guests.g_name,
    sum(contributions.c_amount) AS total_contributions
   FROM (guests
     JOIN contributions ON (((guests.id_guest)::text = (contributions.frkey_id_guest)::text)))
  GROUP BY guests.g_name;


--
-- Name: guest_list; Type: TABLE; Schema: attendants; Owner: -
--

CREATE TABLE guest_list (
    ticket_number bigint NOT NULL,
    frkey_id_guest bigint,
    frkey_id_event bigint,
    attend boolean DEFAULT false,
    coatcheck boolean DEFAULT false,
    coatcheck_num bigint
);


--
-- Name: locations; Type: TABLE; Schema: attendants; Owner: -
--

CREATE TABLE locations (
    id_loc bigint NOT NULL,
    l_name character varying(120),
    capacity integer
);


--
-- Name: schedule; Type: VIEW; Schema: attendants; Owner: -
--

CREATE VIEW schedule AS
 SELECT events.e_name AS event,
    events.begin_event AS event_start,
    events.end_event,
    locations.l_name AS location
   FROM ((data_schedule
     JOIN locations ON (((data_schedule.frkey_id_loc)::text = (locations.id_loc)::text)))
     JOIN events ON (((data_schedule.frkey_id_event)::text = (events.id_event)::text)))
  ORDER BY events.begin_event;


--
-- Data for Name: contributions; Type: TABLE DATA; Schema: attendants; Owner: -
--

COPY contributions (id_contri, is_event, c_date, c_amount, c_type, frkey_id_guest, frkey_id_event) FROM stdin;
1	t	1242-11-23 12:12:12	33.3300	event     	1	1
22	t	1893-04-27 17:37:13	2.3300	event     	3	53
4	t	8391-10-27 01:07:13	3.3300	event     	2	53
882	t	2293-05-27 17:37:13	35.3300	event     	3	53
3	f	3242-01-04 13:12:04	75.3200	other     	2	\N
\.


--
-- Data for Name: data_schedule; Type: TABLE DATA; Schema: attendants; Owner: -
--

COPY data_schedule (frkey_id_event, frkey_id_loc) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: attendants; Owner: -
--

COPY events (id_event, e_name, begin_event, end_event, e_budget, e_revune) FROM stdin;
1	zodp	\N	\N	\N	\N
53	elanr	\N	\N	\N	\N
555	kalz	\N	\N	\N	\N
\.


--
-- Data for Name: guest_list; Type: TABLE DATA; Schema: attendants; Owner: -
--

COPY guest_list (ticket_number, frkey_id_guest, frkey_id_event, attend, coatcheck, coatcheck_num) FROM stdin;
28	3	53	f	f	\N
10205632321	3	53	f	f	\N
3	1	1	t	t	2
8	2	53	t	f	\N
\.


--
-- Data for Name: guests; Type: TABLE DATA; Schema: attendants; Owner: -
--

COPY guests (g_name, g_email, id_guest) FROM stdin;
zamlmz	dhkabom@fh.dfh	1
erlaiz	dakalmz@fkjhdsf.fd	2
tielaz	alamkrza@fholz.je8	3
olvna	ovrkvilan@slemab.g51	4
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: attendants; Owner: -
--

COPY locations (id_loc, l_name, capacity) FROM stdin;
\.


--
-- Name: contributions contributions_pkey; Type: CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT contributions_pkey PRIMARY KEY (id_contri);


--
-- Name: data_schedule data_schedule_pkey; Type: CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY data_schedule
    ADD CONSTRAINT data_schedule_pkey PRIMARY KEY (frkey_id_event, frkey_id_loc);


--
-- Name: guest_list guest_list_pkey; Type: CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY guest_list
    ADD CONSTRAINT guest_list_pkey PRIMARY KEY (ticket_number);


--
-- Name: events id_ekey; Type: CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT id_ekey PRIMARY KEY (id_event);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id_loc);


--
-- Name: guests pk_guest; Type: CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY guests
    ADD CONSTRAINT pk_guest PRIMARY KEY (id_guest);


--
-- Name: guest_list trg_coatchek_gen; Type: TRIGGER; Schema: attendants; Owner: -
--

CREATE TRIGGER trg_coatchek_gen BEFORE UPDATE ON guest_list FOR EACH ROW WHEN ((new.coatcheck = true)) EXECUTE PROCEDURE coatcheck_gen();


--
-- Name: contributions trg_ticket_genrator; Type: TRIGGER; Schema: attendants; Owner: -
--

CREATE TRIGGER trg_ticket_genrator AFTER INSERT ON contributions FOR EACH ROW EXECUTE PROCEDURE tikt_gen();


--
-- Name: contributions fk_contri_guest; Type: FK CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT fk_contri_guest FOREIGN KEY (frkey_id_guest) REFERENCES guests(id_guest);


--
-- Name: data_schedule fkey_dats_evnt; Type: FK CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY data_schedule
    ADD CONSTRAINT fkey_dats_evnt FOREIGN KEY (frkey_id_event) REFERENCES events(id_event);


--
-- Name: data_schedule fkey_dats_loc; Type: FK CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY data_schedule
    ADD CONSTRAINT fkey_dats_loc FOREIGN KEY (frkey_id_loc) REFERENCES locations(id_loc);


--
-- Name: guest_list fkey_gl_event; Type: FK CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY guest_list
    ADD CONSTRAINT fkey_gl_event FOREIGN KEY (frkey_id_event) REFERENCES events(id_event);


--
-- Name: guest_list fkey_gl_guest; Type: FK CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY guest_list
    ADD CONSTRAINT fkey_gl_guest FOREIGN KEY (frkey_id_guest) REFERENCES guests(id_guest);


--
-- Name: contributions frkey_contri_event; Type: FK CONSTRAINT; Schema: attendants; Owner: -
--

ALTER TABLE ONLY contributions
    ADD CONSTRAINT frkey_contri_event FOREIGN KEY (frkey_id_event) REFERENCES events(id_event);


--
-- PostgreSQL database dump complete
--

