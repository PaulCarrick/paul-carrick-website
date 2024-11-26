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

TRUNCATE TABLE public.menu_items CASCADE;

--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY public.menu_items (id, label, icon, options, link, menu_order, parent_id, created_at, updated_at, access) FROM stdin;
1	Home	\N	\N	/	1	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
2	Personal	\N	\N	\N	2	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
3	Professional	\N	\N	\N	3	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
4	Contact	\N	\N	/contact/new	4	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
5	Search	/images/search.svg	image-file	/search/new	5	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
6	Login	\N	\N	/users/sign_in	6	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
7	Family	\N	\N	/family	1	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
8	Where Paul Lives	\N	\N	/live	2	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
9	Hobbies and Activities	\N	\N	/hobby	3	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
10	Bio	\N	\N	/bio	4	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
11	Blog	\N	\N	/blog	5	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
12	Overview	\N	\N	/overview	1	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
13	Employment	\N	\N	/employment	2	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
14	Portfolio	\N	\N	/portfolio	3	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096	\N
\.

--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('public.menu_items_id_seq', (SELECT MAX(id) FROM public.menu_items), true);
