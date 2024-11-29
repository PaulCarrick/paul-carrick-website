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

COPY public.blog_posts (id, title, author, posted, content, created_at, updated_at, checksum) FROM stdin;
1	Paul's First Entry	Paul Carrick	2024-11-21 09:38:59.159193	<div>This is my first<strong> </strong>post. I've been developing this website and the blog functionality is now ready. If you are seeing this post it's working.</div>	2024-11-21 09:38:59.159193	2024-11-29 19:23:46.474121	d4a1c4990a841ca14093e586359606ef95cf5160f34b5beecbf9f1f7152ad7844f3ca35049513ca5c0e490943652ad8ac49e2dc34a98861f9f5da33febcf39f7a7f7c94357ae7b54c326442bcb864a2f9af6d9bb09eaa1863fcfd588bd136eeef35dd1d95b4d9c846d4febbbc846b9e96d97a2a27aee914060ec444414ac7e27a32e3b726cf40c8ad99fc965eaefc54ba97f5b37e958f25517cd56c8d4d9743f0498b1b4ce672c65b7cfd79110c213bb1dd09d7a7b96752940e16b3a9a80760107204bdd24e9be02b8551d04aa8a5dd502ee7907fe796d98accd5d5169a0fb9aab5453410c35685276d0d4930f158601c8649d321289cf349f8ea21578f03a2b
2	Adding Search	Paul Carrick	2024-11-25 08:10:56.752795	I'm adding search capability to my website via Ransack.	2024-11-25 08:10:56.752795	2024-11-29 19:23:46.478683	ef3fcc4222c4719fb85ddcb48dbe7b144de6e4bf5d5c501ffe4858a5a5059885f435fdcaef81e8bc7b296602f0bda87d7ffd0a256fbf6196e34b0207bccb5ca36e64f4a07041abbe4f5ceb7fd266ccfc9e04037da1e0af878e925fc879374133dac04d2f5b1c7249942c0f3b7977d3e3f9f348f66d7742b24273c8facfbf77ddb1c4f931bfc2d210ff811ecb506a487240bea82f86ed69403acc32257fb68e66d0f75a6d2c2ab6c4e462c9b5be528fdf0e0cb867f651c9283e87f250e090920e90413a6f231faf463efda7ee0323e7b270528126e0428b2bc0fcb21205f153ddbd3106a70b9433a7b892cbf465a8246ff71d830392ec2c0525414c5c953cb688
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
