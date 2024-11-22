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

TRUNCATE TABLE public.users;

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: paul
--

COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at, name, admin) FROM stdin;
1	paul@paul-carrick.com	$2a$12$uBNY5frQZelFHm3P1NY/OuE0aCHpt14LP1/Ngz.YiuYkU3Cjq1e76	\N	\N	\N	2024-11-22 12:39:05.490492	2024-11-22 12:39:05.490492	Paul Carrick	t
2	guest@paul-carrick.com	Cannot Log In	\N	\N	\N	2024-11-22 08:07:55.771186	2024-11-22 08:07:55.771186	Guest User	f
\.

--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: paul
--

SELECT pg_catalog.setval('public.users_id_seq', (SELECT MAX(id) FROM public.users), true);
