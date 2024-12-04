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

COPY public.menu_items (id, menu_type, label, icon, options, link, access, menu_order, parent_id, created_at, updated_at) FROM stdin;
1	Main	Home	\N	\N	/	\N	1	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
2	Main	Personal	\N	\N	\N	\N	2	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
3	Main	Professional	\N	\N	\N	\N	3	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
4	Main	Contact	\N	\N	/contact/new	\N	4	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
5	Main	Search	/images/search.svg	image-file	/search/new	\N	5	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
6	Main	Login	\N	\N	/users/sign_in	\N	6	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
7	Main	Family	\N	\N	/family	\N	1	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
8	Main	Where Paul Lives	\N	\N	/live	\N	2	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
9	Main	Hobbies and Activities	\N	\N	/hobby	\N	3	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
10	Main	Bio	\N	\N	/bio	\N	4	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
11	Main	Blog	\N	\N	/blog	\N	5	2	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
12	Main	Overview	\N	\N	/overview	\N	1	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
13	Main	Employment	\N	\N	/employment	\N	2	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
14	Main	Portfolio	\N	\N	/portfolio	\N	3	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
15	Main	Blog	\N	\N	/blog?blog_type=Professional	\N	4	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
16	Admin	Blogs	\N	\N	/admin/blogs	\N	1	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
17	Admin	Pages	\N	super_only	/admin/pages	\N	2	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
18	Admin	Sections	\N	super_only	/admin/sections	\N	3	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
19	Admin	Image Files	\N	super_only	/admin/image_files	\N	5	\N	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
20	Main	Blog	\N	\N	/blog?blog_type=Professional	\N	4	3	2024-11-14 11:17:04.434096	2024-11-14 11:17:04.434096
\.

--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('public.menu_items_id_seq', (SELECT MAX(id) FROM public.menu_items), true);
