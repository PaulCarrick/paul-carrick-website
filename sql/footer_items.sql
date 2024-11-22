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

TRUNCATE TABLE public.footer_items CASCADE;

--
-- Data for Name: footer_items; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY public.footer_items (id, label, icon, options, link, access, footer_order, parent_id, created_at, updated_at) FROM stdin;
1	PERSONAL	\N	\N	\N	\N	1	\N	2024-11-22 07:46:18.222073	2024-11-22 07:46:18.222073
2	Paul's Family	\N	\N	/family	\N	2	1	2024-11-22 07:47:27.55769	2024-11-22 07:47:27.55769
3	Where Paul Lives	\N	\N	/live	\N	3	1	2024-11-22 07:49:18.039604	2024-11-22 07:49:18.039604
4	Hobbies and Activities	\N	\N	/hobby	\N	4	1	2024-11-22 07:50:02.34172	2024-11-22 07:50:02.34172
5	Biography	\N	\N	/bio	\N	5	1	2024-11-22 07:51:22.319392	2024-11-22 07:51:22.319392
6	Blog	\N	\N	/blog	\N	6	1	2024-11-22 07:52:02.038068	2024-11-22 07:52:02.038068
7	PROFESSIONAL	\N	\N	\N	\N	7	\N	2024-11-22 07:52:36.2135	2024-11-22 07:52:36.2135
8	Professional Overview	\N	\N	/overview	\N	8	7	2024-11-22 07:53:44.437065	2024-11-22 07:53:44.437065
9	Employment History	\N	\N	/employment	\N	9	7	2024-11-22 07:54:29.216616	2024-11-22 07:54:29.216616
10	Portfolio	\N	\N	/portfolio	\N	10	7	2024-11-22 07:55:45.068296	2024-11-22 07:55:45.068296
11	OTHER	\N	\N	\N	\N	11	\N	2024-11-22 07:56:24.787828	2024-11-22 07:56:24.787828
14	Admin Dashboard	\N	\N	/admin/dashboard	admin	13	11	2024-11-22 07:59:12.283882	2024-11-22 07:59:12.283882
13	Contact Paul	\N	\N	/contact/new	\N	12	11	2024-11-22 07:58:10.084441	2024-11-22 07:58:10.084441
\.

--
-- Name: footer_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('public.footer_items_id_seq', (SELECT MAX(id) FROM public.footer_items), true);
