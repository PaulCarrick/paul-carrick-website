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

TRUNCATE TABLE public.post_comments CASCADE;
TRUNCATE TABLE public.blog_posts CASCADE;

--
-- Data for Name: blog_posts; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY public.blog_posts (id, title, author, posted, content, created_at, updated_at) FROM stdin;
1	Paul's First Entry	Paul Carrick	2024-11-21 09:38:59.159193	This is my first post. I've been developing this website and the blog functionality is now ready. If you are seeing this post it's working.	2024-11-21 09:38:59.159193	2024-11-21 09:38:59.159193
2	Adding Search	Paul Carrick	2024-11-25 08:10:56.752795	I'm adding search capability to my website via Ransack.	2024-11-25 08:10:56.752795	2024-11-25 08:10:56.752795
\.

--
-- Name: post_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('public.blog_posts_id_seq', (SELECT MAX(id) FROM public.blog_posts), true);

--
-- Data for Name: post_comments; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY public.post_comments (id, blog_post_id, title, author, posted, content, created_at, updated_at) FROM stdin;
1	1	I agree.	Paul Carrick	2024-11-21 09:53:08.079823	I agree completely.	2024-11-21 09:53:08.079823	2024-11-21 09:53:08.079823
\.

--
-- Name: post_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('public.post_comments_id_seq', (SELECT MAX(id) FROM public.post_comments), true);
