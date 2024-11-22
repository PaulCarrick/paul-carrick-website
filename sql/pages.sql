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

TRUNCATE TABLE public.pages;

--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY public.pages (id, name, section, title, access, created_at, updated_at) FROM stdin;
5	hobby	Hobby	Hobbies and Activities	\N	2024-11-22 09:43:45.39377	2024-11-22 09:43:45.39377
3	employment	Employment	Pau's Employment	\N	2024-11-22 09:37:36.009481	2024-11-22 09:37:36.009481
6	home	Home	Home Page	\N	2024-11-22 09:45:19.338732	2024-11-22 09:45:19.338732
7	live	Live	Where Paul Lives	\N	2024-11-22 09:45:51.202092	2024-11-22 09:45:51.202092
8	overview	Overview	Professional Overview	\N	2024-11-22 09:47:11.800835	2024-11-22 09:47:11.800835
9	portfolio	Portfolio	Paul's Portfolio	\N	2024-11-22 09:47:55.500819	2024-11-22 09:47:55.500819
2	blog	Blog	Paul's Blog	\N	2024-11-22 09:22:15.691988	2024-11-22 09:22:15.691988
1	bio	Bio	Paul's Mini-Biography	\N	2024-11-22 09:21:17.79134	2024-11-22 09:21:17.79134
4	family	Family	Paul's Family	\N	2024-11-22 09:42:42.744925	2024-11-22 09:42:42.744925
\.

--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('public.pages_id_seq', (SELECT MAX(id) FROM public.pages), true);
