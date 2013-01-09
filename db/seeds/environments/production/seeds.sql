--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: bookmarks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('bookmarks_id_seq', 210, true);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('delayed_jobs_id_seq', 6, true);


--
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('lessons_id_seq', 23, true);


--
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('likes_id_seq', 8, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('locations_id_seq', 7, true);


--
-- Name: media_elements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('media_elements_id_seq', 192, true);


--
-- Name: media_elements_slides_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('media_elements_slides_id_seq', 147, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('notifications_id_seq', 63, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('reports_id_seq', 1, false);


--
-- Name: school_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('school_levels_id_seq', 3, true);


--
-- Name: slides_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('slides_id_seq', 183, true);


--
-- Name: subjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('subjects_id_seq', 11, true);


--
-- Name: taggings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('taggings_id_seq', 999, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('tags_id_seq', 300, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('users_id_seq', 13, true);


--
-- Name: users_subjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('users_subjects_id_seq', 99, true);


--
-- Name: virtual_classroom_lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: desy
--

SELECT pg_catalog.setval('virtual_classroom_lessons_id_seq', 31, true);


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO locations VALUES (1, 'Shanghai', '2012-12-20 10:31:31.350111', '2012-12-20 10:31:31.350111');
INSERT INTO locations VALUES (2, 'Guangzhou', '2012-12-20 10:31:31.370682', '2012-12-20 10:31:31.370682');
INSERT INTO locations VALUES (3, 'Wuhan', '2012-12-20 10:31:31.382205', '2012-12-20 10:31:31.382205');
INSERT INTO locations VALUES (4, 'Beijing', '2012-12-20 10:31:31.388169', '2012-12-20 10:31:31.388169');
INSERT INTO locations VALUES (5, 'Tianjin', '2012-12-20 10:31:31.394182', '2012-12-20 10:31:31.394182');
INSERT INTO locations VALUES (6, 'Shenzhen', '2012-12-20 10:31:31.400057', '2012-12-20 10:31:31.400057');
INSERT INTO locations VALUES (7, 'Nanjing', '2012-12-20 10:31:31.406143', '2012-12-20 10:31:31.406143');


--
-- Data for Name: school_levels; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO school_levels VALUES (1, 'Primary School', '2012-12-20 10:31:31.434766', '2012-12-20 10:31:31.434766');
INSERT INTO school_levels VALUES (2, 'Secondary School', '2012-12-20 10:31:31.448679', '2012-12-20 10:31:31.448679');
INSERT INTO school_levels VALUES (3, 'Undergraduate', '2012-12-20 10:31:31.458324', '2012-12-20 10:31:31.458324');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO users VALUES (1, 'desy@morganspa.com', 'DESY', 'Admin User', 1, 'School', NULL, NULL, 1, '2012-12-20 10:31:31.781634', '2012-12-20 10:31:31.781634');
INSERT INTO users VALUES (2, 'toostrong@morganspa.com', 'Kassandra', 'Scarlet', 2, 'ITC BrokenTower', NULL, NULL, 6, '2012-12-20 10:31:31.963232', '2012-12-20 10:31:31.963232');
INSERT INTO users VALUES (3, 'fupete@morganspa.com', 'Victor', 'Plum', 3, 'ISS Pro', NULL, NULL, 1, '2012-12-20 10:31:31.985945', '2012-12-20 10:31:31.985945');
INSERT INTO users VALUES (4, 'jeg@morganspa.com', 'Jack', 'Mustard', 2, 'ISA Carlocracco', NULL, NULL, 3, '2012-12-20 10:31:32.009968', '2012-12-20 10:31:32.009968');
INSERT INTO users VALUES (5, 'holly@morganspa.com', 'Jacob', 'Green', 1, 'ITC Pocotopocoto', NULL, NULL, 4, '2012-12-20 10:31:32.033923', '2012-12-20 10:31:32.033923');
INSERT INTO users VALUES (6, 'benji@morganspa.com', 'Diane', 'White', 1, 'ITC Pocotopocoto', NULL, NULL, 5, '2012-12-20 10:31:32.057864', '2012-12-20 10:31:32.057864');
INSERT INTO users VALUES (7, 'retlaw@morganspa.com', 'Eleanor', 'Peacock', 3, 'ISA Amor III', NULL, NULL, 6, '2012-12-20 10:31:32.087904', '2012-12-20 10:31:32.087904');
INSERT INTO users VALUES (8, 'desy1@morganspa.com', 'DESY', 'Admin User 1', 1, 'School', NULL, NULL, 1, '2012-12-21 15:39:53.886583', '2012-12-21 15:39:53.886583');
INSERT INTO users VALUES (9, 'desy2@morganspa.com', 'DESY', 'Admin User 2', 1, 'School', NULL, NULL, 1, '2012-12-21 15:39:54.026194', '2012-12-21 15:39:54.026194');
INSERT INTO users VALUES (10, 'desy3@morganspa.com', 'DESY', 'Admin User 3', 1, 'School', NULL, NULL, 1, '2012-12-21 15:39:54.084753', '2012-12-21 15:39:54.084753');
INSERT INTO users VALUES (11, 'desy4@morganspa.com', 'DESY', 'Admin User 4', 1, 'School', NULL, NULL, 1, '2012-12-21 15:39:54.144766', '2012-12-21 15:39:54.144766');
INSERT INTO users VALUES (12, 'desy5@morganspa.com', 'DESY', 'Admin User 5', 1, 'School', NULL, NULL, 1, '2012-12-21 15:39:54.204831', '2012-12-21 15:39:54.204831');
INSERT INTO users VALUES (13, 'desy6@morganspa.com', 'DESY', 'Admin User 6', 1, 'School', NULL, NULL, 1, '2012-12-21 15:39:54.264916', '2012-12-21 15:39:54.264916');


--
-- Data for Name: bookmarks; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO bookmarks VALUES (1, 6, 58, 'MediaElement', '2012-12-20 14:07:25.022466', '2012-12-20 14:07:25.022466');
INSERT INTO bookmarks VALUES (2, 6, 6, 'MediaElement', '2012-12-20 14:07:27.815717', '2012-12-20 14:07:27.815717');
INSERT INTO bookmarks VALUES (3, 6, 10, 'MediaElement', '2012-12-20 14:08:07.946316', '2012-12-20 14:08:07.946316');
INSERT INTO bookmarks VALUES (4, 6, 14, 'MediaElement', '2012-12-20 14:09:09.646649', '2012-12-20 14:09:09.646649');
INSERT INTO bookmarks VALUES (5, 6, 48, 'MediaElement', '2012-12-20 14:09:17.431514', '2012-12-20 14:09:17.431514');
INSERT INTO bookmarks VALUES (6, 6, 26, 'MediaElement', '2012-12-20 14:35:31.166077', '2012-12-20 14:35:31.166077');
INSERT INTO bookmarks VALUES (7, 6, 25, 'MediaElement', '2012-12-20 14:35:34.436123', '2012-12-20 14:35:34.436123');
INSERT INTO bookmarks VALUES (8, 7, 4, 'MediaElement', '2012-12-20 15:18:30.953026', '2012-12-20 15:18:30.953026');
INSERT INTO bookmarks VALUES (9, 7, 30, 'MediaElement', '2012-12-20 15:19:06.342172', '2012-12-20 15:19:06.342172');
INSERT INTO bookmarks VALUES (10, 7, 28, 'MediaElement', '2012-12-20 15:19:12.592652', '2012-12-20 15:19:12.592652');
INSERT INTO bookmarks VALUES (11, 7, 27, 'MediaElement', '2012-12-20 15:19:15.98982', '2012-12-20 15:19:15.98982');
INSERT INTO bookmarks VALUES (12, 7, 23, 'MediaElement', '2012-12-20 15:19:22.986169', '2012-12-20 15:19:22.986169');
INSERT INTO bookmarks VALUES (13, 7, 22, 'MediaElement', '2012-12-20 15:19:29.684388', '2012-12-20 15:19:29.684388');
INSERT INTO bookmarks VALUES (14, 7, 19, 'MediaElement', '2012-12-20 15:19:32.907239', '2012-12-20 15:19:32.907239');
INSERT INTO bookmarks VALUES (15, 7, 7, 'MediaElement', '2012-12-20 15:19:38.992561', '2012-12-20 15:19:38.992561');
INSERT INTO bookmarks VALUES (16, 7, 3, 'MediaElement', '2012-12-20 15:19:50.298192', '2012-12-20 15:19:50.298192');
INSERT INTO bookmarks VALUES (17, 2, 90, 'MediaElement', '2012-12-20 16:35:13.358689', '2012-12-20 16:35:13.358689');
INSERT INTO bookmarks VALUES (18, 2, 82, 'MediaElement', '2012-12-20 16:35:13.484367', '2012-12-20 16:35:13.484367');
INSERT INTO bookmarks VALUES (19, 2, 4, 'Lesson', '2012-12-20 16:46:43.84368', '2012-12-20 16:46:43.84368');
INSERT INTO bookmarks VALUES (20, 7, 89, 'MediaElement', '2012-12-20 17:13:31.878197', '2012-12-20 17:13:31.878197');
INSERT INTO bookmarks VALUES (21, 7, 97, 'MediaElement', '2012-12-20 17:13:31.933783', '2012-12-20 17:13:31.933783');
INSERT INTO bookmarks VALUES (22, 7, 91, 'MediaElement', '2012-12-20 17:13:32.032592', '2012-12-20 17:13:32.032592');
INSERT INTO bookmarks VALUES (23, 7, 93, 'MediaElement', '2012-12-20 17:13:32.166154', '2012-12-20 17:13:32.166154');
INSERT INTO bookmarks VALUES (24, 7, 96, 'MediaElement', '2012-12-20 17:13:32.281962', '2012-12-20 17:13:32.281962');
INSERT INTO bookmarks VALUES (25, 7, 101, 'MediaElement', '2012-12-20 17:13:32.338241', '2012-12-20 17:13:32.338241');
INSERT INTO bookmarks VALUES (26, 7, 98, 'MediaElement', '2012-12-20 17:13:32.390733', '2012-12-20 17:13:32.390733');
INSERT INTO bookmarks VALUES (27, 7, 102, 'MediaElement', '2012-12-20 17:13:32.44117', '2012-12-20 17:13:32.44117');
INSERT INTO bookmarks VALUES (28, 2, 95, 'MediaElement', '2012-12-21 08:11:25.401721', '2012-12-21 08:11:25.401721');
INSERT INTO bookmarks VALUES (29, 2, 104, 'MediaElement', '2012-12-21 08:39:40.432684', '2012-12-21 08:39:40.432684');
INSERT INTO bookmarks VALUES (30, 2, 105, 'MediaElement', '2012-12-21 08:43:27.11779', '2012-12-21 08:43:27.11779');
INSERT INTO bookmarks VALUES (31, 2, 106, 'MediaElement', '2012-12-21 08:43:27.177359', '2012-12-21 08:43:27.177359');
INSERT INTO bookmarks VALUES (32, 2, 107, 'MediaElement', '2012-12-21 08:45:37.153104', '2012-12-21 08:45:37.153104');
INSERT INTO bookmarks VALUES (33, 7, 110, 'MediaElement', '2012-12-21 09:24:45.952136', '2012-12-21 09:24:45.952136');
INSERT INTO bookmarks VALUES (34, 7, 116, 'MediaElement', '2012-12-21 09:30:30.926399', '2012-12-21 09:30:30.926399');
INSERT INTO bookmarks VALUES (35, 7, 1, 'MediaElement', '2012-12-21 09:33:20.485034', '2012-12-21 09:33:20.485034');
INSERT INTO bookmarks VALUES (36, 7, 5, 'MediaElement', '2012-12-21 09:33:32.317282', '2012-12-21 09:33:32.317282');
INSERT INTO bookmarks VALUES (37, 7, 56, 'MediaElement', '2012-12-21 09:33:41.650095', '2012-12-21 09:33:41.650095');
INSERT INTO bookmarks VALUES (38, 7, 15, 'MediaElement', '2012-12-21 09:33:46.182505', '2012-12-21 09:33:46.182505');
INSERT INTO bookmarks VALUES (39, 7, 16, 'MediaElement', '2012-12-21 09:33:50.541372', '2012-12-21 09:33:50.541372');
INSERT INTO bookmarks VALUES (40, 7, 40, 'MediaElement', '2012-12-21 09:34:27.427568', '2012-12-21 09:34:27.427568');
INSERT INTO bookmarks VALUES (41, 3, 78, 'MediaElement', '2012-12-21 09:35:37.665215', '2012-12-21 09:35:37.665215');
INSERT INTO bookmarks VALUES (42, 3, 77, 'MediaElement', '2012-12-21 09:35:37.718752', '2012-12-21 09:35:37.718752');
INSERT INTO bookmarks VALUES (43, 3, 112, 'MediaElement', '2012-12-21 09:35:37.77071', '2012-12-21 09:35:37.77071');
INSERT INTO bookmarks VALUES (44, 3, 115, 'MediaElement', '2012-12-21 09:35:37.821966', '2012-12-21 09:35:37.821966');
INSERT INTO bookmarks VALUES (45, 3, 99, 'MediaElement', '2012-12-21 09:35:37.872757', '2012-12-21 09:35:37.872757');
INSERT INTO bookmarks VALUES (46, 3, 80, 'MediaElement', '2012-12-21 09:35:37.924531', '2012-12-21 09:35:37.924531');
INSERT INTO bookmarks VALUES (47, 3, 83, 'MediaElement', '2012-12-21 09:35:37.988911', '2012-12-21 09:35:37.988911');
INSERT INTO bookmarks VALUES (48, 3, 113, 'MediaElement', '2012-12-21 09:35:38.041875', '2012-12-21 09:35:38.041875');
INSERT INTO bookmarks VALUES (49, 3, 88, 'MediaElement', '2012-12-21 09:35:38.173993', '2012-12-21 09:35:38.173993');
INSERT INTO bookmarks VALUES (50, 3, 109, 'MediaElement', '2012-12-21 09:35:38.224219', '2012-12-21 09:35:38.224219');
INSERT INTO bookmarks VALUES (51, 3, 108, 'MediaElement', '2012-12-21 09:35:38.276263', '2012-12-21 09:35:38.276263');
INSERT INTO bookmarks VALUES (52, 3, 111, 'MediaElement', '2012-12-21 09:35:38.326903', '2012-12-21 09:35:38.326903');
INSERT INTO bookmarks VALUES (53, 3, 81, 'MediaElement', '2012-12-21 09:35:38.379302', '2012-12-21 09:35:38.379302');
INSERT INTO bookmarks VALUES (54, 3, 100, 'MediaElement', '2012-12-21 09:35:38.530427', '2012-12-21 09:35:38.530427');
INSERT INTO bookmarks VALUES (55, 3, 79, 'MediaElement', '2012-12-21 09:35:38.582247', '2012-12-21 09:35:38.582247');
INSERT INTO bookmarks VALUES (56, 3, 86, 'MediaElement', '2012-12-21 09:35:38.632237', '2012-12-21 09:35:38.632237');
INSERT INTO bookmarks VALUES (57, 3, 114, 'MediaElement', '2012-12-21 09:35:38.686641', '2012-12-21 09:35:38.686641');
INSERT INTO bookmarks VALUES (58, 2, 5, 'Lesson', '2012-12-21 09:49:51.375456', '2012-12-21 09:49:51.375456');
INSERT INTO bookmarks VALUES (59, 2, 8, 'Lesson', '2012-12-21 09:50:47.308758', '2012-12-21 09:50:47.308758');
INSERT INTO bookmarks VALUES (60, 7, 53, 'MediaElement', '2012-12-21 11:24:54.843386', '2012-12-21 11:24:54.843386');
INSERT INTO bookmarks VALUES (61, 7, 18, 'MediaElement', '2012-12-21 11:24:58.15998', '2012-12-21 11:24:58.15998');
INSERT INTO bookmarks VALUES (62, 7, 167, 'MediaElement', '2012-12-21 11:39:10.737537', '2012-12-21 11:39:10.737537');
INSERT INTO bookmarks VALUES (64, 3, 153, 'MediaElement', '2012-12-21 13:11:57.557618', '2012-12-21 13:11:57.557618');
INSERT INTO bookmarks VALUES (65, 3, 154, 'MediaElement', '2012-12-21 13:11:57.611609', '2012-12-21 13:11:57.611609');
INSERT INTO bookmarks VALUES (66, 3, 161, 'MediaElement', '2012-12-21 13:11:57.74897', '2012-12-21 13:11:57.74897');
INSERT INTO bookmarks VALUES (67, 3, 166, 'MediaElement', '2012-12-21 13:11:57.804422', '2012-12-21 13:11:57.804422');
INSERT INTO bookmarks VALUES (68, 3, 172, 'MediaElement', '2012-12-21 13:11:57.910054', '2012-12-21 13:11:57.910054');
INSERT INTO bookmarks VALUES (69, 3, 173, 'MediaElement', '2012-12-21 13:11:57.959967', '2012-12-21 13:11:57.959967');
INSERT INTO bookmarks VALUES (70, 3, 170, 'MediaElement', '2012-12-21 13:11:58.017011', '2012-12-21 13:11:58.017011');
INSERT INTO bookmarks VALUES (71, 3, 169, 'MediaElement', '2012-12-21 13:11:58.076049', '2012-12-21 13:11:58.076049');
INSERT INTO bookmarks VALUES (72, 3, 150, 'MediaElement', '2012-12-21 13:11:58.148005', '2012-12-21 13:11:58.148005');
INSERT INTO bookmarks VALUES (73, 3, 151, 'MediaElement', '2012-12-21 13:11:58.210587', '2012-12-21 13:11:58.210587');
INSERT INTO bookmarks VALUES (74, 3, 162, 'MediaElement', '2012-12-21 13:11:58.341616', '2012-12-21 13:11:58.341616');
INSERT INTO bookmarks VALUES (75, 3, 152, 'MediaElement', '2012-12-21 13:11:58.404287', '2012-12-21 13:11:58.404287');
INSERT INTO bookmarks VALUES (76, 3, 168, 'MediaElement', '2012-12-21 13:11:58.459844', '2012-12-21 13:11:58.459844');
INSERT INTO bookmarks VALUES (77, 3, 155, 'MediaElement', '2012-12-21 13:11:58.512363', '2012-12-21 13:11:58.512363');
INSERT INTO bookmarks VALUES (78, 3, 174, 'MediaElement', '2012-12-21 13:11:58.566139', '2012-12-21 13:11:58.566139');
INSERT INTO bookmarks VALUES (79, 3, 175, 'MediaElement', '2012-12-21 13:11:58.623799', '2012-12-21 13:11:58.623799');
INSERT INTO bookmarks VALUES (80, 3, 156, 'MediaElement', '2012-12-21 13:11:58.677445', '2012-12-21 13:11:58.677445');
INSERT INTO bookmarks VALUES (81, 3, 149, 'MediaElement', '2012-12-21 13:11:58.730043', '2012-12-21 13:11:58.730043');
INSERT INTO bookmarks VALUES (82, 3, 164, 'MediaElement', '2012-12-21 13:11:58.85859', '2012-12-21 13:11:58.85859');
INSERT INTO bookmarks VALUES (83, 3, 178, 'MediaElement', '2012-12-21 13:11:58.913765', '2012-12-21 13:11:58.913765');
INSERT INTO bookmarks VALUES (84, 3, 165, 'MediaElement', '2012-12-21 13:11:58.96575', '2012-12-21 13:11:58.96575');
INSERT INTO bookmarks VALUES (85, 3, 158, 'MediaElement', '2012-12-21 13:11:59.023671', '2012-12-21 13:11:59.023671');
INSERT INTO bookmarks VALUES (86, 3, 177, 'MediaElement', '2012-12-21 13:11:59.079591', '2012-12-21 13:11:59.079591');
INSERT INTO bookmarks VALUES (87, 3, 163, 'MediaElement', '2012-12-21 13:11:59.137243', '2012-12-21 13:11:59.137243');
INSERT INTO bookmarks VALUES (88, 3, 122, 'MediaElement', '2012-12-21 13:12:03.908229', '2012-12-21 13:12:03.908229');
INSERT INTO bookmarks VALUES (89, 3, 140, 'MediaElement', '2012-12-21 13:12:03.964251', '2012-12-21 13:12:03.964251');
INSERT INTO bookmarks VALUES (90, 3, 120, 'MediaElement', '2012-12-21 13:12:04.103444', '2012-12-21 13:12:04.103444');
INSERT INTO bookmarks VALUES (91, 3, 139, 'MediaElement', '2012-12-21 13:12:04.161863', '2012-12-21 13:12:04.161863');
INSERT INTO bookmarks VALUES (92, 3, 130, 'MediaElement', '2012-12-21 13:12:04.232548', '2012-12-21 13:12:04.232548');
INSERT INTO bookmarks VALUES (93, 3, 142, 'MediaElement', '2012-12-21 13:12:04.298238', '2012-12-21 13:12:04.298238');
INSERT INTO bookmarks VALUES (94, 3, 132, 'MediaElement', '2012-12-21 13:12:04.367861', '2012-12-21 13:12:04.367861');
INSERT INTO bookmarks VALUES (95, 3, 133, 'MediaElement', '2012-12-21 13:12:04.444278', '2012-12-21 13:12:04.444278');
INSERT INTO bookmarks VALUES (96, 3, 124, 'MediaElement', '2012-12-21 13:12:04.506106', '2012-12-21 13:12:04.506106');
INSERT INTO bookmarks VALUES (97, 3, 135, 'MediaElement', '2012-12-21 13:12:04.595921', '2012-12-21 13:12:04.595921');
INSERT INTO bookmarks VALUES (98, 3, 128, 'MediaElement', '2012-12-21 13:12:04.727073', '2012-12-21 13:12:04.727073');
INSERT INTO bookmarks VALUES (99, 3, 131, 'MediaElement', '2012-12-21 13:12:04.791673', '2012-12-21 13:12:04.791673');
INSERT INTO bookmarks VALUES (100, 3, 127, 'MediaElement', '2012-12-21 13:12:04.844815', '2012-12-21 13:12:04.844815');
INSERT INTO bookmarks VALUES (101, 3, 123, 'MediaElement', '2012-12-21 13:12:04.9003', '2012-12-21 13:12:04.9003');
INSERT INTO bookmarks VALUES (102, 3, 141, 'MediaElement', '2012-12-21 13:12:04.959645', '2012-12-21 13:12:04.959645');
INSERT INTO bookmarks VALUES (103, 3, 137, 'MediaElement', '2012-12-21 13:12:05.016947', '2012-12-21 13:12:05.016947');
INSERT INTO bookmarks VALUES (104, 3, 147, 'MediaElement', '2012-12-21 13:12:05.084545', '2012-12-21 13:12:05.084545');
INSERT INTO bookmarks VALUES (105, 3, 134, 'MediaElement', '2012-12-21 13:12:05.143745', '2012-12-21 13:12:05.143745');
INSERT INTO bookmarks VALUES (106, 3, 138, 'MediaElement', '2012-12-21 13:12:05.269565', '2012-12-21 13:12:05.269565');
INSERT INTO bookmarks VALUES (107, 3, 129, 'MediaElement', '2012-12-21 13:12:05.325633', '2012-12-21 13:12:05.325633');
INSERT INTO bookmarks VALUES (108, 3, 125, 'MediaElement', '2012-12-21 13:12:05.384202', '2012-12-21 13:12:05.384202');
INSERT INTO bookmarks VALUES (109, 2, 118, 'MediaElement', '2012-12-21 14:49:43.25151', '2012-12-21 14:49:43.25151');
INSERT INTO bookmarks VALUES (110, 2, 119, 'MediaElement', '2012-12-21 14:49:43.307006', '2012-12-21 14:49:43.307006');
INSERT INTO bookmarks VALUES (111, 2, 136, 'MediaElement', '2012-12-21 14:49:43.362134', '2012-12-21 14:49:43.362134');
INSERT INTO bookmarks VALUES (112, 2, 126, 'MediaElement', '2012-12-21 14:49:43.416313', '2012-12-21 14:49:43.416313');
INSERT INTO bookmarks VALUES (113, 6, 68, 'MediaElement', '2012-12-21 14:50:12.099102', '2012-12-21 14:50:12.099102');
INSERT INTO bookmarks VALUES (114, 6, 71, 'MediaElement', '2012-12-21 14:50:12.188419', '2012-12-21 14:50:12.188419');
INSERT INTO bookmarks VALUES (115, 6, 69, 'MediaElement', '2012-12-21 14:50:12.237269', '2012-12-21 14:50:12.237269');
INSERT INTO bookmarks VALUES (116, 6, 66, 'MediaElement', '2012-12-21 14:50:12.288158', '2012-12-21 14:50:12.288158');
INSERT INTO bookmarks VALUES (117, 6, 70, 'MediaElement', '2012-12-21 14:50:12.334466', '2012-12-21 14:50:12.334466');
INSERT INTO bookmarks VALUES (118, 6, 72, 'MediaElement', '2012-12-21 14:50:12.426424', '2012-12-21 14:50:12.426424');
INSERT INTO bookmarks VALUES (119, 6, 65, 'MediaElement', '2012-12-21 14:50:12.473254', '2012-12-21 14:50:12.473254');
INSERT INTO bookmarks VALUES (120, 6, 67, 'MediaElement', '2012-12-21 14:50:12.518552', '2012-12-21 14:50:12.518552');
INSERT INTO bookmarks VALUES (121, 6, 74, 'MediaElement', '2012-12-21 14:50:12.624914', '2012-12-21 14:50:12.624914');
INSERT INTO bookmarks VALUES (122, 6, 76, 'MediaElement', '2012-12-21 14:50:12.677597', '2012-12-21 14:50:12.677597');
INSERT INTO bookmarks VALUES (123, 6, 73, 'MediaElement', '2012-12-21 14:50:12.771019', '2012-12-21 14:50:12.771019');
INSERT INTO bookmarks VALUES (124, 6, 75, 'MediaElement', '2012-12-21 14:50:12.816656', '2012-12-21 14:50:12.816656');
INSERT INTO bookmarks VALUES (129, 7, 144, 'MediaElement', '2012-12-21 18:35:26.317934', '2012-12-21 18:35:26.317934');
INSERT INTO bookmarks VALUES (130, 7, 145, 'MediaElement', '2012-12-21 18:35:35.129578', '2012-12-21 18:35:35.129578');
INSERT INTO bookmarks VALUES (132, 7, 9, 'Lesson', '2012-12-23 16:32:10.703729', '2012-12-23 16:32:10.703729');
INSERT INTO bookmarks VALUES (145, 7, 171, 'MediaElement', '2013-01-02 16:16:51.172943', '2013-01-02 16:16:51.172943');
INSERT INTO bookmarks VALUES (151, 7, 84, 'MediaElement', '2013-01-02 16:17:47.336435', '2013-01-02 16:17:47.336435');
INSERT INTO bookmarks VALUES (164, 8, 159, 'MediaElement', '2013-01-07 09:27:06.444562', '2013-01-07 09:27:06.444562');
INSERT INTO bookmarks VALUES (165, 8, 157, 'MediaElement', '2013-01-07 09:44:21.340464', '2013-01-07 09:44:21.340464');
INSERT INTO bookmarks VALUES (166, 8, 148, 'MediaElement', '2013-01-07 09:44:31.098992', '2013-01-07 09:44:31.098992');
INSERT INTO bookmarks VALUES (167, 3, 7, 'Lesson', '2013-01-07 10:01:40.232542', '2013-01-07 10:01:40.232542');
INSERT INTO bookmarks VALUES (180, 7, 2, 'Lesson', '2013-01-08 11:17:06.354869', '2013-01-08 11:17:06.354869');
INSERT INTO bookmarks VALUES (185, 5, 1, 'Lesson', '2013-01-09 11:20:22.609621', '2013-01-09 11:20:22.609621');
INSERT INTO bookmarks VALUES (190, 5, 12, 'Lesson', '2013-01-09 11:39:23.95058', '2013-01-09 11:39:23.95058');
INSERT INTO bookmarks VALUES (193, 5, 6, 'Lesson', '2013-01-09 11:39:49.269928', '2013-01-09 11:39:49.269928');
INSERT INTO bookmarks VALUES (196, 5, 3, 'Lesson', '2013-01-09 11:40:14.678122', '2013-01-09 11:40:14.678122');


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO subjects VALUES (1, 'Mathematics', '2012-12-20 10:31:31.4885', '2012-12-20 10:31:31.4885');
INSERT INTO subjects VALUES (2, 'Natural Sciences', '2012-12-20 10:31:31.502686', '2012-12-20 10:31:31.502686');
INSERT INTO subjects VALUES (3, 'Geography', '2012-12-20 10:31:31.508208', '2012-12-20 10:31:31.508208');
INSERT INTO subjects VALUES (4, 'History', '2012-12-20 10:31:31.514185', '2012-12-20 10:31:31.514185');
INSERT INTO subjects VALUES (5, 'Visive Arts', '2012-12-20 10:31:31.520219', '2012-12-20 10:31:31.520219');
INSERT INTO subjects VALUES (6, 'Music', '2012-12-20 10:31:31.526145', '2012-12-20 10:31:31.526145');
INSERT INTO subjects VALUES (7, 'Phisycal Education', '2012-12-20 10:31:31.532253', '2012-12-20 10:31:31.532253');
INSERT INTO subjects VALUES (8, 'Computer Science', '2012-12-20 10:31:31.538162', '2012-12-20 10:31:31.538162');
INSERT INTO subjects VALUES (9, 'Languages', '2012-12-20 10:31:31.544101', '2012-12-20 10:31:31.544101');
INSERT INTO subjects VALUES (10, 'Literature', '2012-12-20 10:31:31.550238', '2012-12-20 10:31:31.550238');
INSERT INTO subjects VALUES (11, 'Chemistry', '2012-12-20 10:31:31.55622', '2012-12-20 10:31:31.55622');


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO lessons VALUES (4, 7, 3, 3, 'The big apple', 'New York is the most populous city in the United States and the center of the New York Metropolitan Area, one of the most populous metropolitan areas in the world.', true, NULL, false, '2012-12-20 15:21:55.890031', '2012-12-20 16:18:30.573697', '44870738148570858524');
INSERT INTO lessons VALUES (3, 2, 2, 2, '2012 phenomenon', 'The 2012 phenomenon comprises a range of eschatological beliefs according to which cataclysmic or transformative events will occur on 21 December 2012', true, NULL, false, '2012-12-20 14:59:28.72369', '2012-12-20 16:35:13.292022', '52974534581267844894');
INSERT INTO lessons VALUES (6, 3, 3, 2, 'Egon Schiele', 'One of the major figurative painter of the early 20th century.', true, NULL, false, '2012-12-20 16:33:20.409091', '2012-12-21 09:35:37.607381', '66907608385189907260');
INSERT INTO lessons VALUES (8, 7, 3, 2, 'Every man for himself ...', 'A lesson to learn about the animal world.', true, NULL, false, '2012-12-21 09:32:36.45282', '2012-12-21 09:46:30.614992', '61261424691130502672');
INSERT INTO lessons VALUES (12, 3, 3, 11, 'Josef Koudelka', 'Josef Koudelka is a Czech photographer.', true, NULL, false, '2012-12-21 11:18:50.299214', '2012-12-21 13:11:57.424413', '71622718813711694885');
INSERT INTO lessons VALUES (9, 3, 3, 11, 'Sebastião Salgado', 'Sebastião Salgado (born February 8, 1944) is a Brazilian social documentary photographer and photojournalist.', true, NULL, false, '2012-12-21 09:37:04.747247', '2012-12-21 13:12:03.808942', '00524541867610368634');
INSERT INTO lessons VALUES (5, 7, 3, 5, 'Life is pop!', 'Pop art is an art movement that emerged in the mid 1950s in Britain and in the late 1950s in the United States.', true, NULL, false, '2012-12-20 16:23:57.759783', '2012-12-21 14:35:23.33996', '71207469104431787822');
INSERT INTO lessons VALUES (7, 2, 2, 2, 'Rene Magritte and his paintings', 'Rene Magritte was born in Lessines, in the province of Hainaut, in 1898, the eldest son of Leopold Magritte, who was a tailor and textile merchant, and Regina (nee Bertinchamps), a milliner until her marriage.', true, NULL, false, '2012-12-21 09:30:00.445907', '2012-12-21 14:49:43.177126', '31715540526392318602');
INSERT INTO lessons VALUES (1, 6, 1, 5, 'J.M.Basquiat-Plush safe he think..', 'Jean-Michel Basquiat, born in Brooklyn, New York after the death of his brother Max, was the second of four children of Matilda Andrades (July 28, 1934 – November 17, 2008) and Gerard Basquiat (born 1930).', true, NULL, false, '2012-12-20 13:42:17.750022', '2012-12-21 14:50:11.436702', '28939098499059098027');
INSERT INTO lessons VALUES (2, 6, 1, 10, 'Welcome in London', 'The etymology of London is uncertain. It is an ancient name and can be found in sources from the 2nd century. It is recorded c. 121 as Londinium, which points to Romano-British origin.', true, NULL, false, '2012-12-20 14:55:07.531111', '2012-12-21 14:50:12.563575', '50572365536783370711');
INSERT INTO lessons VALUES (14, 8, 1, 9, 'Chinese', 'it is ok', false, NULL, false, '2013-01-07 09:15:15.653534', '2013-01-07 09:15:15.653534', '13959958164025334817');
INSERT INTO lessons VALUES (15, 8, 1, 9, 'Chinese', 'it is ok', false, NULL, false, '2013-01-07 09:18:27.796183', '2013-01-07 09:18:27.796183', '07572333623608283600');
INSERT INTO lessons VALUES (16, 8, 1, 9, 'Chinese', 'it is ok', false, NULL, false, '2013-01-07 09:19:13.601777', '2013-01-07 09:19:13.601777', '15239086293687653752');
INSERT INTO lessons VALUES (17, 8, 1, 9, 'Chinese', 'it is ok', false, NULL, false, '2013-01-07 09:19:53.931296', '2013-01-07 09:19:53.931296', '33273250434887143499');
INSERT INTO lessons VALUES (19, 2, 2, 1, 'Lezione 1', 'description (max 280 characters)', false, NULL, false, '2013-01-07 09:57:04.138169', '2013-01-07 09:58:14.273133', '71530982926304548878');
INSERT INTO lessons VALUES (11, 7, 3, 1, 'Maths', 'The word mathematics comes from the Greek μάθημα (máthēma), which, in the ancient Greek language, means "what one learns", "what one gets to know", hence also "study" and "science", and in modern Greek just "lesson".', false, NULL, false, '2012-12-21 10:55:07.51656', '2013-01-08 11:26:03.040405', '57922812017564990427');
INSERT INTO lessons VALUES (20, 7, 3, 6, 'Lezione di prova', 'dkidjjehdjdhj edhjedhjehdje edhejdhe edhejhed edhjjed', false, NULL, false, '2013-01-08 11:29:35.990499', '2013-01-08 11:29:35.990499', '57235586725133425166');
INSERT INTO lessons VALUES (21, 1, 1, 11, 'weref', 'sdsfdsdfsdf,affa', false, NULL, false, '2013-01-09 09:57:44.937486', '2013-01-09 09:57:44.937486', '10328708033264712815');
INSERT INTO lessons VALUES (22, 5, 1, 5, 'J.M.Basquiat-Plush safe he think..', 'Jean-Michel Basquiat, born in Brooklyn, New York after the death of his brother Max, was the second of four children of Matilda Andrades (July 28, 1934 – November 17, 2008) and Gerard Basquiat (born 1930).', false, 1, false, '2013-01-09 11:20:37.813527', '2013-01-09 11:24:54.392315', '53962834489938627660');
INSERT INTO lessons VALUES (23, 7, 3, 5, 'Visive arts', 'A virtual journey into the history of the visual arts.', false, NULL, false, '2013-01-09 13:28:41.410447', '2013-01-09 13:28:41.410447', '85149039689945388679');


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO likes VALUES (1, 4, 2, '2012-12-20 16:46:38.384962', '2012-12-20 16:46:38.384962');
INSERT INTO likes VALUES (2, 7, 7, '2012-12-23 16:31:19.439015', '2012-12-23 16:31:19.439015');
INSERT INTO likes VALUES (3, 9, 7, '2012-12-23 16:32:03.65664', '2012-12-23 16:32:03.65664');
INSERT INTO likes VALUES (4, 6, 7, '2012-12-23 16:32:06.216654', '2012-12-23 16:32:06.216654');
INSERT INTO likes VALUES (5, 12, 7, '2012-12-23 16:32:08.777021', '2012-12-23 16:32:08.777021');
INSERT INTO likes VALUES (7, 1, 7, '2013-01-08 11:17:13.071144', '2013-01-08 11:17:13.071144');
INSERT INTO likes VALUES (8, 4, 5, '2013-01-09 11:42:17.697301', '2013-01-09 11:42:17.697301');


--
-- Data for Name: media_elements; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO media_elements VALUES (1, 5, 'A couple of donkeys', 'A nice picture. Two donkeys smiling!', 'Image', true, '2012-12-20 10:31:33.210616', '2012-12-20 10:31:33.340318', '2012-12-20 10:31:32.127534', 'asino.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 938
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (2, 2, 'Futuristic architecture', 'Between the end of the twentieth century and early twenty-first century, in the city of Valencia (Spain), several architectural and urban projects took place.', 'Image', true, '2012-12-20 10:31:33.839619', '2012-12-20 10:31:33.953498', '2012-12-20 10:31:29.127534', 'architettura.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1048
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (3, 6, 'Birds', 'Sea gulls are birds of medium size: a small sea gull measures around 30 centimeters (for a weight of 120 grams), while a big one can reah 75 centimeters (for 200 grams kilos).', 'Image', true, '2012-12-20 10:31:34.51263', '2012-12-20 10:31:34.630846', '2012-12-20 10:31:26.127534', 'uccelli.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (77, 3, 'Egon Schiele', 'Portrait', 'Image', true, '2012-12-20 16:19:35.649987', '2012-12-21 09:35:37.703624', '2012-12-21 09:35:37.599689', '936full-egon-schiele.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 893
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (4, 6, 'Traffic', 'A picture from New York City. The metropolitan area of ​​New York is located at the intersection of three states (New York, New Jersey and Connecticut).', 'Image', true, '2012-12-20 10:31:35.276062', '2012-12-20 10:31:35.412094', '2012-12-20 10:31:23.127534', 'city.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (5, 3, 'Iguana', 'A beautiful picture of an iguana. Iguanas are very similar to lizards, but bigger and slower.', 'Image', true, '2012-12-20 10:31:35.869471', '2012-12-20 10:31:35.968211', '2012-12-20 10:31:20.127534', 'rettile.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 937
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (6, 2, 'Wind', 'Wind power is the energy obtained from the wind. Today it is mostly converted into electricity by a wind farm, while in the past wind energy was directly used by a local factory.', 'Image', true, '2012-12-20 10:31:37.259323', '2012-12-20 10:31:37.360474', '2012-12-20 10:31:17.127534', 'energia_del_vento.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 938
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (7, 6, 'Love for art', 'Chuck Close (Snohomish County, July 5, 1940) is an American painter and photographer.', 'Image', true, '2012-12-20 10:31:37.934446', '2012-12-20 10:31:38.105615', '2012-12-20 10:31:14.127534', 'coppia.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (8, 2, 'Compact disk', 'The compact disc is composed of a disk of transparent polycarbonate, generally 12 centimeters in diameter, covered at the top by a thin sheet of metal material.', 'Image', true, '2012-12-20 10:31:38.487025', '2012-12-20 10:31:38.649239', '2012-12-20 10:31:11.127534', 'cd.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 939
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (9, 3, 'Flowers', 'A picture of nice colored flowers, to be used in any natural science lesson.', 'Image', true, '2012-12-20 10:31:39.13188', '2012-12-20 10:31:39.26762', '2012-12-20 10:31:08.127534', 'fiori.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 937
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (10, 4, 'Battery', 'A battery is a device consisting of one or more electrochemical cells that convert stored chemical energy into electrical energy.', 'Image', true, '2012-12-20 10:31:39.714573', '2012-12-20 10:31:39.790719', '2012-12-20 10:31:05.127534', 'batterie.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 930
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (11, 6, 'Pantheon', 'The Pantheon ("Temple of all gods") is an ancient building in the center of Rome.', 'Image', true, '2012-12-20 10:31:40.3825', '2012-12-20 10:31:40.5042', '2012-12-20 10:31:02.127534', 'cielo_roma.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 937
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (12, 7, 'Lawn', 'A picture of a winded lawn during spring.', 'Image', true, '2012-12-20 10:31:40.964294', '2012-12-20 10:31:41.03893', '2012-12-20 10:30:59.127534', 'natura.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 937
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (13, 3, 'History of the wood', 'The wood is a source of energy and cellulose.', 'Image', true, '2012-12-20 10:31:42.489941', '2012-12-20 10:31:42.599257', '2012-12-20 10:30:56.127534', 'ossigeno.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 937
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (14, 4, 'Rome', 'A beautiful picture of one of the most beautiful cities in the world. You can see the dome of St Peter, the cradle of Christian civilization.', 'Image', true, '2012-12-20 10:31:43.142856', '2012-12-20 10:31:43.264151', '2012-12-20 10:30:53.127534', 'roma.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 937
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (15, 5, 'Bees', 'Since prehistoric times, the bee has been useful to mankind.', 'Image', true, '2012-12-20 10:31:43.753988', '2012-12-20 10:31:43.847307', '2012-12-20 10:30:50.127534', 'ape.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 999
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (16, 5, 'A flying machine', 'Nature has provided birds with a perfect structure allowing them to fly.', 'Image', true, '2012-12-20 10:31:44.321867', '2012-12-20 10:31:44.41046', '2012-12-20 10:30:47.127534', 'uccello.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1014
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (17, 2, 'Natural gas', 'In nature, the gas is produced by the anaerobic decomposition of organic material.', 'Image', true, '2012-12-20 10:31:44.936366', '2012-12-20 10:31:45.029684', '2012-12-20 10:30:44.127534', 'fiamma.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 931
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (18, 2, 'Family', 'A mother uses the internet to help her child studying.', 'Image', true, '2012-12-20 10:31:45.501725', '2012-12-20 10:31:45.608081', '2012-12-20 10:30:41.127534', 'mamma_e_figlia.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 933
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (19, 7, 'Harlem', 'Harlem is a neighborhood of Manhattan in New York City, known as a major commercial and cultural center of Afro-Americans.', 'Image', true, '2012-12-20 10:31:46.174704', '2012-12-20 10:31:47.246971', '2012-12-20 10:30:38.127534', 'colored.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (20, 6, 'Modern architecture', 'The "Hemisfèric" is one of the buildings of "Ciutat de les Arts i les Ciències" in Valencia.', 'Image', true, '2012-12-20 10:31:47.71712', '2012-12-20 10:31:47.816707', '2012-12-20 10:30:35.127534', 'architettura_acqua.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 932
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (21, 2, 'Peacock', 'The plumage of these birds is one of the most colorful in the animal world.', 'Image', true, '2012-12-20 10:31:48.300628', '2012-12-20 10:31:48.443238', '2012-12-20 10:30:32.127534', 'pavone.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 938
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (22, 6, 'People', 'A group of interested visitors walking in the halls of a museum of modern art.', 'Image', true, '2012-12-20 10:31:48.96788', '2012-12-20 10:31:49.053281', '2012-12-20 10:30:29.127534', 'museo.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (23, 6, 'Money', 'As in a famous song of the Beatles, "That''s all I want".', 'Image', true, '2012-12-20 10:31:49.882418', '2012-12-20 10:31:49.962098', '2012-12-20 10:30:26.127534', 'dollari.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (24, 4, 'Airport', 'Heathrow Airport is the main airport in London.', 'Image', true, '2012-12-20 10:31:50.234812', '2012-12-20 10:31:50.387773', '2012-12-20 10:30:23.127534', 'london.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 946
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (25, 6, 'Underground', 'The London Underground is the largest subway system in Europe.', 'Image', true, '2012-12-20 10:31:51.292159', '2012-12-20 10:31:51.798086', '2012-12-20 10:30:20.127534', 'underground.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (26, 3, 'Plane', 'The Boeing 737 is the most widely used airliner for medium-short routes.', 'Image', true, '2012-12-20 10:31:52.657131', '2012-12-20 10:31:52.765095', '2012-12-20 10:30:17.127534', 'plane.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (55, 3, 'Behavior of liquids', 'A video about the behavior of liquids.', 'Video', true, '2012-12-20 10:32:08.992773', '2012-12-20 10:32:09.582865', '2012-12-20 10:30:46.127534', 'liquidi', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 27.58
  :webm_duration: 27.54
modifiable: true
', true);
INSERT INTO media_elements VALUES (27, 6, 'Statue of Liberty', 'Liberty Enlightening the World (lit. Liberty enlightening the world; fr. Éclairant La liberté le monde), more commonly known as the Statue of Liberty, is the symbol of New York.', 'Image', true, '2012-12-20 10:31:53.611599', '2012-12-20 10:31:53.692119', '2012-12-20 10:30:14.127534', 'liberty.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (181, 7, 'Titolo', 'Descrizione', 'Video', false, '2012-12-21 18:47:39.366856', '2012-12-21 18:47:39.366856', NULL, 'titolo', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 163.0
  :webm_duration: 163.0
modifiable: true
', true);
INSERT INTO media_elements VALUES (28, 6, 'A young woman', 'Portrait of a Muslim woman.', 'Image', true, '2012-12-20 10:31:54.493451', '2012-12-20 10:31:54.62499', '2012-12-20 10:30:11.127534', 'donna.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (29, 3, 'The Sphinx', 'The sphinx is a mythological figure belonging to Egyptian mythology.', 'Image', true, '2012-12-20 10:31:55.41208', '2012-12-20 10:31:55.496389', '2012-12-20 10:30:08.127534', 'statua.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (30, 6, 'A long bridge', 'A picture of a bridge.', 'Image', true, '2012-12-20 10:31:56.347616', '2012-12-20 10:31:56.809765', '2012-12-20 10:30:05.127534', 'ponte.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (31, 3, 'DNA', 'DNA is an organic polymer made ​​up of monomers called nucleotides (deoxyribonucleotides).', 'Image', true, '2012-12-20 10:31:57.23656', '2012-12-20 10:31:57.358639', '2012-12-20 10:30:02.127534', 'dna.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (32, 4, 'Solar system', 'The solar system consists of a variety of celestial bodies kept in orbit by the gravitational force of the Sun.', 'Image', true, '2012-12-20 10:31:57.789114', '2012-12-20 10:31:57.899218', '2012-12-20 10:29:59.127534', 'space.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 769
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (33, 2, 'What is energy?', 'The interview with an expert talking about energy (in italian language).', 'Audio', true, '2012-12-20 10:31:58.018277', '2012-12-20 10:31:58.161749', '2012-12-20 10:31:33.127534', 'energia_cosa', '--- !ruby/object:OpenStruct
table:
  :mp3_duration: 155.55
  :ogg_duration: 155.53
modifiable: true
', true);
INSERT INTO media_elements VALUES (44, 3, 'Let''s look inside us', 'A video about cells.', 'Video', true, '2012-12-20 10:32:02.4016', '2012-12-20 10:32:02.859198', '2012-12-20 10:31:19.127534', 'cellule', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 9.96
  :webm_duration: 9.96
modifiable: true
', true);
INSERT INTO media_elements VALUES (34, 3, 'Energy statistics in Italy', 'An interview with experts about italian use and production of energy (in italian language).', 'Audio', true, '2012-12-20 10:31:58.238649', '2012-12-20 10:31:58.385361', '2012-12-20 10:31:30.127534', 'energia_dati', '--- !ruby/object:OpenStruct
table:
  :mp3_duration: 194.35
  :ogg_duration: 194.32
modifiable: true
', true);
INSERT INTO media_elements VALUES (39, 3, 'Water', 'A video explaining scientific facts about water.', 'Video', true, '2012-12-20 10:31:59.627025', '2012-12-20 10:32:00.267773', '2012-12-20 10:31:34.127534', 'acqua', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 20.84
  :webm_duration: 20.8
modifiable: true
', true);
INSERT INTO media_elements VALUES (35, 4, 'Principles of modern energy', 'The principles of modern energy explained by experts (in italian language).', 'Audio', true, '2012-12-20 10:31:58.465388', '2012-12-20 10:31:58.650486', '2012-12-20 10:31:27.127534', 'energia_principi', '--- !ruby/object:OpenStruct
table:
  :mp3_duration: 149.6
  :ogg_duration: 149.57
modifiable: true
', true);
INSERT INTO media_elements VALUES (36, 5, 'Once upon a time the energy', 'The history of energy development in the twentieth century (in italian language).', 'Audio', true, '2012-12-20 10:31:58.731702', '2012-12-20 10:31:58.884237', '2012-12-20 10:31:24.127534', 'energia_storia', '--- !ruby/object:OpenStruct
table:
  :mp3_duration: 166.57999999999998
  :ogg_duration: 166.53
modifiable: true
', true);
INSERT INTO media_elements VALUES (37, 6, 'Digital sound', 'A good base of digital music to be used in your video.', 'Audio', true, '2012-12-20 10:31:58.964683', '2012-12-20 10:31:59.139067', '2012-12-20 10:31:21.127534', 'archangel', '--- !ruby/object:OpenStruct
table:
  :mp3_duration: 238.49
  :ogg_duration: 238.46
modifiable: true
', true);
INSERT INTO media_elements VALUES (40, 2, 'The life of bees', 'A very nice and interesting movie about bees.', 'Video', true, '2012-12-20 10:32:00.355851', '2012-12-20 10:32:00.730891', '2012-12-20 10:31:31.127534', 'ape_su_fiori', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 7.06
  :webm_duration: 7.06
modifiable: true
', true);
INSERT INTO media_elements VALUES (38, 7, 'Modern digital sound', 'A good base of digital music to be used in your video.', 'Audio', true, '2012-12-20 10:31:59.220063', '2012-12-20 10:31:59.396247', '2012-12-20 10:31:18.127534', 'homeless', '--- !ruby/object:OpenStruct
table:
  :mp3_duration: 320.62
  :ogg_duration: 320.58
modifiable: true
', true);
INSERT INTO media_elements VALUES (41, 4, 'The structure of the atoms', 'Atoms are made by protons, neutrons and electrons.', 'Video', true, '2012-12-20 10:32:00.804586', '2012-12-20 10:32:01.121643', '2012-12-20 10:31:28.127534', 'atomo', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 10.0
  :webm_duration: 10.03
modifiable: true
', true);
INSERT INTO media_elements VALUES (45, 7, 'A chemical experiment', 'Chemistry is the science, which studies the composition of matter.', 'Video', true, '2012-12-20 10:32:03.008314', '2012-12-20 10:32:03.447298', '2012-12-20 10:31:16.127534', 'chimica', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 9.56
  :webm_duration: 9.56
modifiable: true
', true);
INSERT INTO media_elements VALUES (42, 5, 'Bacteria seen under a microscope', 'Bacteria include unicellular microorganisms and prokaryotes.', 'Video', true, '2012-12-20 10:32:01.200256', '2012-12-20 10:32:01.679645', '2012-12-20 10:31:25.127534', 'batteri', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 10.23
  :webm_duration: 10.23
modifiable: true
', true);
INSERT INTO media_elements VALUES (43, 5, 'Structure of the cell', 'The cell is the smallest structure that might bt classified as living.', 'Video', true, '2012-12-20 10:32:01.788167', '2012-12-20 10:32:02.28022', '2012-12-20 10:31:22.127534', 'catena_cellulare', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 11.6
  :webm_duration: 11.6
modifiable: true
', true);
INSERT INTO media_elements VALUES (48, 7, 'The biggest star', 'The Sun is the parent star of the solar system.', 'Video', true, '2012-12-20 10:32:04.720251', '2012-12-20 10:32:05.132924', '2012-12-20 10:31:07.127534', 'energia', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 10.04
  :webm_duration: 10.04
modifiable: true
', true);
INSERT INTO media_elements VALUES (46, 4, 'Interesting chemical experiment', 'A video about an interesting chemical experiment.', 'Video', true, '2012-12-20 10:32:03.553414', '2012-12-20 10:32:04.012298', '2012-12-20 10:31:13.127534', 'chimica2', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 16.92
  :webm_duration: 16.92
modifiable: true
', true);
INSERT INTO media_elements VALUES (50, 3, 'Discover the liquids', 'Ionic liquids are chemical compounds consisting exclusively of ions.', 'Video', true, '2012-12-20 10:32:05.949628', '2012-12-20 10:32:06.426173', '2012-12-20 10:31:01.127534', 'esperimento', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 15.0
  :webm_duration: 15.03
modifiable: true
', true);
INSERT INTO media_elements VALUES (47, 6, 'The future comes from the sun', 'Solar energy is the energy which makes life possible on the earth.', 'Video', true, '2012-12-20 10:32:04.142178', '2012-12-20 10:32:04.557732', '2012-12-20 10:31:10.127534', 'energia_solare', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 10.13
  :webm_duration: 10.13
modifiable: true
', true);
INSERT INTO media_elements VALUES (49, 2, 'A chemical experiment about liquids', 'The liquid is one of the states of matter.', 'Video', true, '2012-12-20 10:32:05.236107', '2012-12-20 10:32:05.857054', '2012-12-20 10:31:04.127534', 'esperimento_acqua', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 24.37
  :webm_duration: 24.37
modifiable: true
', true);
INSERT INTO media_elements VALUES (51, 6, 'Inside mathematics', 'Mathematics has a long tradition.', 'Video', true, '2012-12-20 10:32:06.574626', '2012-12-20 10:32:07.014745', '2012-12-20 10:30:58.127534', 'formule', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 9.93
  :webm_duration: 9.93
modifiable: true
', true);
INSERT INTO media_elements VALUES (52, 6, 'Descriptive geometry', 'A video about descriptive geometry.', 'Video', true, '2012-12-20 10:32:07.124049', '2012-12-20 10:32:07.671098', '2012-12-20 10:30:55.127534', 'geometria', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 14.03
  :webm_duration: 14.03
modifiable: true
', true);
INSERT INTO media_elements VALUES (53, 4, 'The triangle', 'In geometry, the triangle is a polygon formed by three corners or vertices and three sides.', 'Video', true, '2012-12-20 10:32:07.777333', '2012-12-20 10:32:08.376391', '2012-12-20 10:30:52.127534', 'geometria2', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 14.03
  :webm_duration: 14.03
modifiable: true
', true);
INSERT INTO media_elements VALUES (54, 2, 'Chemical lab', 'Two researchers working in a chemical lab.', 'Video', true, '2012-12-20 10:32:08.482854', '2012-12-20 10:32:08.880904', '2012-12-20 10:30:49.127534', 'laboratorio', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 14.62
  :webm_duration: 14.62
modifiable: true
', true);
INSERT INTO media_elements VALUES (56, 6, 'Snail', 'The snail is not always gray.', 'Video', true, '2012-12-20 10:32:09.70151', '2012-12-20 10:32:10.290921', '2012-12-20 10:30:43.127534', 'lumaca', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 28.44
  :webm_duration: 28.44
modifiable: true
', true);
INSERT INTO media_elements VALUES (68, 6, 'J.M.Basquiat - 50Cent', 'In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO.', 'Image', true, '2012-12-20 13:35:47.077821', '2012-12-21 14:50:12.042497', '2012-12-21 14:50:11.170362', '50-cent-piece.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1044
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (57, 5, 'On the footsteps of Titanic', 'The Titanic sank in the beginning of twentieth century in the Atlantic Ocean.', 'Video', true, '2012-12-20 10:32:10.440854', '2012-12-20 10:32:10.987934', '2012-12-20 10:30:40.127534', 'mare', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 19.2
  :webm_duration: 19.2
modifiable: true
', true);
INSERT INTO media_elements VALUES (58, 6, 'Wind Energy', 'Wind energy is the energy obtained from the wind.', 'Video', true, '2012-12-20 10:32:11.10618', '2012-12-20 10:32:11.486809', '2012-12-20 10:30:37.127534', 'paleeoliche', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 8.7
  :webm_duration: 8.7
modifiable: true
', true);
INSERT INTO media_elements VALUES (59, 4, 'How does a real chemistry lab work?', 'We enter into a research center.', 'Video', true, '2012-12-20 10:32:11.592891', '2012-12-20 10:32:12.22945', '2012-12-20 10:30:34.127534', 'ricercatori', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 30.87
  :webm_duration: 30.91
modifiable: true
', true);
INSERT INTO media_elements VALUES (60, 4, 'The birth of a star', 'A star is a celestial body that shines with its own light.', 'Video', true, '2012-12-20 10:32:12.335476', '2012-12-20 10:32:12.929889', '2012-12-20 10:30:31.127534', 'sole', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 15.0
  :webm_duration: 15.0
modifiable: true
', true);
INSERT INTO media_elements VALUES (61, 6, 'Little scientists', 'A high school class try simple chemistry experiments.', 'Video', true, '2012-12-20 10:32:13.03201', '2012-12-20 10:32:13.639582', '2012-12-20 10:30:28.127534', 'studenti', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 26.41
  :webm_duration: 26.41
modifiable: true
', true);
INSERT INTO media_elements VALUES (62, 2, 'Look at the virus closely', 'Viruses are biological entities.', 'Video', true, '2012-12-20 10:32:13.734812', '2012-12-20 10:32:14.141993', '2012-12-20 10:30:25.127534', 'virus', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 10.3
  :webm_duration: 10.3
modifiable: true
', true);
INSERT INTO media_elements VALUES (71, 6, 'J.M.Basquiat', 'In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO.', 'Image', true, '2012-12-20 13:38:54.78319', '2012-12-21 14:50:12.172335', '2012-12-21 14:50:11.170362', 'tumblr_ma02thv8vk1qzp5xxo1_500.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 926
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (69, 6, 'J.M.Basquiat - King', 'In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO.', 'Image', true, '2012-12-20 13:36:55.045187', '2012-12-21 14:50:12.223111', '2012-12-21 14:50:11.170362', 'king-alphonso.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1055
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (74, 6, 'London', 'The London Eye is a giant Ferris wheel situated on the banks of the River Thames in London, England. The entire structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft).', 'Image', true, '2012-12-20 14:28:12.828114', '2012-12-21 14:50:12.610994', '2012-12-21 14:50:12.55499', 'london.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 934
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (76, 6, 'Duffy', 'Stephen Anthony James Duffy (born 30 May 1960, Alum Rock, Birmingham, England) is an English singer/songwriter, and multi-instrumentalist.', 'Image', true, '2012-12-20 14:45:44.869248', '2012-12-21 14:50:12.664462', '2012-12-21 14:50:12.55499', 'duffy.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (73, 6, 'London taxy', 'The famous london taxi', 'Image', true, '2012-12-20 14:26:18.699784', '2012-12-21 14:50:12.755895', '2012-12-21 14:50:12.55499', 'taxi_1360265b.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 876
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (75, 6, 'The weather in London', 'The etymology of London is uncertain.
It is an ancient name and can be found in sources from the 2nd century.', 'Image', true, '2012-12-20 14:33:10.862907', '2012-12-21 14:50:12.803597', '2012-12-21 14:50:12.55499', 'london1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (84, 3, 'Egon Schiele', 'Two girls embracing each other', 'Image', true, '2012-12-20 16:28:21.704158', '2012-12-21 17:00:41.437299', '2012-12-21 17:00:41.154427', 'egon_schiele_022.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 931
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (82, 2, 'calendar', 'The 2012 phenomenon comprises a range of', 'Image', true, '2012-12-20 16:27:00.496132', '2012-12-20 16:35:13.469994', '2012-12-20 16:35:13.284518', 'nmai-mayan-calendar.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 930
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (105, 2, 'maya', 'sdlò ds', 'Image', true, '2012-12-21 08:41:02.772807', '2012-12-21 08:43:27.103263', '2012-12-21 08:43:27.07129', 'jeu_de_balle_maya.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (80, 3, 'Arthut Roessler', 'Egon Schiele', 'Image', true, '2012-12-20 16:25:30.285724', '2012-12-21 09:35:37.909922', '2012-12-21 09:35:37.599689', 'arthur-roessler-egon-schiele.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1395
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (67, 6, 'SAMO', 'Jean-Michel Basquiat, born in Brooklyn, New York after the death of his brother Max, was the second of four children of Matilda Andrades (July 28, 1934 – November 17, 2008) and Gerard Basquiat (born 1930).', 'Image', true, '2012-12-20 13:33:22.979454', '2012-12-21 14:50:12.504391', '2012-12-21 14:50:11.170362', '1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1038
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (87, 7, ' Roy Lichtenstein', 'His work probably defines the basic premise of pop art better than any other through parody.[7] Selecting the old-fashioned comic strip as subject matter, Lichtenstein produces a hard-edged, precise composition that documents while it parodies in a soft manner.', 'Image', true, '2012-12-20 16:30:23.111774', '2012-12-21 17:00:41.512692', '2012-12-21 17:00:41.479261', '02.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 984
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (90, 2, 'Pleiades', 'Beautiful stars.', 'Image', true, '2012-12-20 16:33:59.291888', '2012-12-21 14:48:13.133778', '2012-12-21 14:48:10.021677', 'pleiades_large.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1009
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (66, 6, 'Basquiat', 'Jean-Michel Basquiat (December 22, 1960 – August 12, 1988) was an American artist.[1] He began as an obscure graffiti artist in New York City in the late 1970s and evolved into an acclaimed Neo-expressionist and Primitivist painter by the 1980s.', 'Image', true, '2012-12-20 13:21:50.994318', '2012-12-21 14:50:12.27521', '2012-12-21 14:50:11.170362', 'basquiat.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1195
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (70, 6, 'J.M.Basquiat - Ghost', 'In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO.', 'Image', true, '2012-12-20 13:37:53.215789', '2012-12-21 14:50:12.320632', '2012-12-21 14:50:11.170362', 'tumblr_mapa1vnds61rhpgvfo1_500.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 879
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (72, 6, 'J.M.Basquiat in New York', 'In 1976, Basquiat and friend Al Diaz began spray-painting graffiti on buildings in Lower Manhattan, working under the pseudonym SAMO.', 'Image', true, '2012-12-20 13:39:58.37727', '2012-12-21 14:50:12.411118', '2012-12-21 14:50:11.170362', 'tumblr_m79phdivez1rwgohco1_r1_500.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 898
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (65, 6, 'Jean Michelle', 'Jean-Michel Basquiat (December 22, 1960 – August 12, 1988) was an American artist.[1] He began as an obscure graffiti artist in New York City in the late 1970s and evolved into an acclaimed Neo-expressionist and Primitivist painter by the 1980s.', 'Image', true, '2012-12-20 13:20:09.704694', '2012-12-21 14:50:12.459892', '2012-12-21 14:50:11.170362', 'basquiat-2.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1392
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (85, 7, 'Warhol - Merilyn', 'Although Pop Art began in the late 1950s, Pop Art in America was given its greatest impetus during the 1960s.', 'Image', true, '2012-12-20 16:28:35.849565', '2012-12-21 17:00:41.600119', '2012-12-21 17:00:41.530187', '01.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1395
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (92, 7, 'Velvet Underground', 'Velvet Underground album cover by Andy Warhol', 'Image', true, '2012-12-20 16:35:44.204151', '2012-12-21 17:00:41.648123', '2012-12-21 17:00:41.61719', '08.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1387
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (182, 7, 'Misfits', 'A picture of Misfits', 'Image', false, '2012-12-23 16:25:35.789304', '2012-12-23 16:25:35.789304', NULL, '196485_1845935023976_1108658735_32169660_1007660_n.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 840
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (183, 7, 'Dexter', 'A picture of Dexter', 'Image', false, '2012-12-23 16:27:02.255677', '2012-12-23 16:27:02.255677', NULL, 'dexter-tv-series-1920x1080-wallpaper-542.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 788
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (89, 7, 'Andy Warhol - Portrait', 'Andy Warhol (August 6, 1928 – February 22, 1987)', 'Image', true, '2012-12-20 16:32:57.552282', '2012-12-20 17:13:31.850825', '2012-12-20 17:13:31.794902', '04.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (97, 7, 'Mimmo Rotella', 'Domenico "Mimmo" Rotella
(7 October 1918 – 8 January 2006), was an Italian artist and poet best known for his works of décollage and psychogeographics, made from torn advertising posters. Rotella was born in Catanzaro, Calabria.', 'Image', true, '2012-12-20 16:42:06.260653', '2012-12-20 17:13:31.918088', '2012-12-20 17:13:31.794902', '14.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1107
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (91, 7, 'Warhol', 'Andy Warhol (August 6, 1928 – February 22, 1987)', 'Image', true, '2012-12-20 16:34:00.425492', '2012-12-20 17:13:31.969742', '2012-12-20 17:13:31.794902', '05.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 912
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (93, 7, 'Keith Haring', 'Keith Haring (May 4, 1958 – February 16, 1990)', 'Image', true, '2012-12-20 16:38:23.492073', '2012-12-20 17:13:32.150153', '2012-12-20 17:13:31.794902', '10.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (96, 7, 'Keith Haring - Yes', 'Keith Haring (May 4, 1958 – February 16, 1990)', 'Image', true, '2012-12-20 16:40:29.784883', '2012-12-20 17:13:32.265933', '2012-12-20 17:13:31.794902', '11.png', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 463
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (101, 7, 'Mario Schifano - Coca Cola', 'Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy ) was an Italian painter and collagist of the Postmodern tradition. He also achieved some renown as a film-maker and rock musician.', 'Image', true, '2012-12-20 16:49:32.541514', '2012-12-20 17:13:32.322412', '2012-12-20 17:13:31.794902', '16.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1359
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (98, 7, 'Mario Schifano - Bicicletta', 'Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy ) was an Italian painter and collagist of the Postmodern tradition. He also achieved some renown as a film-maker and rock musician.', 'Image', true, '2012-12-20 16:44:03.710186', '2012-12-20 17:13:32.375373', '2012-12-20 17:13:31.794902', '17.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 928
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (102, 7, 'Mario Schifano', 'Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy )', 'Image', true, '2012-12-20 16:50:32.119709', '2012-12-20 17:13:32.427058', '2012-12-20 17:13:31.794902', 'schifano.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1008
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (95, 2, 'Angry Maya Statue', 'Many similar busts were used as architectural embellishments on Structure 22 at Copán. ', 'Image', true, '2012-12-20 16:39:39.780023', '2012-12-21 08:11:25.387135', '2012-12-21 08:11:25.353264', 'angry_maya_statue.JPG', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (186, 8, 'chiinese', 'it is ok', 'Image', false, '2013-01-07 09:46:06.122839', '2013-01-07 09:46:06.122839', NULL, 'chiinese-edit-20130107-104605.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 914
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (104, 2, 'Temple', 'temple', 'Image', true, '2012-12-21 08:39:08.416489', '2012-12-21 08:39:40.418264', '2012-12-21 08:39:40.38566', 'maya_profezia.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (99, 3, 'Academy of Fine Arts Vienna', 'The Academy of Fine Arts Vienna (German: Akademie der bildenden Künste Wien) is a public art school of higher education in Vienna, Austria.', 'Image', true, '2012-12-20 16:44:24.820214', '2012-12-21 09:35:37.85824', '2012-12-21 09:35:37.599689', '450px-akadbildkwien.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1050
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (88, 3, 'Egon Schiele', 'Nude', 'Image', true, '2012-12-20 16:30:58.973362', '2012-12-21 09:35:38.158498', '2012-12-21 09:35:37.599689', 'egon_schiele_095_obnp2009-y088361.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 953
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (100, 3, 'Gustav Klimt', 'The kiss (1907-08)', 'Image', true, '2012-12-20 16:48:26.708232', '2012-12-21 09:35:38.515363', '2012-12-21 09:35:37.599689', 'gustav_klimt_016.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1399
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (106, 2, 'Maize', 'Tonsured Maize God as a patron of the scribal arts, Classic period', 'Image', true, '2012-12-21 08:42:46.383447', '2012-12-21 08:43:27.163109', '2012-12-21 08:43:27.128567', 'maize_god_l.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (118, 2, 'Golconda', 'painting', 'Image', true, '2012-12-21 09:34:34.990964', '2012-12-21 14:49:43.221136', '2012-12-21 14:49:43.169187', 'golconda-magritte.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (107, 2, 'Elephant', 'description (max 280 characters)', 'Image', true, '2012-12-21 08:45:03.993454', '2012-12-21 08:45:37.137964', '2012-12-21 08:45:37.105372', 'elephant-edit-20121221-094503.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1386
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (119, 2, 'The son of man', 'Beautiful, original hand-painted artwork in your home. ', 'Image', true, '2012-12-21 09:37:53.937727', '2012-12-21 14:49:43.290961', '2012-12-21 14:49:43.169187', 'the-son-of-man-by-ren_-magritte-636544.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1074
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (136, 2, 'Les amants', 'people with cloth obscuring their faces', 'Image', true, '2012-12-21 09:45:58.389548', '2012-12-21 14:49:43.34673', '2012-12-21 14:49:43.169187', '04-rene-magritte-the-lovers-1928.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (126, 2, 'Rene Magritte', 'Photo Magritte', 'Image', true, '2012-12-21 09:41:44.30063', '2012-12-21 14:49:43.401324', '2012-12-21 14:49:43.169187', 'rene_magritte.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 999
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (121, 2, 'The listening room', 'Rene Magritte', 'Image', true, '2012-12-21 09:39:27.787576', '2012-12-21 17:00:41.69158', '2012-12-21 17:00:41.661839', 'tumblr_md1f37odrk1qiv63po1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1159
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (110, 7, 'Keith Haring  -  Paint', 'Keith Haring (Reading, 4 maggio 1958 – New York, 16 febbraio 1990)', 'Image', true, '2012-12-21 09:22:39.751312', '2012-12-21 09:24:45.935852', '2012-12-21 09:24:45.901403', 'tseng-kwong-chi-bill-t-jones-and-keith-haring.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1267
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (189, 7, 'Woman', 'A photo of a blond woman', 'Image', false, '2013-01-09 09:25:05.621929', '2013-01-09 09:25:05.621929', NULL, 'istock_000021779385xxxlarge.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 933
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (190, 1, 'volto', 'fisica', 'Image', false, '2013-01-09 10:21:46.829232', '2013-01-09 10:21:46.829232', NULL, 'einstein_photo.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 830
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (116, 7, 'Mimmo Rotella', 'Domenico "Mimmo" Rotella, (7 October 1918 – 8 January 2006)', 'Image', true, '2012-12-21 09:29:58.807014', '2012-12-21 09:30:30.910349', '2012-12-21 09:30:30.875251', 'rotella.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (192, 5, 'renna', 'renna natalizia', 'Image', false, '2013-01-09 10:46:47.921242', '2013-01-09 10:46:47.921242', NULL, 'img_0005.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1050
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (78, 3, 'Egon Schiele self-portrait', 'Selbstporträt mit Lampionfrüchten, 1912', 'Image', true, '2012-12-20 16:22:19.300234', '2012-12-21 09:35:37.650219', '2012-12-21 09:35:37.599689', 'schiele1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1127
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (112, 3, 'Egon Schiele', 'Self', 'Image', true, '2012-12-21 09:23:38.176228', '2012-12-21 09:35:37.756132', '2012-12-21 09:35:37.599689', 'schieleselfshirt.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 965
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (115, 3, 'Egon Schiele', 'Self-portrait', 'Image', true, '2012-12-21 09:25:44.181343', '2012-12-21 09:35:37.806536', '2012-12-21 09:35:37.599689', 'schiele_05.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (83, 3, 'Egon Schiele', 'Nude of woman', 'Image', true, '2012-12-20 16:27:10.752525', '2012-12-21 09:35:37.974378', '2012-12-21 09:35:37.599689', 'egon_schiele-bilbao-guggenheim.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 872
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (113, 3, 'Egon Schiele', 'Die kleine Stadt II, 1912–1913.', 'Image', true, '2012-12-21 09:24:32.05716', '2012-12-21 09:35:38.026897', '2012-12-21 09:35:37.599689', '763px-egon_schiele_015.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1391
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (109, 3, 'Egon Schiele, Friendship, 1913', 'Egon Schiele, Friendship, 1913', 'Image', true, '2012-12-21 09:20:24.837256', '2012-12-21 09:35:38.209988', '2012-12-21 09:35:37.599689', 'schiele_-_freundschaft_-_1913.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 933
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (108, 3, 'Seated woman with bent knee, 1917', 'Seated woman with bent knee, 1917', 'Image', true, '2012-12-21 09:19:02.435655', '2012-12-21 09:35:38.261881', '2012-12-21 09:35:37.599689', '518px-egon_schiele_-_sitzende_frau_mit_hochgezogenem_knie_-_1917.jpeg', '--- !ruby/object:OpenStruct
table:
  :width: 944
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (111, 3, 'Egon Schiele', 'Reserve infantry corporal, 1916', 'Image', true, '2012-12-21 09:22:46.409301', '2012-12-21 09:35:38.312442', '2012-12-21 09:35:37.599689', 'egon_schiele_024.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 906
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (81, 3, 'Egon Schiele', 'Nude of woman', 'Image', true, '2012-12-20 16:26:22.931578', '2012-12-21 09:35:38.365317', '2012-12-21 09:35:37.599689', 'egon_schiele_2.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 985
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (79, 3, 'Egon Schiele, Mime van Osen', 'Egon Schiele, Mime van Osen mit aneinandergelegten Fingerspitzen', 'Image', true, '2012-12-20 16:24:45.662846', '2012-12-21 09:35:38.567398', '2012-12-21 09:35:37.599689', '9916_0dda.jpeg', '--- !ruby/object:OpenStruct
table:
  :width: 1087
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (86, 3, 'Egon Schiele', 'Männlicher Akt mit rotem Tuch', 'Image', true, '2012-12-20 16:29:45.171897', '2012-12-21 09:35:38.618061', '2012-12-21 09:35:37.599689', 'egon_schiele_046.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 848
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (114, 3, 'Egon Schiele', 'House with Shingles, 1915', 'Image', true, '2012-12-21 09:25:07.739509', '2012-12-21 09:35:38.672322', '2012-12-21 09:35:37.599689', 'house_with_shingles_egon_schiele_1915.jpeg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1077
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (191, 5, 'rolex daytona', 'rolex daytona nero pdv', 'Image', false, '2013-01-09 10:45:21.857171', '2013-01-09 11:06:10.870384', NULL, 'titlemax35characters-edit-20130109-120610.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1050
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (180, 4, 'ape sui fiori', 'un''ape sui fiori', 'Video', true, '2012-12-21 15:50:33.597626', '2012-12-21 17:00:41.895013', '2012-12-21 17:00:41.707098', 'ape-su-fiori', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 7.06
  :webm_duration: 7.06
modifiable: true
', true);
INSERT INTO media_elements VALUES (143, 3, 'Salgado', 'Terra', 'Image', true, '2012-12-21 10:31:24.772354', '2012-12-21 17:00:41.941666', '2012-12-21 17:00:41.911427', 'salgado__sebasti_o-_terra_-_p-_58.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 939
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (144, 3, 'Salgado', 'Sebastiao Salgado', 'Image', true, '2012-12-21 10:35:45.488721', '2012-12-21 17:00:42.030261', '2012-12-21 17:00:41.955924', 'dsc06605.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1050
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (145, 3, 'Salgado', 'Alaska', 'Image', true, '2012-12-21 10:40:32.78523', '2012-12-21 17:00:42.144784', '2012-12-21 17:00:42.045933', 'screen-shot-2011-02-26-at-8-13-42-pm.png', '--- !ruby/object:OpenStruct
table:
  :width: 914
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (146, 3, 'Salgado', 'Alaska', 'Image', true, '2012-12-21 10:41:10.972149', '2012-12-21 17:00:42.192515', '2012-12-21 17:00:42.159968', 'sebastiao-salgado-2.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1295
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (148, 3, 'Koudelka', 'Romania', 'Image', true, '2012-12-21 10:59:59.969339', '2012-12-21 17:00:42.283285', '2012-12-21 17:00:42.207936', '1-_josef_koudelka__romania__1968.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 902
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (157, 3, 'Koudelka', 'Untitled', 'Image', true, '2012-12-21 11:09:30.730951', '2012-12-21 17:00:42.329141', '2012-12-21 17:00:42.297982', 'tumblr_mccbdmm8nh1r69p0no1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 933
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (159, 3, 'Koudelka', 'Boemia', 'Image', true, '2012-12-21 11:12:48.958338', '2012-12-21 17:00:42.373794', '2012-12-21 17:00:42.343186', 'josef_koudelka-298.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 914
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (160, 3, 'Koudelka', 'Birds', 'Image', true, '2012-12-21 11:13:13.410326', '2012-12-21 17:00:42.527094', '2012-12-21 17:00:42.387948', '1rcl.png', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 921
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (171, 3, 'Koudelka', 'Praga 1968', 'Image', true, '2012-12-21 11:28:07.250446', '2012-12-21 17:00:42.574622', '2012-12-21 17:00:42.543976', '4926885965_412f79a56f_z.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 521
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (187, 1, 'sun', 'sun flare', 'Video', false, '2013-01-07 10:33:22.016275', '2013-01-09 10:20:48.338222', NULL, 'sun', '--- !ruby/object:OpenStruct
table:
  :mp4_duration: 34.04
  :webm_duration: 34.0
modifiable: true
', true);
INSERT INTO media_elements VALUES (153, 3, 'Koudelka', 'Untitled', 'Image', true, '2012-12-21 11:03:48.269494', '2012-12-21 13:11:57.529658', '2012-12-21 13:11:57.344296', 'koudelka_intersection.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 918
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (154, 3, 'Koudelka', 'Gypsies', 'Image', true, '2012-12-21 11:08:20.494945', '2012-12-21 13:11:57.597331', '2012-12-21 13:11:57.344296', 'gypsies_5.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 928
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (161, 3, 'Koudelka', 'Koudelka', 'Image', true, '2012-12-21 11:13:37.212499', '2012-12-21 13:11:57.73413', '2012-12-21 13:11:57.344296', 'c0004293_1224759.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 905
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (173, 3, 'Koudelka', 'Praga', 'Image', true, '2012-12-21 11:28:42.325103', '2012-12-21 13:11:57.946086', '2012-12-21 13:11:57.344296', 'praga.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 912
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (140, 3, 'Sebastiao Salgado', 'Portrait', 'Image', true, '2012-12-21 09:51:58.769545', '2012-12-21 13:12:03.950433', '2012-12-21 13:12:03.801115', 'portrait_292.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 933
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (139, 3, 'Salgado', 'Untitled', 'Image', true, '2012-12-21 09:46:51.917308', '2012-12-21 13:12:04.147199', '2012-12-21 13:12:03.801115', 'image2.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 954
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (142, 3, 'Salgado', 'Nature', 'Image', true, '2012-12-21 10:09:11.80356', '2012-12-21 13:12:04.284151', '2012-12-21 13:12:03.801115', 'salgado-alaska.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1024
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (141, 3, 'Salgado', 'India', 'Image', true, '2012-12-21 09:52:41.773253', '2012-12-21 13:12:04.945552', '2012-12-21 13:12:03.801115', 'salgado_india.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 925
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (147, 3, 'Salgado', 'Africa', 'Image', true, '2012-12-21 10:41:55.43255', '2012-12-21 13:12:05.070006', '2012-12-21 13:12:03.801115', 'salgado_2.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 924
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (138, 3, 'Salgado', 'Untitled', 'Image', true, '2012-12-21 09:46:28.745627', '2012-12-21 13:12:05.254769', '2012-12-21 13:12:03.801115', 'tumblr_mcxxdyxvsk1qgwmzso1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 920
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (167, 7, 'Albert', 'Albert Einstein (4 March 1879 – 18 April 1955)', 'Image', true, '2012-12-21 11:22:20.350888', '2012-12-21 11:39:10.722026', '2012-12-21 11:39:10.669061', 'albert_einstein_0.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1200
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (176, 7, 'Pitagora', 'Pythagoras of Samos (Ancient Greek: Πυθαγόρας ὁ Σάμιος [Πυθαγόρης in Ionian Greek] Pythagóras ho Sámios "Pythagoras the Samian", or simply Πυθαγόρας; b. about 570 – d. about 495 BC)', 'Image', true, '2012-12-21 11:37:05.613246', '2012-12-21 11:39:10.781857', '2012-12-21 11:39:10.669061', 'pitagora_theo_1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 988
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (166, 3, 'Koudelka', 'Portrait', 'Image', true, '2012-12-21 11:17:00.161855', '2012-12-21 13:11:57.790108', '2012-12-21 13:11:57.344296', 'josefkoudelka.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 924
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (172, 3, 'Koudelka', 'Praga 1968', 'Image', true, '2012-12-21 11:28:24.93155', '2012-12-21 13:11:57.84238', '2012-12-21 13:11:57.344296', 'josef_koudelka_primavera_de_praga_198.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1100
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (170, 3, 'Koudelka', 'Praga 68', 'Image', true, '2012-12-21 11:27:49.960631', '2012-12-21 13:11:58.002757', '2012-12-21 13:11:57.344296', '2556147597b4c3968ca1743f52f1e9259da4c1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 933
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (169, 3, 'Koudelka', 'Praga 68', 'Image', true, '2012-12-21 11:27:33.042361', '2012-12-21 13:11:58.061774', '2012-12-21 13:11:57.344296', '955bc52e2d2a77771a5daac8391f95abb3f861.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 933
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (150, 3, 'Koudelka', 'Praga', 'Image', true, '2012-12-21 11:00:38.249532', '2012-12-21 13:11:58.134196', '2012-12-21 13:11:57.344296', 'josef_koudelka_2.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 957
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (151, 3, 'Koudelka', 'Praga', 'Image', true, '2012-12-21 11:00:51.230494', '2012-12-21 13:11:58.19681', '2012-12-21 13:11:57.344296', 'josef_koudelka_3.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 905
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (162, 3, 'Koudelka', 'Praga', 'Image', true, '2012-12-21 11:14:19.488057', '2012-12-21 13:11:58.326531', '2012-12-21 13:11:57.344296', 'josef-koudelka-primavera-de-praga-1968-01.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 963
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (152, 3, 'Koudelka', 'Praga', 'Image', true, '2012-12-21 11:01:04.977321', '2012-12-21 13:11:58.390225', '2012-12-21 13:11:57.344296', 'koudelka__1_.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 894
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (168, 3, 'Koudelka', 'Praga', 'Image', true, '2012-12-21 11:27:16.257577', '2012-12-21 13:11:58.445691', '2012-12-21 13:11:57.344296', '2009_koudelka_1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1141
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (155, 3, 'Koudelka', 'Dog', 'Image', true, '2012-12-21 11:08:52.058027', '2012-12-21 13:11:58.498339', '2012-12-21 13:11:57.344296', 'koudelka_hound.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 923
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (174, 3, 'Koudelka', 'Gypsies', 'Image', true, '2012-12-21 11:36:39.27384', '2012-12-21 13:11:58.551999', '2012-12-21 13:11:57.344296', 'koudelka_coverok.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1128
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (175, 3, 'Koudelka', 'Gypsies', 'Image', true, '2012-12-21 11:36:57.465027', '2012-12-21 13:11:58.609729', '2012-12-21 13:11:57.344296', 'phote-307.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 926
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (156, 3, 'Koudelka', 'Untitled', 'Image', true, '2012-12-21 11:09:10.579101', '2012-12-21 13:11:58.663621', '2012-12-21 13:11:57.344296', 'koudelka.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 923
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (149, 3, 'Koudelka', 'Slovacchia', 'Image', true, '2012-12-21 11:00:21.003286', '2012-12-21 13:11:58.716228', '2012-12-21 13:11:57.344296', '6-josef-koudelka-slovacchia-1967.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 898
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (164, 3, 'Koudelka', 'Gypsies', 'Image', true, '2012-12-21 11:15:25.823887', '2012-12-21 13:11:58.843601', '2012-12-21 13:11:57.344296', 'phote-270.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 934
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (178, 3, 'Koudelka', 'Gypsies', 'Image', true, '2012-12-21 11:37:36.81248', '2012-12-21 13:11:58.899264', '2012-12-21 13:11:57.344296', 'phote-267.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 921
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (165, 3, 'Koudelka', 'Boemia', 'Image', true, '2012-12-21 11:15:45.656333', '2012-12-21 13:11:58.951146', '2012-12-21 13:11:57.344296', '5-josef-koudelka-boemia-1963.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 921
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (158, 3, 'Koudelka', 'Untitled', 'Image', true, '2012-12-21 11:09:57.963161', '2012-12-21 13:11:59.009488', '2012-12-21 13:11:57.344296', 'tumblr_m3yt6sf7yl1rvg53fo1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 918
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (177, 3, 'Koudelka', 'Gypsies', 'Image', true, '2012-12-21 11:37:16.08821', '2012-12-21 13:11:59.065553', '2012-12-21 13:11:57.344296', 'xpar65744.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 907
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (163, 3, 'Koudelka', 'Untitled', 'Image', true, '2012-12-21 11:15:00.61412', '2012-12-21 13:11:59.123084', '2012-12-21 13:11:57.344296', 'tumblr_lznvvwd1he1qzfye6o1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 919
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (122, 3, 'Salgado', 'Africa', 'Image', true, '2012-12-21 09:39:30.689644', '2012-12-21 13:12:03.894637', '2012-12-21 13:12:03.801115', 'salgado2.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1018
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (120, 3, 'Salgado', 'Africa', 'Image', true, '2012-12-21 09:39:04.781456', '2012-12-21 13:12:04.009952', '2012-12-21 13:12:03.801115', 'salgado1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 935
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (130, 3, 'Salgado', 'Mozambico', 'Image', true, '2012-12-21 09:43:17.868119', '2012-12-21 13:12:04.218056', '2012-12-21 13:12:03.801115', 'ss-_xodos-mo_ambique_zambese.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 998
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (132, 3, 'Salgado', 'Tree and children', 'Image', true, '2012-12-21 09:44:19.550429', '2012-12-21 13:12:04.353492', '2012-12-21 13:12:03.801115', 'tumblr_liq5p1zfhx1qzfye6o1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 940
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (133, 3, 'Salgado', 'Untitled', 'Image', true, '2012-12-21 09:44:50.602192', '2012-12-21 13:12:04.4302', '2012-12-21 13:12:03.801115', '11-salgado1.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1004
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (124, 3, 'Salgado', 'Africa', 'Image', true, '2012-12-21 09:40:47.866666', '2012-12-21 13:12:04.491527', '2012-12-21 13:12:03.801115', 'tumblr_luvszyz1if1qzfye6o1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1008
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (135, 3, 'Salgado', 'Alaska', 'Image', true, '2012-12-21 09:45:43.142803', '2012-12-21 13:12:04.582271', '2012-12-21 13:12:03.801115', '04-3-291-62.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1007
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (128, 3, 'Salgado', 'Alaska', 'Image', true, '2012-12-21 09:42:33.931103', '2012-12-21 13:12:04.712274', '2012-12-21 13:12:03.801115', 'salg056a_email.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1022
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (131, 3, 'Salgado', 'Africa', 'Image', true, '2012-12-21 09:43:42.317922', '2012-12-21 13:12:04.777489', '2012-12-21 13:12:03.801115', 'tumblr_lgzs8qghde1qzfye6o1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1028
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (127, 3, 'Salgado', 'Alaska', 'Image', true, '2012-12-21 09:41:58.21272', '2012-12-21 13:12:04.830429', '2012-12-21 13:12:03.801115', 'tumblr_lprdths5zy1qzfye6o1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1017
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (123, 3, 'Sebastião Salgado', 'Bombay', 'Image', true, '2012-12-21 09:40:12.436787', '2012-12-21 13:12:04.886323', '2012-12-21 13:12:03.801115', 'church-gate-station-bombay-1996-_-sebastiao-salgado.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 935
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (137, 3, 'Salgado', 'Petrol', 'Image', true, '2012-12-21 09:46:03.613704', '2012-12-21 13:12:05.002685', '2012-12-21 13:12:03.801115', 'salgado6.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 933
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (134, 3, 'Salgado', 'Africa', 'Image', true, '2012-12-21 09:45:21.389217', '2012-12-21 13:12:05.129981', '2012-12-21 13:12:03.801115', 'tumblr_llxqs1zhho1qzfye6o1_1280.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 929
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (129, 3, 'Salgado', 'Workers', 'Image', true, '2012-12-21 09:42:56.044407', '2012-12-21 13:12:05.310978', '2012-12-21 13:12:03.801115', 'large_h1000xw950.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1126
  :height: 1400
modifiable: true
', NULL);
INSERT INTO media_elements VALUES (125, 3, 'Salgado', 'Alaska', 'Image', true, '2012-12-21 09:41:28.135838', '2012-12-21 13:12:05.369823', '2012-12-21 13:12:03.801115', 'natal-sebastiaosalgado.jpg', '--- !ruby/object:OpenStruct
table:
  :width: 1400
  :height: 1025
modifiable: true
', NULL);


--
-- Data for Name: slides; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO slides VALUES (1, 1, 'J.M.Basquiat-Plush safe he think..', NULL, 1, 'cover', '2012-12-20 13:42:17.792331', '2012-12-20 13:42:17.792331');
INSERT INTO slides VALUES (2, 1, 'Jean-Michel Basquiat', '<p>Jean-Michel Basquiat, born in Brooklyn, New York after the death of his brother Max, was the second of four children of Matilda Andrades (July 28, 1934 &ndash; November 17, 2008) and Gerard Basquiat (born 1930). He had two younger sisters: Lisane, born in 1964, and Jeanine, born in 1967.</p>
<p>His father, Gerard Basquiat, was born in Port-au-Prince, Haiti, and his mother, Matilde Basquiat, was of Puerto Rican descent, born in Brooklyn, New York.</p>
<p>Basquiat was a precocious child who learned how to read and write by age four and was a gifted artist.[7] His teachers noticed his artistic abilities, and his mother encouraged her son''s artistic talent. By the age of eleven, Basquiat could fluently speak, read, and write French, Spanish, and English.</p>', 2, 'image1', '2012-12-20 13:42:50.091942', '2012-12-20 13:44:43.225208');
INSERT INTO slides VALUES (3, 1, NULL, NULL, 3, 'image3', '2012-12-20 13:44:46.469871', '2012-12-20 13:44:46.469871');
INSERT INTO slides VALUES (4, 1, 'SAMO IS DEAD', '<p>In September 1968, when Basquiat was about eight, he was hit by a car while playing in the street. His arm was broken and he suffered several internal injuries, and eventually underwent a splenectomy.</p>
<p>His parents separated that year and he and his sisters were raised by their father.</p>
<p>The family resided in Boerum Hill, Brooklyn, for five years, then moved to San Juan, Puerto Rico in 1974. After two years, they returned to New York City.[10] Then when he was eleven years old, his mother was committed to a mental institution and thereafter spent time in and out of institutions. At 15, Basquiat ran away from home.</p>
<p>He slept on park benches in Washington Square Park, and was arrested and returned to the care of his father within a week.</p>
<p>Basquiat dropped out of Edward R. Murrow High School in the tenth grade. His father banished him from the household and Basquiat stayed with friends in Brooklyn. He supported himself by selling T-shirts and homemade post cards. He also worked at the Unique Clothing Warehouse in West Broadway, Manhattan.</p>', 4, 'image1', '2012-12-20 13:45:28.112051', '2012-12-20 13:47:57.869314');
INSERT INTO slides VALUES (5, 1, NULL, NULL, 5, 'image2', '2012-12-20 13:48:01.243615', '2012-12-20 13:48:01.243615');
INSERT INTO slides VALUES (10, 2, 'The City', '<p>London is the capital city of England and the United Kingdom, the largest city, urban zone and metropolitan area in the United Kingdom, and the European Union by most measures.</p>
<p>Located on the River Thames, London has been a major settlement for two millennia, its history going back to its founding by the Romans, who named it Londinium.</p>
<p>London''s ancient core, the City of London, largely retains its square-mile mediaeval boundaries. Since at least the 19th century, the name London has also referred to the metropolis developed around this core.</p>
<p>The bulk of this conurbation forms the London region and the Greater London administrative area,[6][note 2] governed by the elected Mayor of London and the London Assembly.</p>', 3, 'image1', '2012-12-20 14:55:42.481192', '2012-12-20 15:07:50.022672');
INSERT INTO slides VALUES (71, 6, 'Quotes', '<p class="article_text" style="text-align: center;">&nbsp;</p>
<p class="article_text" style="text-align: center;"><em><span class="size2">"I do not deny that I have made drawings and watercolors of an erotic nature. But they are always works of art. Are there no artists who have done erotic pictures?"</span></em></p>
<p class="article_text" style="text-align: center;">&nbsp;</p>
<p class="article_text" style="text-align: center;"><em><span class="size2">"I believe in the immortality of all creatures."</span></em></p>
<p class="article_text" style="text-align: center;">&nbsp;</p>
<p class="article_text" style="text-align: center;"><em><span class="size2">"Everything is dead while it lives."</span></em></p>
<p class="article_text" style="text-align: center;">&nbsp;</p>
<p class="article_text" style="text-align: center;"><em><span class="size2">"To hamper an artist is a crime, the murder of germinating life!"</span></em></p>', 15, 'text', '2012-12-21 09:33:10.659485', '2012-12-21 09:35:23.908025');
INSERT INTO slides VALUES (6, 1, 'Final years and death', '<p><span class="size2">By 1986, Basquiat had left the Annina Nosei gallery, and was showing in the famous Mary Boone gallery in SoHo. On February 10, 1985, he appeared on the cover of The New York Times Magazine in a feature entitled "New Art, New Money: The Marketing of an American Artist".</span></p>
<p><span class="size2">He was a successful artist in this period, but his growing heroin addiction began to interfere with his personal relationships.</span><br /><span class="size2">When Andy Warhol died on February 22, 1987, Basquiat became increasingly isolated, and his heroin addiction and depression grew more severe.</span></p>
<p><span class="size2">Despite an attempt at sobriety during a trip to Maui, Hawaii, Basquiat died on August 12, 1988, of a heroin overdose at his art studio in Great Jones Street in New York City''s NoHo neighborhood. He was 27.</span></p>
<p><span class="size2">Basquiat was interred in Brooklyn''s Green-Wood Cemetery.</span></p>', 7, 'text', '2012-12-20 14:03:51.018618', '2012-12-20 14:06:10.304214');
INSERT INTO slides VALUES (7, 1, NULL, NULL, 6, 'image2', '2012-12-20 14:05:29.346066', '2012-12-20 14:06:10.308518');
INSERT INTO slides VALUES (8, 2, 'Welcome in London', NULL, 1, 'cover', '2012-12-20 14:55:07.537037', '2012-12-20 14:55:07.537037');
INSERT INTO slides VALUES (73, 9, 'Sebastião Salgado', NULL, 1, 'cover', '2012-12-21 09:37:04.754484', '2012-12-21 09:37:04.754484');
INSERT INTO slides VALUES (13, 2, NULL, NULL, 5, 'image3', '2012-12-20 14:56:42.914371', '2012-12-20 14:56:42.914371');
INSERT INTO slides VALUES (15, 2, 'Swinging London', NULL, 7, 'image1', '2012-12-20 14:58:15.303229', '2012-12-20 14:58:36.309107');
INSERT INTO slides VALUES (16, 3, '2012 phenomenon', NULL, 1, 'cover', '2012-12-20 14:59:28.729452', '2012-12-20 14:59:28.729452');
INSERT INTO slides VALUES (14, 2, 'Black cabs', '<p>Motorised hackney cabs in the UK, traditionally all black in London and most major cities, are traditionally known as black cabs (which they were), although they are now produced in a variety of colours, sometimes in advertising brand liveries (see below). The 50 golden cabs produced for the Queen''s Golden Jubilee celebrations in 2002 were notable.</p>
<p><br /><span class="size2" style="color: #ff6600;">Vehicle design</span><br />Historically four-door saloon cars have been highly popular as hackney carriages, but with disability regulations growing in strength and some councils offering free licensing for disabled-friendly vehicles, many operators are now opting for wheelchair-adapted taxis such as the LTI. Other models of specialist taxis include the Peugeot E7 and rivals from Fiat, Volkswagen, Metrocab and Mercedes-Benz.</p>
<p>These vehicles normally allow six or seven passengers, although some models can accommodate eight. Some of these ''minibus'' taxis include a front passenger seat next to the driver, while others reserve this space solely for luggage.</p>
<p><br />Many black cabs have a turning circle of only 25 ft (8 m). One reason for this is the configuration of the famed Savoy Hotel: The hotel entrance''s small roundabout meant that vehicles needed the small turning circle in order to navigate it.</p>', 6, 'image1', '2012-12-20 14:58:04.144044', '2012-12-20 15:01:05.067853');
INSERT INTO slides VALUES (11, 2, 'London light', '<p>London is a leading global city, with strengths in the arts, commerce, education, entertainment, fashion, finance, healthcare, media, professional services, research and development, tourism and transport all contributing to its prominence.</p>
<p>It is the world''s leading financial centre alongside New York City and has the fifth- or sixth-largest metropolitan area GDP in the world depending on measurement.</p>
<p>London has been described as a world cultural capital.</p>
<p>It is the world''s most-visited city measured by international arrivals[18] and has the world''s largest city airport system measured by passenger traffic.</p>
<p>London''s 43 universities form the largest concentration of higher education in Europe.[20] In 2012, London became the first city to host the modern Summer Olympic Games three times.</p>', 4, 'image1', '2012-12-20 14:55:57.604356', '2012-12-20 15:05:43.496975');
INSERT INTO slides VALUES (113, 11, 'Maths', NULL, 1, 'cover', '2012-12-21 10:55:07.523044', '2012-12-21 10:55:07.523044');
INSERT INTO slides VALUES (9, 2, 'The history', '<p>London is a leading global city, with strengths in the arts, commerce, education, entertainment, fashion, finance, healthcare, media, professional services, research and development, tourism and transport all contributing to its prominence.</p>
<p>It is the world''s leading financial centre alongside New York City and has the fifth- or sixth-largest metropolitan area GDP in the world depending on measurement. London has been described as a world cultural capital.</p>
<p>t is the world''s most-visited city measured by international arrivals[18] and has the world''s largest city airport system measured by passenger traffic.[19] London''s 43 universities form the largest concentration of higher education in Europe.[20] In 2012, London became the first city to host the modern Summer Olympic Games three times.</p>
<p><br />London has a diverse range of peoples and cultures, and more than 300 languages are spoken within its boundaries.[22] In March 2011, London had an official population of 8,174,100, making it the most populous municipality in the European Union, and accounting for 12.5% of the UK population. The Greater London Urban Area is the second-largest in the EU with a population of 8,278,251,while the London metropolitan area is the largest in the EU with an estimated total population of between 12 million and 14 million.</p>
<p>London had the largest population of any city in the world from around 1831 to 1925.</p>', 2, 'text', '2012-12-20 14:55:30.55323', '2012-12-20 15:10:26.27972');
INSERT INTO slides VALUES (17, 4, 'The big apple', NULL, 1, 'cover', '2012-12-20 15:21:55.897051', '2012-12-20 15:21:55.897051');
INSERT INTO slides VALUES (18, 4, 'New York City', '<p>New York has architecturally noteworthy buildings in a wide range of styles and from distinct time periods from the saltbox style Pieter Claesen Wyckoff House in Brooklyn, the oldest section of which dates to 1656, to the modern One World Trade Center, the skyscraper currently under construction at Ground Zero in Lower Manhattan and currently the most expensive new office tower in the world.<br />Manhattan''s skyline with its many skyscrapers is universally recognized, and the city has been home to several of the tallest buildings in the world. As of 2011, New York City had 5,937 high-rise buildings, of which 550 completed structures were at least 100 meters high, both second in the world after Hong Kong, with over 50 completed skyscrapers taller than 656 feet (200 m). These include the Woolworth Building (1913), an early gothic revival skyscraper built with massively scaled gothic detailing.</p>
<p><br />The 1916 Zoning Resolution required setback in new buildings, and restricted towers to a percentage of the lot size, to allow sunlight to reach the streets below.[164] The Art Deco style of the Chrysler Building (1930) and Empire State Building (1931), with their tapered tops and steel spires, reflected the zoning requirements. The buildings have distinctive ornamentation, such as the eagles at the corners of the 61st floor on the Chrysler Building, and are considered some of the finest examples of the Art Deco style. A highly influential example of the international style in the United States is the Seagram Building (1957), distinctive for its fa&ccedil;ade using visible bronze-toned I-beams to evoke the building''s structure. The Cond&eacute; Nast Building (2000) is a prominent example of green design in American skyscrapers.</p>', 2, 'image1', '2012-12-20 15:22:11.639686', '2012-12-20 15:24:46.286412');
INSERT INTO slides VALUES (19, 4, NULL, NULL, 3, 'image2', '2012-12-20 15:24:49.458', '2012-12-20 15:24:49.458');
INSERT INTO slides VALUES (20, 4, NULL, NULL, 4, 'image3', '2012-12-20 15:25:37.219296', '2012-12-20 15:25:37.219296');
INSERT INTO slides VALUES (21, 4, NULL, NULL, 5, 'image3', '2012-12-20 15:27:23.159226', '2012-12-20 15:27:23.159226');
INSERT INTO slides VALUES (22, 4, 'Not to be confused...', '<p>Harlem is a large neighborhood within the northern section of the New York City borough of Manhattan. Since the 1920s, Harlem has been known as a major African-American residential, cultural and business center. Originally a Dutch village, formally organized in 1658,[6] it is named after the city of Haarlem in the Netherlands. Harlem was annexed to New York City in 1873.</p>
<p>Harlem can be separated into three separate yet cohesive main sections: Central Harlem, West Harlem, and East Harlem. Harlem has been defined by a series of boom-and-bust cycles, with significant population shifts accompanying each cycle.</p>
<p><br />Black residents began to arrive en masse in 1905, with numbers fed by the Great Migration. In the 1920s and 1930s, Central and West Harlem were the focus of the "Harlem Renaissance", an outpouring of artistic and professional works without precedent in the American black community. However, with job losses in the time of the Great Depression and the deindustrialization of New York City after World War II, rates of crime and poverty increased significantly.<br />Today, Central Harlem has an African-American community comprising 81% of the population, creating the largest African-American community by percentage in all of New York City.</p>
<p>Central Harlem is the most famous section of Harlem and thus is commonly referred to simply as Harlem. Central Harlem is home to the famous Apollo Theater.</p>', 6, 'image1', '2012-12-20 15:27:58.301245', '2012-12-20 15:31:28.632882');
INSERT INTO slides VALUES (24, 3, 'Mesoamerican Long Count calendar', NULL, 2, 'title', '2012-12-20 16:27:33.776843', '2012-12-20 16:27:50.457375');
INSERT INTO slides VALUES (25, 3, 'Apocalypse', '<p><span>There is a strong tradition of "world ages" in Mayan literature, but the record has been distorted, leaving several possibilities open to interpretation.</span><sup id="cite_ref-FOOTNOTESeverin198175_20-0" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#cite_note-FOOTNOTESeverin198175-20">[20]</a></sup><span>&nbsp;According to the&nbsp;</span><em><a title="Popol Vuh" href="http://en.wikipedia.org/wiki/Popol_Vuh">Popol Vuh</a></em><span>, a compilation of the&nbsp;</span><a class="mw-redirect" title="Mesoamerican creation accounts" href="http://en.wikipedia.org/wiki/Mesoamerican_creation_accounts">creation accounts</a><span>&nbsp;of the&nbsp;</span><a title="K''iche'' people" href="http://en.wikipedia.org/wiki/K%27iche%27_people">K''iche'' Maya</a><span>&nbsp;of the Colonial-era highlands, we are living in the fourth world.</span><sup id="cite_ref-FOOTNOTEScheleFreidel1990429.E2.80.93430_21-0" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#cite_note-FOOTNOTEScheleFreidel1990429.E2.80.93430-21">[21]</a></sup><span>&nbsp;The&nbsp;</span><em>Popol Vuh</em><span>&nbsp;describes the gods first creating three failed worlds, followed by a successful fourth world in which humanity was placed. In the Maya Long Count, the previous world ended after 13 b''ak''tuns, or roughly 5,125 years.</span><sup id="cite_ref-FOOTNOTEFreidelScheleParker199363_22-0" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#cite_note-FOOTNOTEFreidelScheleParker199363-22">[22]</a></sup><sup id="ref_Aa" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#endnote_Aa">[Note a]</a></sup><span>&nbsp;The Long Count''s "zero date"</span><sup id="ref_Bb" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#endnote_Bb">[Note b]</a></sup><sup id="ref_Cc" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#endnote_Cc">[Note c]</a></sup><span>&nbsp;was set at a point in the past marking the end of the third world and the beginning of the current one, which corresponds to 11 August 3114&nbsp;BC in the&nbsp;</span><a title="Proleptic Gregorian calendar" href="http://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar">proleptic Gregorian calendar</a><span>.</span><sup id="cite_ref-FOOTNOTEAveni200946_23-0" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#cite_note-FOOTNOTEAveni200946-23">[23]</a></sup><sup id="cite_ref-yucalandia_7-1" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#cite_note-yucalandia-7">[7]</a></sup><span>&nbsp;This means that the fourth world will also have reached the end of its 13th b''ak''tun, or Mayan date 13.0.0.0.0, on 21 December 2012. In 1957, Mayanist and astronomer Maud Worcester Makemson wrote that "the completion of a Great Period of 13 b''ak''tuns would have been of the utmost significance to the Maya".</span><sup id="cite_ref-makemson1957_24-0" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#cite_note-makemson1957-24">[24]</a></sup><span>&nbsp;In 1966,&nbsp;</span><a title="Michael D. Coe" href="http://en.wikipedia.org/wiki/Michael_D._Coe">Michael D. Coe</a><span>&nbsp;wrote in&nbsp;</span><em>The Maya</em><span>&nbsp;that "there is a suggestion&nbsp; [by whom?]... that Armageddon would overtake the degenerate peoples of the world and all creation on the final day of the 13th [b''ak''tun]. Thus&nbsp;... our present universe [would] be annihilated [in December 2012]</span><sup id="ref_Ee" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#endnote_Ee">[Note e]</a></sup><span>&nbsp;when the Great Cycle of the Long Count reaches completion."</span><sup id="cite_ref-FOOTNOTECoe1966149_25-0" class="reference"><a href="http://en.wikipedia.org/wiki/2012_phenomenon#cite_note-FOOTNOTECoe1966149-25">[25]</a></sup></p>', 3, 'text', '2012-12-20 16:27:54.940021', '2012-12-20 16:28:22.841087');
INSERT INTO slides VALUES (27, 6, 'Egon Schiele', NULL, 1, 'cover', '2012-12-20 16:33:20.415001', '2012-12-20 16:33:20.415001');
INSERT INTO slides VALUES (26, 3, 'Other catastrophes', '<p><span>Other speculations regarding doomsday in 2012 have included predictions by the&nbsp;</span>Web Bot<span>&nbsp;project, a computer program that purports to predict the future using Internet chatter. However, commentators have rejected the programmers'' claims to have successfully predicted natural disasters, which web chatter could never predict, as opposed to human-caused disasters like stock market crashes.</span></p>', 4, 'image1', '2012-12-20 16:31:42.03463', '2012-12-20 16:34:54.731028');
INSERT INTO slides VALUES (145, 12, NULL, NULL, 5, 'image3', '2012-12-21 11:43:29.624459', '2012-12-21 11:43:29.732239');
INSERT INTO slides VALUES (144, 12, NULL, NULL, 19, 'image3', '2012-12-21 11:42:56.650043', '2012-12-21 13:06:16.309726');
INSERT INTO slides VALUES (23, 5, 'Life is pop!', NULL, 1, 'cover', '2012-12-20 16:23:57.769451', '2012-12-21 14:35:23.347475');
INSERT INTO slides VALUES (28, 6, 'Egon Schiele 1890/1918', '<p><span class="unicode"><strong>Egon Schiele</strong><small class="metadata audiolinkinfo">&nbsp;</small></span><span class="unicode">was an&nbsp;</span>Austrianpainter<span class="unicode">. A prot&eacute;g&eacute; of&nbsp;</span>Gustav Klimt<span class="unicode">, Schiele was a major figurative painter of the early 20th century. His work is noted for its intensity, and the many self-portraits the artist produced. The twisted body shapes and the expressive line that characterize Schiele''s paintings and drawings mark the artist as an early exponent of&nbsp;</span>Expressionism<span class="unicode">.</span></p>
<p><span class="unicode">Schiele was born in 1890 in&nbsp;</span>Tulln<span class="unicode">&nbsp;on the&nbsp;</span>Danube<span class="unicode">. His father, Adolph Schiele, was the station master of the Tulln station in the&nbsp;</span>Austrian State Railways<span class="unicode">; his mother Marie, n&eacute;e Soukupov&aacute;, was a&nbsp;</span>Czech<span class="unicode">&nbsp;from&nbsp;</span>Česk&yacute; Krumlov<span class="unicode">&nbsp;(Krumau), in southern&nbsp;</span>Bohemia<span class="unicode">. As a child, Schiele was fascinated by trains, and would spend many hours drawing them, to the point where his father felt obliged to destroy his sketchbooks. When he was 11 years old, Schiele moved to the nearby city of&nbsp;</span>Krems<span class="unicode">&nbsp;(and later to&nbsp;</span>Klosterneuburg<span class="unicode">) to attend secondary school. To those around him, Schiele was regarded as a strange child. Shy and reserved, he did poorly at school except in athletics and drawing,</span><sup id="cite_ref-1" class="reference">[1]</sup><span class="unicode">&nbsp;and was usually in classes made up of younger pupils. He also displayed incestuous tendencies towards his younger sister Gertrude (who was known as&nbsp;</span><em>Gerti</em><span class="unicode">), and his father, well aware of Egon''s behaviour, was once forced to break down the door of a locked room that Egon and Gerti were in to see what they were doing (only to discover that they were developing a film). When he was sixteen he took the twelve-year-old Gerti by train to&nbsp;</span>Trieste<span class="unicode">&nbsp;without permission and spent a night in a hotel room with her.</span></p>', 2, 'image1', '2012-12-20 16:33:40.310447', '2012-12-20 16:35:31.142656');
INSERT INTO slides VALUES (29, 6, NULL, NULL, 3, 'image2', '2012-12-20 16:35:41.292166', '2012-12-20 16:35:41.292166');
INSERT INTO slides VALUES (30, 3, NULL, NULL, 5, 'image3', '2012-12-20 16:35:53.383039', '2012-12-20 16:35:53.383039');
INSERT INTO slides VALUES (72, 8, 'The Sea Gull', '<p>Gull species range in size from the Little Gull, at 120 g (4.2 oz) and 29 cm (11.5 inches), to the Great Black-backed Gull, at 1.75 kg (3.8 lbs) and 76 cm (30 inches).</p>
<p>They are generally uniform in shape, with heavy bodies, long wings, moderately long necks . The tails of all but three species are rounded; the exceptions being the Sabine''s Gull and Swallow-tailed Gulls, which have forked tails, and the Ross''s Gull, which has a wedge-shaped tail. Gulls have moderately long legs (certainly longer than the terns) with fully webbed feet. The bill is generally heavy and slightly hooked, with the larger species having stouter bills than the smaller species. The bill colour is often yellow with a red spot for the larger white-headed species and red, dark red or black in the smaller species.</p>
<p><br />The gulls are generalist feeders, indeed they are the least specialised of all the seabirds, and their morphology allows for equal adeptness in swimming, flying and walking. They are more adept walking on land than most other seabirds, and the smaller gulls tend to be more manoeuvrable while walking. The walking gait of gulls includes a slight side to side motion, something that can be exaggerated in breeding displays. In the air they are able to hover and they are also able to take off quickly with little space.</p>', 2, 'image1', '2012-12-21 09:36:46.025497', '2012-12-21 09:39:26.539117');
INSERT INTO slides VALUES (74, 8, 'Donkey', '<p>The donkey or ass, Equus africanus asinus, is a domesticated member of the Equidae or horse family. The wild ancestor of the donkey is the African wild ass, E. africanus. The donkey has been used as a working animal for at least 5000 years. There are more than 40 million donkeys in the world, mostly in underdeveloped countries, where they are used principally as draught or pack animals. Working donkeys are often associated with those living at or below subsistence levels. Small numbers of donkeys are kept for breeding or as pets in developed countries.</p>
<p><br />A male donkey or ass is called a jack, a female a jenny or jennet;a young donkey is a foal.[5] Jack donkeys are often used to produce mules.</p>
<p><br />Asses were first domesticated around 3000 BC,[6] or 4000 BC, probably in Egypt or Mesopotamia, and have spread around the world. They continue to fill important roles in many places today.</p>
<p>While domesticated species are increasing in numbers, the African wild ass and another relative, the Onager, are endangered. As beasts of burden and companions, asses and donkeys have worked together with humans for millennia.</p>', 3, 'image1', '2012-12-21 09:39:32.618886', '2012-12-21 09:41:16.035578');
INSERT INTO slides VALUES (75, 8, NULL, NULL, 4, 'video2', '2012-12-21 09:41:24.141428', '2012-12-21 09:41:24.141428');
INSERT INTO slides VALUES (77, 7, NULL, NULL, 2, 'image2', '2012-12-21 09:42:25.762825', '2012-12-21 09:42:25.762825');
INSERT INTO slides VALUES (78, 8, 'Snail', '<p>Snail is a common name that is applied most often to land snails, terrestrial pulmonate gastropod molluscs. However, the common name "snail" is also applied to most of the members of the molluscan class Gastropoda that have a coiled shell that is large enough for the animal to retract completely into. When the word "snail" is used in this most general sense, it includes not just land snails but also thousands of species of sea snails and freshwater snails. Occasionally a few other molluscs that are not actually gastropods, such as the Monoplacophora, which superficially resemble small limpets, may also informally be referred to as "snails".</p>
<p><br />Snail-like animals that naturally lack a shell, or have only an internal shell, are usually called slugs, and land snails that have only a very small shell (that they cannot retract into) are often called semislugs.</p>
<p>nails that respire using a lung belong to the group Pulmonata, while those with gills form a polyphyletic group; in other words, snails with gills form a number of taxonomic groups that are not necessarily more closely related to each other than they are related to some other groups. Both snails that have lungs and snails that have gills have diversified so widely over geological time that a few species with gills can be found on land and numerous species with lungs can be found in freshwater. Even a few marine species have lungs.</p>
<p><br />Snails can be found in a very wide range of environments, including ditches, deserts, and the abyssal depths of the sea. Although many people are familiar with terrestrial snails, they are in the minority. Marine snails constitute the majority of snail species, and have much greater diversity and a greater biomass. Numerous kinds of snail can also be found in fresh water. Most snails have thousands of microscopic tooth-like structures located on a ribbon-like tongue called a radula. The radula works like a file, ripping food into small pieces. Many snails are herbivorous, eating plants or rasping algae from surfaces with their radulae, though a few land species and many marine species are omnivores or predatory carnivores.</p>
<p><br />Several species of the genus Achatina and related genera are known as giant African land snails; some grow to 15 in (38 cm) from snout to tail, and weigh 1 kg (2 lb).[1] The largest living species of sea snail is Syrinx aruanus; its shell can measure up to 90 cm (35 in) in length, and the whole animal with the shell can weigh up to 18 kg (40 lb).</p>', 5, 'text', '2012-12-21 09:43:00.687933', '2012-12-21 09:43:43.118856');
INSERT INTO slides VALUES (37, 6, 'Academy of Fine Art', '<p><span>When Schiele was 15 years old, his father died from&nbsp;</span>syphilis<span>, and he became a ward of his maternal uncle, Leopold Czihaczec, also a railway official. Although he wanted Schiele to follow in his footsteps, and was distressed at his lack of interest in academia, he recognised Schiele''s talent for drawing and unenthusiastically allowed him a tutor; the artist Ludwig Karl Strauch. In 1906 Schiele applied at the&nbsp;</span>Kunstgewerbeschule<span>&nbsp;(School of Arts and Crafts) in&nbsp;</span>Vienna<span>, where&nbsp;</span>Gustav Klimt<span>&nbsp;had once studied. Within his first year there, Schiele was sent, at the insistence of several faculty members, to the more traditional&nbsp;</span>Akademie der Bildenden K&uuml;nste<span>&nbsp;in Vienna in 1906. His main teacher at the academy was&nbsp;</span>Christian Griepenkerl<span>, a painter whose strict doctrine and ultra-conservative style frustrated and dissatisfied Schiele and his fellow students so much that he left three years later.</span></p>', 4, 'image1', '2012-12-20 16:44:45.754223', '2012-12-20 16:51:16.781233');
INSERT INTO slides VALUES (34, 6, NULL, NULL, 6, 'image3', '2012-12-20 16:38:38.433793', '2012-12-21 09:32:14.88219');
INSERT INTO slides VALUES (31, 6, NULL, NULL, 10, 'image3', '2012-12-20 16:36:20.153077', '2012-12-21 09:32:14.903818');
INSERT INTO slides VALUES (110, 9, 'Publications', '<ul>
<li><span class="size2"><em>An Uncertain Grace</em>&nbsp;(1992)</span></li>
<li><span class="size2"><em>Workers: An Archaeology of the Industrial Age</em>&nbsp;(1993)</span></li>
<li><span class="size2"><em>Terra</em>&nbsp;(1997)</span></li>
<li><span class="size2"><em>Migrations</em>&nbsp;(2000), includes photos from 39 countries</span></li>
<li><span class="size2"><em>The Children: Refugees and Migrants</em>&nbsp;(2000)</span></li>
<li><span class="size2"><em>Sahel: The End of the Road</em>&nbsp;(2004)</span></li>
<li><span class="size2"><em>Africa</em>&nbsp;(2007)</span></li>
</ul>', 21, 'text', '2012-12-21 10:49:56.653362', '2012-12-21 10:54:35.449531');
INSERT INTO slides VALUES (41, 5, 'Pop Art', '<p>Pop art is an art movement that emerged in the mid 1950s in Britain and in the late 1950s in the United States. Pop art presented a challenge to traditions of fine art by including imagery from popular culture such as advertising, news, etc. In Pop art, material is sometimes visually removed from its known context, isolated, and/or combined with unrelated material. The concept of pop art refers not as much to the art itself as to the attitudes that led to it.</p>
<p><br />Pop art employs aspects of mass culture, such as advertising, comic books and mundane cultural objects. It is widely interpreted as a reaction to the then-dominant ideas of abstract expressionism, as well as an expansion upon them.[3] And due to its utilization of found objects and images it is similar to Dada. Pop art is aimed to employ images of popular as opposed to elitist culture in art, emphasizing the banal or kitschy elements of any given culture, most often through the use of irony.</p>
<p>It is also associated with the artists'' use of mechanical means of reproduction or rendering techniques.<br />Much of pop art is considered incongruent, as the conceptual practices that are often used make it difficult for some to readily comprehend.<br />Pop art and minimalism are considered to be art movements that precede postmodern art, or are some of the earliest examples of Post-modern Art themselves.</p>
<p><br />Pop art often takes as its imagery that which is currently in use in advertising.[5] Product labeling and logos figure prominently in the imagery chosen by pop artists, like in the Campbell''s Soup Cans labels, by Andy Warhol. Even the labeling on the shipping carton containing retail items has been used as subject matter in pop art, for example in Warhol''s Campbell''s Tomato Juice Box 1964, (pictured below), or his Brillo Soap Box sculptures.</p>', 2, 'text', '2012-12-20 16:51:19.869153', '2012-12-20 16:58:52.935824');
INSERT INTO slides VALUES (54, 5, NULL, NULL, 13, 'image3', '2012-12-20 17:10:55.153017', '2012-12-20 17:10:55.153017');
INSERT INTO slides VALUES (42, 5, NULL, NULL, 4, 'image3', '2012-12-20 16:52:49.343763', '2012-12-20 17:01:19.737045');
INSERT INTO slides VALUES (44, 5, 'Andy Warhol', NULL, 3, 'title', '2012-12-20 16:59:23.783627', '2012-12-20 17:01:19.741739');
INSERT INTO slides VALUES (46, 5, 'Keith Haring', NULL, 6, 'title', '2012-12-20 17:03:47.012292', '2012-12-20 17:04:57.288506');
INSERT INTO slides VALUES (48, 5, NULL, NULL, 7, 'image3', '2012-12-20 17:05:40.88062', '2012-12-20 17:05:40.88062');
INSERT INTO slides VALUES (49, 5, ' School of Visual Arts', '<p>Haring achieved his first public attention with chalk drawings in the subways of New York (see public art). These were his first recognized pieces of pop art. The exhibitions were filmed by the photographer Tseng Kwong Chi. Around this time, "The Radiant Baby" became his symbol.</p>
<p>His bold lines, vivid colors, and active figures carry strong messages of life and unity. Starting in 1980, he organized exhibitions in Club 57. He participated in the Times Square Exhibition and drew, for the first time, animals and human faces. That same year, he photocopied and pasted around the city provocative collages made from cut-up and recombined New York Post headlines. In 1981 he sketched his first chalk drawings on black paper and painted plastic, metal and found objects.</p>
<p><br />By 1982, Haring established friendships with fellow emerging artists Futura 2000, Kenny Scharf, Madonna and Jean-Michel Basquiat. Haring created more than 50 public works between 1982 and 1989 in dozens of cities around the world. His famous "Crack is Wack" mural, created in 1986, has become a landmark on New York''s FDR Drive. He got to know Andy Warhol, who was the theme of several of Haring''s pieces including "Andy Mouse." His friendship with Warhol would prove to be a decisive element in his eventual success, particularly after their deaths.</p>
<p><br />In December 2007, an area of the American Textile Building in the TriBeCa neighborhood of New York City was discovered to contain a painting of Haring''s from 1979.</p>', 8, 'image1', '2012-12-20 17:06:03.843869', '2012-12-20 17:08:29.002993');
INSERT INTO slides VALUES (51, 5, NULL, NULL, 10, 'image3', '2012-12-20 17:08:55.147658', '2012-12-20 17:08:55.147658');
INSERT INTO slides VALUES (52, 5, NULL, NULL, 11, 'image3', '2012-12-20 17:09:29.752211', '2012-12-20 17:09:29.752211');
INSERT INTO slides VALUES (50, 5, 'The POP in Italy', NULL, 9, 'title', '2012-12-20 17:08:32.384567', '2012-12-21 09:25:41.156609');
INSERT INTO slides VALUES (53, 5, 'Mario Schifano', '<p><strong>Mario Schifano ( 20 September 1934, Khoms, Libya - 26 January 1998, Rome, Italy )</strong></p>
<p>was an Italian painter and collagist of the Postmodern tradition. He also achieved some renown as a film-maker and rock musician.</p>
<p><br />He is considered to be one of most significant and pre-eminent artists of Italian postmodernism, alongside contemporaries such as Francesco Clemente, Sandro Chia and Giulio Paolini. His work was exhibited in the famous 1962 "New Realists" show at the Sidney Janis Gallery with all the young Pop art and Nouveau r&eacute;alisme luminaries, including Andy Warhol and Roy Lichtenstein. He became part of the core group of artists comprising the "Scuola romana" alongside Franco Angeli and Tano Festa .</p>
<p>Reputed as a prolific and exuberant artist, he nonetheless struggled with a lifelong drug habit that earned him the label maledetto, or "cursed".</p>
<p><br />Schifano had a relationship with Marianne Faithfull in 1969</p>', 12, 'image1', '2012-12-20 17:09:53.697731', '2012-12-21 09:26:07.06499');
INSERT INTO slides VALUES (79, 7, 'Life', '<p><strong>Rene Magritte</strong><span>&nbsp;was born in Lessines, in the province of Hainaut, in 1898, the eldest son of Leopold Magritte, who was a tailor and textile merchant, and Regina (nee Bertinchamps), a milliner until her marriage. Little is known about Magritte''s early life. He began lessons in drawing in 1910. On 12 March 1912, his mother committed suicide by drowning herself in the River Sambre. This was not her first attempt; she had made many over a number of years, driving her husband Leopold to lock her into her bedroom. </span></p>
<p><span>One day she escaped, and was missing for days. She was later discovered a mile or so down the nearby river, dead. According to a legend, 13-year-old Magritte was present when her body was retrieved from the water, but recent research has discredited this story, which may have originated with the family nurse. Supposedly, when his mother was found, her dress was covering her face, an image that has been suggested as the source of several oil paintings Magritte painted in 1927-1928 of people with cloth obscuring their faces, including Les Amants.</span></p>
<p><span><span>Magritte''s earliest oil paintings, which date from about 1915, were Impressionistic in style. From 1916 to 1918 he studied at the Academie Royale des Beaux-Arts in Brussels, under Constant Montald, but found the instruction uninspiring. The oil paintings he produced during the years 1918-1924 were influenced by Futurism and by the offshoot of Cubism practiced by Metzinger. Most of his works of this period are female nudes.</span></span></p>', 3, 'image1', '2012-12-21 09:43:20.46521', '2012-12-21 09:44:51.880304');
INSERT INTO slides VALUES (80, 8, 'The Bee', '<p>Bees are flying insects closely related to wasps and ants, and are known for their role in pollination and for producing honey and beeswax. Bees are a monophyletic lineage within the superfamily Apoidea, presently classified by the unranked taxon name Anthophila. There are nearly 20,000 known species of bees in seven to nine recognized families,[1] though many are undescribed and the actual number is probably higher.</p>
<p>They are found on every continent except Antarctica, in every habitat on the planet that contains insect-pollinated flowering plants.<br />Bees are adapted for feeding on nectar and pollen, the former primarily as an energy source and the latter primarily for protein and other nutrients. Most pollen is used as food for larvae.<br />Bees have a long proboscis (a complex "tongue") that enables them to obtain the nectar from flowers. They have antennae almost universally made up of 13 segments in males and 12 in females, as is typical for the superfamily. Bees all have two pairs of wings, the hind pair being the smaller of the two; in a very few species, one sex or caste has relatively short wings that make flight difficult or impossible, but none are wingless.</p>
<p><br />The smallest bee is Trigona minima, a stingless bee whose workers are about 2.1 mm (5/64") long. The largest bee in the world is Megachile pluto, a leafcutter bee whose females can attain a length of 39 mm (1.5"). Members of the family Halictidae, or sweat bees, are the most common type of bee in the Northern Hemisphere, though they are small and often mistaken for wasps or flies.</p>', 6, 'image1', '2012-12-21 09:43:54.490462', '2012-12-21 09:45:01.818841');
INSERT INTO slides VALUES (56, 3, 'Locating the Maya', '<p>The Maya civilization was one of the most dominant indigenous societies of Mesoamerica (a term used to describe Mexico and Central America before the 16th century Spanish conquest). Unlike other scattered indigenous populations of Mesoamerica, the Maya were centered in one geographical block covering all of the Yucatan Peninsula and modern-day Guatemala; Belize and parts of the Mexican states of Tabasco and Chiapas; and the western part of Honduras and El Salvador. This concentration showed that the Maya remained relatively secure from invasion by other Mesoamerican peoples.</p>
<p>Within that expanse, the Maya lived in three separate sub-areas with distinct environmental and cultural differences: the northern Maya lowlands on the Yucatan Peninsula; the southern lowlands in the Peten district of northern Guatemala and adjacent portions of Mexico, Belize and western Honduras; and the southern Maya highlands, in the mountainous region of southern Guatemala. Most famously, the Maya of the southern lowland region reached their peak during the Classic Period of Maya civilization (A.D. 250 to 900), and built the great stone cities and monuments that have fascinated explorers and scholars of the region.</p>', 6, 'image1', '2012-12-21 08:35:04.491982', '2012-12-21 08:37:11.297501');
INSERT INTO slides VALUES (57, 3, NULL, NULL, 7, 'image2', '2012-12-21 08:39:52.538862', '2012-12-21 08:39:52.538862');
INSERT INTO slides VALUES (81, 8, NULL, NULL, 7, 'video2', '2012-12-21 09:45:03.814758', '2012-12-21 09:45:03.814758');
INSERT INTO slides VALUES (59, 6, 'Style', '<p>In his early years, Schiele was strongly influenced by Klimt and&nbsp;Kokoschka. Although imitations of their styles, particularly with the former, are noticeably visible in Schiele''s first works, he soon evolved into his own distinctive style.</p>
<p>Schiele''s earliest works between 1907 and 1909 contain strong similarities with those of Klimt,&nbsp;as well as influences from&nbsp;Art Nouveau.&nbsp;In 1910, Schiele began experimenting with nudes and within a year a definitive style featuring emaciated, sickly-coloured figures, often with strong sexual overtones. Within this year Schiele also painted and drew many children.<sup id="cite_ref-7" class="reference"><br /></sup></p>
<p>Progressively, Schiele''s work grew more complex and thematic, and after his imprisonment in 1912 he dealt with themes such as death and rebirth,&nbsp;although female nudes remained his main output. During the war Schiele''s paintings became larger and more detailed, when he had the time to produce them. His military service however gave him limited time, and much of his output consisted of linear drawings of scenery and military officers. Around this time Schiele also began experimenting with the theme of motherhood and family.&nbsp;His wife Edith was the model for most of his female figures, but during the war due to circumstance, many of his sitters were male. Since 1920, Schiele''s female nudes had become fuller in figure, but many were deliberately illustrated with a lifeless doll-like appearance. Towards the end of his life, Schiele drew many natural and architectural subjects. His last few drawings consisted of female nudes, some in masturbatory poses.</p>
<p>Some view Schiele''s work as being grotesque, erotic, pornographic, or disturbing, focusing on sex, death, and discovery. He focused on portraits of others as well as himself. In his later years, while he still worked often with nudes, they were done in a more realist fashion. He also painted tributes to&nbsp;Van Gogh''s&nbsp;<em>Sunflowers</em>&nbsp;as well as landscapes and still lifes.</p>', 7, 'text', '2012-12-21 09:14:29.745923', '2012-12-21 09:32:14.887738');
INSERT INTO slides VALUES (84, 9, 'Biography', '<p><span>Salgado was born on February 8, 1944 in&nbsp;</span>Aimor&eacute;s<span>, in the state of&nbsp;</span>Minas Gerais<span>, Brazil. After a somewhat itinerant childhood, Salgado initially trained as an&nbsp;</span>economist<span>, earning a&nbsp;</span>master&rsquo;s degree<span>&nbsp;in economics from the&nbsp;</span>University of S&atilde;o Paulo<span>&nbsp;in Brazil. </span></p>
<p><span>He began work as an economist for the International Coffee Organization, often traveling to Africa on missions for the&nbsp;</span>World Bank<span>, when he first started seriously taking photographs. He chose to abandon a career as an economist and switched to photography in 1973, working initially on news assignments before veering more towards documentary-type work. Salgado initially worked with the photo agency&nbsp;</span>Sygma<span>&nbsp;and the Paris-based&nbsp;</span>Gamma<span>, but in 1979 he joined the international cooperative of photographers,&nbsp;</span>Magnum Photos<span>. </span></p>
<p><span>He left Magnum in 1994 and with his wife L&eacute;lia Wanick Salgado formed his own agency, Amazonas Images, in Paris to represent his work. He is particularly noted for his social documentary photography of workers in less developed nations. </span></p>
<p><span>They reside in Paris.</span></p>', 2, 'image1', '2012-12-21 09:48:11.305325', '2012-12-21 09:54:44.802949');
INSERT INTO slides VALUES (45, 5, 'The Factory', '<p><strong>Andy Warhol (August 6, 1928 &ndash; February 22, 1987)</strong> was an American artist who was a leading figure in the visual art movement known as pop art. His works explore the relationship between artistic expression, celebrity culture and advertisement that flourished by the 1960s. After a successful career as a commercial illustrator, Warhol became a renowned and sometimes controversial artist. The Andy Warhol Museum in his native city, Pittsburgh, Pennsylvania, holds an extensive permanent collection of art and archives. It is the largest museum in the United States of America dedicated to a single artist.</p>
<p><br />Warhol''s art encompassed many forms of media, including hand drawing, painting, printmaking, photography, silk screening, sculpture, film, and music. He was also a pioneer in computer-generated art using Amiga computers that were introduced in 1984, two years before his death. He founded Interview Magazine and was the author of numerous books, including The Philosophy of Andy Warhol and Popism: The Warhol Sixties. He is also notable as a gay man who lived openly as such before the gay liberation movement. His studio, The Factory, was a famous gathering place that brought together distinguished intellectuals, drag queens, playwrights, Bohemian street people, Hollywood celebrities, and wealthy patrons.<br />Warhol has been the subject of numerous retrospective exhibitions, books, and feature and documentary films. He coined the widely used expression "15 minutes of fame". Many of his creations are very collectible and highly valuable. The highest price ever paid for a Warhol painting is US$100 million for a 1963 canvas titled Eight Elvises.</p>', 5, 'image1', '2012-12-20 17:01:12.744716', '2012-12-21 09:23:14.337644');
INSERT INTO slides VALUES (70, 8, 'Every man for himself ...', NULL, 1, 'cover', '2012-12-21 09:32:36.459058', '2012-12-21 09:36:35.525849');
INSERT INTO slides VALUES (86, 9, NULL, NULL, 5, 'image3', '2012-12-21 09:55:16.995193', '2012-12-21 09:55:57.195369');
INSERT INTO slides VALUES (85, 9, NULL, NULL, 4, 'image3', '2012-12-21 09:54:50.361445', '2012-12-21 09:55:57.200979');
INSERT INTO slides VALUES (88, 9, NULL, NULL, 6, 'image3', '2012-12-21 09:56:32.685335', '2012-12-21 09:56:32.685335');
INSERT INTO slides VALUES (83, 7, NULL, '<p><span>Magritte''s earliest oil paintings, which date from about 1915, were Impressionistic in style. From 1916 to 1918 he studied at the Academie Royale des Beaux-Arts in Brussels, under Constant Montald, but found the instruction uninspiring. The oil paintings he produced during the years 1918-1924 were influenced by Futurism and by the offshoot of Cubism practiced by Metzinger. Most of his works of this period are female nudes.</span></p>
<p>&nbsp;</p>', 4, 'image1', '2012-12-21 09:46:47.153419', '2012-12-21 09:56:36.295296');
INSERT INTO slides VALUES (68, 7, 'Rene Magritte and his paintings', NULL, 1, 'cover', '2012-12-21 09:30:00.452549', '2012-12-21 09:30:00.452549');
INSERT INTO slides VALUES (62, 5, 'Mimmo Rotella', '<p><strong>Domenico "Mimmo" Rotella, (7 October 1918 &ndash; 8 January 2006),</strong></p>
<p>was an Italian artist and poet best known for his works of d&eacute;collage and psychogeographics, made from torn advertising posters.<br />Rotella was born in Catanzaro, Calabria.</p>
<p><br />He was associated to the Ultra-Lettrists an offshoot of Lettrism and later was a member of the Nouveau R&eacute;alisme group, founded by Pierre Restany in 1960, whose other members included Yves Klein, Arman and Jean Tinguely.<br />He exhibited at the I.C.A., London 1957.</p>
<p><br />He died in Milan in 2006.</p>', 14, 'image1', '2012-12-21 09:27:14.081264', '2012-12-21 09:30:30.865419');
INSERT INTO slides VALUES (107, 9, NULL, NULL, 19, 'image3', '2012-12-21 10:09:33.953214', '2012-12-21 10:54:35.50755');
INSERT INTO slides VALUES (87, 9, '
People', NULL, 3, 'title', '2012-12-21 09:55:41.903874', '2012-12-21 10:29:32.063156');
INSERT INTO slides VALUES (106, 9, NULL, NULL, 8, 'image3', '2012-12-21 10:07:39.994315', '2012-12-21 10:29:54.95876');
INSERT INTO slides VALUES (64, 6, NULL, NULL, 11, 'image3', '2012-12-21 09:27:44.649674', '2012-12-21 09:30:58.26625');
INSERT INTO slides VALUES (65, 6, NULL, NULL, 12, 'image2', '2012-12-21 09:28:22.295918', '2012-12-21 09:30:58.27091');
INSERT INTO slides VALUES (66, 6, NULL, NULL, 13, 'image2', '2012-12-21 09:28:50.779903', '2012-12-21 09:30:58.276274');
INSERT INTO slides VALUES (67, 6, NULL, NULL, 14, 'image3', '2012-12-21 09:29:44.412424', '2012-12-21 09:30:58.281291');
INSERT INTO slides VALUES (39, 6, 'Klimt and first exhibitions', '<p>In 1907, Schiele sought out Gustav Klimt. Klimt generously mentored younger artists, and he took a particular interest in the gifted young Schiele, buying his drawings, offering to exchange them for some of his own, arranging models for him and introducing him to potential patrons. He also introduced Schiele to the&nbsp;Wiener Werkst&auml;tte, the arts and crafts workshop connected with the&nbsp;Secession. In 1908 Schiele had his first exhibition, in&nbsp;Klosterneuburg. Schiele left the Academy in 1909, after completing his third year, and founded the&nbsp;<em>Neukunstgruppe</em>&nbsp;("New Art Group") with other dissatisfied students.</p>
<p>Klimt invited Schiele to exhibit some of his work at the 1909 Vienna&nbsp;<em>Kunstschau</em>, where he encountered the work of&nbsp;Edvard Munch,&nbsp;Jan Toorop, andVincent van Gogh&nbsp;among others. Once free of the constraints of the Academy''s conventions, Schiele began to explore not only the human form, but also human sexuality. At the time, many found the explicitness of his works disturbing.</p>
<p>From then on, Schiele participated in numerous group exhibitions, including those of the Neukunstgruppe in Prague in 1910 and&nbsp;Budapest&nbsp;in 1912; theSonderbund,&nbsp;Cologne, in 1912; and several Secessionist shows in&nbsp;Munich, beginning in 1911. In 1913, the&nbsp;Galerie Hans Goltz, Munich, mounted Schiele''s first solo show. A solo exhibition of his work took place in&nbsp;Paris&nbsp;in 1914.</p>', 5, 'image1', '2012-12-20 16:46:39.555258', '2012-12-21 09:32:14.876363');
INSERT INTO slides VALUES (60, 6, NULL, NULL, 8, 'image2', '2012-12-21 09:26:50.834357', '2012-12-21 09:32:14.893507');
INSERT INTO slides VALUES (63, 6, NULL, NULL, 9, 'image3', '2012-12-21 09:27:24.405215', '2012-12-21 09:32:14.899137');
INSERT INTO slides VALUES (111, 9, NULL, NULL, 11, 'image3', '2012-12-21 10:52:22.877232', '2012-12-21 10:52:22.955347');
INSERT INTO slides VALUES (96, 9, NULL, NULL, 7, 'image3', '2012-12-21 09:59:35.148231', '2012-12-21 09:59:35.148231');
INSERT INTO slides VALUES (104, 9, NULL, NULL, 20, 'image3', '2012-12-21 10:05:47.531854', '2012-12-21 10:54:35.501789');
INSERT INTO slides VALUES (103, 9, NULL, NULL, 18, 'image3', '2012-12-21 10:05:39.993456', '2012-12-21 10:54:35.513287');
INSERT INTO slides VALUES (102, 9, NULL, NULL, 17, 'image3', '2012-12-21 10:05:31.655585', '2012-12-21 10:54:35.518803');
INSERT INTO slides VALUES (101, 9, NULL, NULL, 16, 'image3', '2012-12-21 10:05:21.811993', '2012-12-21 10:54:35.524328');
INSERT INTO slides VALUES (99, 9, '
Nature', NULL, 15, 'title', '2012-12-21 10:04:47.155511', '2012-12-21 10:54:35.529992');
INSERT INTO slides VALUES (112, 9, 'Travelling', '<p>He has traveled in over 100 countries for his photographic projects. Most of these, besides appearing in numerous press publications, have also been presented in books such as&nbsp;<em>Other Americas</em>&nbsp;(1986),&nbsp;<em>Sahel: l&rsquo;homme en d&eacute;tresse</em>&nbsp;(1986),&nbsp;<em>Sahel: el fin del camino</em>&nbsp;(1988),&nbsp;<em>Workers</em>(1993),&nbsp;<em>Terra</em>&nbsp;(1997),&nbsp;<em>Migrations</em>&nbsp;and&nbsp;<em>Portraits</em>&nbsp;(2000), and&nbsp;<em>Africa</em>&nbsp;(2007). Touring exhibitions of this work have been, and continue to be, presented throughout the world. Longtime gallery director&nbsp;Hal Gould&nbsp;considers Salgado to be the most important photographer of the early 21st century, and gave him his first show in the United States.</p>
<p>Salgado has been awarded numerous major photographic prizes in recognition of his accomplishments. He is a&nbsp;UNICEF Goodwill Ambassador, and an honorary member of the&nbsp;Academy of Arts and Sciences&nbsp;in the United States. He was awarded The&nbsp;Royal Photographic Society''s Centenary Medal and Honorary Fellowship (HonFRPS) in recognition of a sustained, significant contribution to the art of photography in 1993.<sup id="cite_ref-1" class="reference">[1]</sup></p>
<p>Together, L&eacute;lia and Sebasti&atilde;o have worked since the 1990s on the restoration of a small part of the Atlantic Forest in Brazil. In 1998 they succeeded in turning this land into a nature reserve and created the&nbsp;Instituto Terra. The Instituto is dedicated to a mission of reforestation, conservation and environmental education.</p>
<p>In 2004, Sebasti&atilde;o Salgado began a project named "Genesis," aiming at the presentation of the unblemished faces of nature and humanity. It consists of a series of photographs of landscapes and wildlife, as well as of human communities that continue to live in accordance with their ancestral traditions and cultures. This body of work is conceived as a potential path to humanity&rsquo;s rediscovery of itself in nature.</p>
<p>Salgado works on long term, self-assigned projects many of which have been published as books:&nbsp;<em>The Other Americas</em>,&nbsp;<em>Sahel</em>,&nbsp;<em>Workers</em>, and&nbsp;<em>Migrations</em>. The later two are mammoth collections with hundreds of images each from all around the world. His most famous pictures are of a&nbsp;gold mine&nbsp;in Brazil called&nbsp;Serra Pelada. He is presently working on a project called&nbsp;<em>Genesis</em>, photographing the landscape, flora and fauna of places on earth that have not been taken over by man.</p>
<p>In September and October 2007, Salgado displayed his photographs of&nbsp;coffee&nbsp;workers from India, Guatemala, Ethiopia and Brazil at the Brazilian Embassy in London. The aim of the project was to raise public awareness of the origins of the popular drink.</p>', 14, 'text', '2012-12-21 10:54:35.423326', '2012-12-21 10:55:23.914477');
INSERT INTO slides VALUES (114, 12, 'Josef Koudelka', NULL, 1, 'cover', '2012-12-21 11:18:50.305436', '2012-12-21 11:18:50.305436');
INSERT INTO slides VALUES (98, 9, NULL, NULL, 9, 'image4', '2012-12-21 10:03:46.63846', '2012-12-21 10:30:06.200529');
INSERT INTO slides VALUES (97, 9, NULL, NULL, 10, 'image3', '2012-12-21 09:59:52.618278', '2012-12-21 10:30:10.388306');
INSERT INTO slides VALUES (105, 9, NULL, NULL, 13, 'image2', '2012-12-21 10:06:17.211533', '2012-12-21 10:52:49.491093');
INSERT INTO slides VALUES (100, 9, NULL, NULL, 12, 'image3', '2012-12-21 10:05:07.302547', '2012-12-21 10:52:49.495672');
INSERT INTO slides VALUES (115, 12, 'Biography', '<p>Josef Koudelka was born in 1938 in&nbsp;Boskovice,&nbsp;Moravia. He began photographing his family and the surroundings with a 6 x 6&nbsp;Bakelite&nbsp;camera. He studied at the&nbsp;Czech Technical University in Prague&nbsp;(CVUT) between 1956 and 1961, receiving a Degree in Engineering in 1961. He staged his first photographic exhibition the same year. Later he worked as an aeronautical engineer in&nbsp;Prague&nbsp;and&nbsp;Bratislava.</p>
<p>He began taking commissions from theatre magazines, and regularly photographed stage productions at Prague''s Theatre Behind the Gate on aRolleiflex&nbsp;camera. In 1967, Koudelka decided to give up his career in engineering for full-time work as a photographer.</p>
<p>He had returned from a project photographing&nbsp;gypsies&nbsp;in&nbsp;Romania&nbsp;just two days before the Soviet invasion, in August 1968. He witnessed and recorded the military forces of the&nbsp;Warsaw Pact&nbsp;as they invaded Prague and crushed the Czech reforms. Koudelka''s negatives were smuggled out of Prague into the hands of the&nbsp;Magnum&nbsp;agency, and published anonymously in&nbsp;<em>The Sunday Times</em>&nbsp;Magazine under the initials P. P. (Prague Photographer) for fear of reprisal to him and his family.</p>
<p><span>His pictures of the events became dramatic international symbols. In 1969 the "anonymous Czech photographer" was awarded the&nbsp;</span>Overseas Press Club<span>''s&nbsp;</span>Robert Capa Gold Medal<span>&nbsp;for photographs requiring exceptional courage.</span></p>', 2, 'image1', '2012-12-21 11:20:22.630001', '2012-12-21 11:20:58.250003');
INSERT INTO slides VALUES (131, 12, NULL, NULL, 12, 'image4', '2012-12-21 11:31:39.161898', '2012-12-21 11:43:29.694573');
INSERT INTO slides VALUES (123, 12, NULL, NULL, 11, 'image3', '2012-12-21 11:22:43.951871', '2012-12-21 11:43:29.700115');
INSERT INTO slides VALUES (122, 12, NULL, NULL, 10, 'image3', '2012-12-21 11:22:36.639408', '2012-12-21 11:43:29.705575');
INSERT INTO slides VALUES (119, 12, '...', '<p>With Magnum to recommend him to the British authorities, Koudelka applied for a three-month working visa and fled to&nbsp;England&nbsp;in 1970, where he applied for&nbsp;political asylum&nbsp;and stayed for more than a decade. In 1971 he joined&nbsp;Magnum Photos. A nomad at heart, he continued to wander around Europe with his camera and little else.</p>
<p>Throughout the 1970s and 1980s, Koudelka sustained his work through numerous grants and awards, and continued to exhibit and publish major projects like&nbsp;<em>Gypsies</em>&nbsp;(1975) and&nbsp;<em>Exiles</em>&nbsp;(1988). Since 1986, he has worked with a panoramic camera and issued a compilation of these photographs in his book&nbsp;<em>Chaos</em>&nbsp;in 1999. Koudelka has had more than a dozen books of his work published, including most recently in 2006 the retrospective volume&nbsp;<em>Koudelka</em>.</p>
<p>Koudelka has won awards such as the&nbsp;Prix Nadar&nbsp;(1978), a&nbsp;Grand Prix National de la Photographie&nbsp;(1989), a&nbsp;Grand Prix Cartier-Bresson&nbsp;(1991), and the&nbsp;Hasselblad Foundation International Award in Photography&nbsp;(1992). Significant exhibitions of his work have been held at the&nbsp;Museum of Modern Art&nbsp;and the&nbsp;International Center of Photography, New York; the&nbsp;Hayward Gallery, London; theStedelijk Museum of Modern Art, Amsterdam; and the&nbsp;Palais de Tokyo, Paris.</p>
<p>He and his work received support and acknowledgment from his friend the French photographer,&nbsp;Henri Cartier-Bresson. He was also supported by the Czech&nbsp;art historian&nbsp;Anna Farova.<sup id="cite_ref-rp_1-0" class="reference">[1]</sup></p>
<p>In 1987 Koudelka became a French citizen, and was able to return to Czechoslovakia for the first time in 1991. He then produced&nbsp;<em>Black Triangle</em>, documenting his country''s wasted landscape.</p>
<p>Koudelka resides in France and Prague and is continuing his work documenting the European landscape. He has two daughters and a son.</p>', 3, 'text', '2012-12-21 11:21:49.606588', '2012-12-21 11:22:08.310092');
INSERT INTO slides VALUES (121, 12, NULL, NULL, 9, 'image3', '2012-12-21 11:22:28.069246', '2012-12-21 11:43:29.71109');
INSERT INTO slides VALUES (120, 12, NULL, NULL, 8, 'image3', '2012-12-21 11:22:12.815048', '2012-12-21 11:43:29.71671');
INSERT INTO slides VALUES (130, 12, NULL, NULL, 7, 'image3', '2012-12-21 11:31:12.855511', '2012-12-21 11:43:29.722221');
INSERT INTO slides VALUES (147, 12, 'Awards', '<p><strong>2004</strong>&nbsp;- Cornell Capa Infinity Award,&nbsp;International Center of Photography, US</p>
<p><strong>1998</strong>&nbsp;- The&nbsp;Royal Photographic Society''s Centenary Medal and Honorary Fellowship (HonFRPS) in recognition of a sustained, significant contribution to the art of photography in 1998.</p>
<p><strong>1992</strong>&nbsp;- Erna and Victor Hasselblad Foundation Photography Prize, Sweden</p>
<p><strong>1991</strong>&nbsp;- Grand Prix Henri Cartier-Bresson, France</p>
<p><strong>1987</strong>&nbsp;- Grand Prix National de la Photographie,&nbsp;French Ministry of Culture, France</p>
<p><strong>1980</strong>&nbsp;-&nbsp;National Endowment for the Arts&nbsp;Council, US</p>
<p><strong>1978</strong>&nbsp;- Prix Nadar, France</p>
<p><strong>1976</strong>&nbsp;-&nbsp;British Arts Council&nbsp;Grant to cover life in the British Isles, UK</p>
<p><strong>1973</strong>&nbsp;- British Arts Council Grant to cover Gypsy life in Britain, UK</p>
<p><strong>1972</strong>&nbsp;- British Arts Council Grant to cover Kendal and Southend, UK</p>
<p><strong>1969</strong>&nbsp;- Robert Capa Gold Medal Award,&nbsp;National Press Photographers Association, US</p>
<p><strong>1967</strong>&nbsp;- Award by Union of Czechoslovakian Artists, Czechoslovakia</p>', 20, 'text', '2012-12-21 13:06:43.412444', '2012-12-21 13:06:51.889144');
INSERT INTO slides VALUES (165, 20, 'Slide 1', '<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">&nbsp;</p>
<p style="text-align: left;"><span style="color: #ff0000;"><strong>Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</strong></span></p>', 2, 'image1', '2013-01-08 11:30:17.605522', '2013-01-08 11:31:36.886727');
INSERT INTO slides VALUES (166, 20, NULL, NULL, 3, 'image3', '2013-01-08 11:31:38.979298', '2013-01-08 11:31:38.979298');
INSERT INTO slides VALUES (167, 20, NULL, NULL, 4, 'video2', '2013-01-08 11:31:55.301517', '2013-01-08 11:31:55.301517');
INSERT INTO slides VALUES (168, 20, NULL, NULL, 5, 'image4', '2013-01-08 11:32:35.211847', '2013-01-08 11:32:35.211847');
INSERT INTO slides VALUES (169, 20, NULL, NULL, 6, 'image2', '2013-01-08 11:34:06.960045', '2013-01-08 11:34:06.960045');
INSERT INTO slides VALUES (127, 11, NULL, NULL, 2, 'video2', '2012-12-21 11:25:13.902662', '2012-12-21 11:25:13.902662');
INSERT INTO slides VALUES (128, 11, NULL, NULL, 3, 'image3', '2012-12-21 11:25:28.089875', '2012-12-21 11:25:28.089875');
INSERT INTO slides VALUES (129, 11, 'Etymology', '<p>The word mathematics comes from the Greek &mu;ά&theta;&eta;&mu;&alpha; (m&aacute;thēma), which, in the ancient Greek language, means "what one learns", "what one gets to know", hence also "study" and "science", and in modern Greek just "lesson". The word m&aacute;thēma is derived from &mu;&alpha;&nu;&theta;ά&nu;&omega; (manthano), while the modern Greek equivalent is &mu;&alpha;&theta;&alpha;ί&nu;&omega; (mathaino), both of which mean "to learn". In Greece, the word for "mathematics" came to have the narrower and more technical meaning "mathematical study", even in Classical times.[18] Its adjective is &mu;&alpha;&theta;&eta;&mu;&alpha;&tau;&iota;&kappa;ό&sigmaf; (mathēmatik&oacute;s), meaning "related to learning" or "studious", which likewise further came to mean "mathematical". In particular, &mu;&alpha;&theta;&eta;&mu;&alpha;&tau;&iota;&kappa;ὴ &tau;έ&chi;&nu;&eta; (mathēmatikḗ t&eacute;khnē), Latin: ars mathematica, meant "the mathematical art".</p>
<p><br />In Latin, and in English until around 1700, the term mathematics more commonly meant "astrology" (or sometimes "astronomy") rather than "mathematics"; the meaning gradually changed to its present one from about 1500 to 1800. This has resulted in several mistranslations: a particularly notorious one is Saint Augustine''s warning that Christians should beware of mathematici meaning astrologers, which is sometimes mistranslated as a condemnation of mathematicians.</p>
<p><br />The apparent plural form in English, like the French plural form les math&eacute;matiques (and the less commonly used singular derivative la math&eacute;matique), goes back to the Latin neuter plural mathematica (Cicero), based on the Greek plural &tau;&alpha; &mu;&alpha;&theta;&eta;&mu;&alpha;&tau;&iota;&kappa;ά (ta mathēmatik&aacute;), used by Aristotle (384&ndash;322 BC), and meaning roughly "all things mathematical"; although it is plausible that English borrowed only the adjective mathematic(al) and formed the noun mathematics anew, after the pattern of physics and metaphysics, which were inherited from the Greek.</p>
<p>In English, the noun mathematics takes singular verb forms. It is often shortened to maths or, in English-speaking North America, math.</p>', 4, 'text', '2012-12-21 11:25:48.115989', '2012-12-21 11:27:41.042553');
INSERT INTO slides VALUES (134, 11, 'Pitagora', '<p>Pythagoras of Samos (Ancient Greek: &Pi;&upsilon;&theta;&alpha;&gamma;ό&rho;&alpha;&sigmaf; ὁ &Sigma;ά&mu;&iota;&omicron;&sigmaf; [&Pi;&upsilon;&theta;&alpha;&gamma;ό&rho;&eta;&sigmaf; in Ionian Greek] Pythag&oacute;ras ho S&aacute;mios "Pythagoras the Samian", or simply &Pi;&upsilon;&theta;&alpha;&gamma;ό&rho;&alpha;&sigmaf;; b. about 570 &ndash; d. about 495 BC) was an Ionian Greek philosopher, mathematician, and founder of the religious movement called Pythagoreanism. Most of the information about Pythagoras was written down centuries after he lived, so very little reliable information is known about him.</p>
<p>He was born on the island of Samos, and might have travelled widely in his youth, visiting Egypt and other places seeking knowledge. Around 530 BC, he moved to Croton, a Greek colony in southern Italy, and there set up a religious sect. His followers pursued the religious rites and practices developed by Pythagoras, and studied his philosophical theories. The society took an active role in the politics of Croton, but this eventually led to their downfall. The Pythagorean meeting-places were burned, and Pythagoras was forced to flee the city. He is said to have ended his days in Metapontum.</p>
<p><br />Pythagoras made influential contributions to philosophy and religious teaching in the late 6th century BC. He is often revered as a great mathematician, mystic and scientist, but he is best known for the Pythagorean theorem which bears his name.</p>', 5, 'image1', '2012-12-21 11:37:30.683782', '2012-12-21 11:38:42.634045');
INSERT INTO slides VALUES (142, 12, NULL, NULL, 6, 'image3', '2012-12-21 11:42:11.228001', '2012-12-21 11:43:29.727697');
INSERT INTO slides VALUES (133, 12, NULL, NULL, 13, 'image3', '2012-12-21 11:32:34.082416', '2012-12-21 13:06:16.276106');
INSERT INTO slides VALUES (136, 12, NULL, NULL, 14, 'image3', '2012-12-21 11:40:01.849082', '2012-12-21 13:06:16.281791');
INSERT INTO slides VALUES (137, 12, NULL, NULL, 15, 'image3', '2012-12-21 11:40:17.498591', '2012-12-21 13:06:16.287298');
INSERT INTO slides VALUES (138, 12, NULL, NULL, 16, 'image3', '2012-12-21 11:40:28.237636', '2012-12-21 13:06:16.292934');
INSERT INTO slides VALUES (140, 12, NULL, NULL, 17, 'image4', '2012-12-21 11:40:47.534434', '2012-12-21 13:06:16.29842');
INSERT INTO slides VALUES (139, 12, NULL, NULL, 18, 'image3', '2012-12-21 11:40:43.798767', '2012-12-21 13:06:16.303901');
INSERT INTO slides VALUES (146, 12, 'External links', '<p><em><a class="external text" href="http://lejournaldelaphotographie.com/entries/7260/josef-koudelka-s-latest-book-lime" rel="nofollow">2012 Josef Koudelka latest book&nbsp;: Lime</a></em>&nbsp;on the Website Le Journal de la Photographie</p>
<p><br /><em><a class="external text" href="http://www.magnumphotos.com/Archive/C.aspx?VP=XSpecific_MAG.PhotographerDetail_VPage&amp;l1=0&amp;pid=2K7O3R135R3G&amp;nm=Josef%20Koudelka" rel="nofollow">Josef Koudelka at Magnum Photos</a></em></p>
<p><br /><em><a class="external text" href="http://www.masters-of-photography.com/K/koudelka/koudelka.html" rel="nofollow">Josef Koudelka at Masters of Photography</a></em></p>
<p><br /><em><a class="external text" href="http://www.horvatland.com/pages/entrevues/05-koudelka-en_en.htm" rel="nofollow">Entre Vues&nbsp;: Frank Horvat &ndash; Joseph Koudelka</a></em>, interviews with Frank Horvat</p>
<p><br /><em><a class="external text" href="http://www.masters-of-photography.com/K/koudelka/koudelka_articles2.html" rel="nofollow">On Exile</a></em>, by&nbsp;<a title="Czesław Miłosz" href="http://en.wikipedia.org/wiki/Czes%C5%82aw_Mi%C5%82osz">Czesław Miłosz</a>, introductory text from&nbsp;<em>Exiles</em>&nbsp;(1988)]</p>
<p><br /><em><a class="external text" href="http://query.nytimes.com/gst/fullpage.html?res=9F0CE7D61539F93AA35756C0A965958260&amp;sec=&amp;pagewanted=all" rel="nofollow">Photography View: Josef Koudelka''s Melancholy Visions of Gypsy Life</a></em>&nbsp;New York Times</p>
<p><br /><em><a class="external text" href="http://www.radio.cz/en/article/36309" rel="nofollow">A look at the Josef Koudelka retrospective</a></em>&nbsp;at the National Gallery''s Trades Fair Palace in Prague, 2003</p>
<p><br /><em><a class="external text" href="http://download.repubblica.it/pdf/domenica/2008/27042008.pdf" rel="nofollow">Praga ''68 &ndash; la Primavera di Koudelka</a></em>, La Domenica di Repubblica, article and interview about photographs of the Soviet invasion of Prague</p>
<p><br /><em><a class="external text" href="http://www.timesonline.co.uk/tol/news/world/europe/article3886309.ece" rel="nofollow">1968: Josef Koudelka and 1968, summer of hate</a></em>, interview in The Sunday Times</p>', 21, 'text', '2012-12-21 11:44:13.887302', '2012-12-21 13:06:43.437743');
INSERT INTO slides VALUES (170, 20, 'djhdjfhdjfhjd', '<p>ddjfkdjfkdj</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>', 7, 'video1', '2013-01-08 11:34:45.675699', '2013-01-08 11:35:06.395345');
INSERT INTO slides VALUES (171, 20, NULL, '<p>dddefhdj</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>', 8, 'audio', '2013-01-08 11:35:10.481541', '2013-01-08 11:35:30.948745');
INSERT INTO slides VALUES (172, 20, 'wwdwdwdwde', '<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>
<p class="p1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis&nbsp;</p>', 9, 'text', '2013-01-08 11:36:29.110756', '2013-01-08 11:36:41.194307');
INSERT INTO slides VALUES (173, 21, 'weref', NULL, 1, 'cover', '2013-01-09 09:57:44.947038', '2013-01-09 09:57:44.947038');
INSERT INTO slides VALUES (174, 22, 'J.M.Basquiat-Plush safe he think..', NULL, 1, 'cover', '2013-01-09 11:20:37.820101', '2013-01-09 11:20:37.820101');
INSERT INTO slides VALUES (175, 22, 'Jean-Michel Basquiat', '<p>Jean-Michel Basquiat, born in Brooklyn, New York after the death of his brother Max, was the second of four children of Matilda Andrades (July 28, 1934 &ndash; November 17, 2008) and Gerard Basquiat (born 1930). He had two younger sisters: Lisane, born in 1964, and Jeanine, born in 1967.</p>
<p>His father, Gerard Basquiat, was born in Port-au-Prince, Haiti, and his mother, Matilde Basquiat, was of Puerto Rican descent, born in Brooklyn, New York.</p>
<p>Basquiat was a precocious child who learned how to read and write by age four and was a gifted artist.[7] His teachers noticed his artistic abilities, and his mother encouraged her son''s artistic talent. By the age of eleven, Basquiat could fluently speak, read, and write French, Spanish, and English.</p>', 2, 'image1', '2013-01-09 11:20:37.885635', '2013-01-09 11:20:37.885635');
INSERT INTO slides VALUES (141, 12, NULL, NULL, 4, 'image3', '2012-12-21 11:41:54.865386', '2012-12-21 11:42:40.962626');
INSERT INTO slides VALUES (176, 22, NULL, NULL, 3, 'image3', '2013-01-09 11:20:37.896391', '2013-01-09 11:20:37.896391');
INSERT INTO slides VALUES (177, 22, 'SAMO IS DEAD', '<p>In September 1968, when Basquiat was about eight, he was hit by a car while playing in the street. His arm was broken and he suffered several internal injuries, and eventually underwent a splenectomy.</p>
<p>His parents separated that year and he and his sisters were raised by their father.</p>
<p>The family resided in Boerum Hill, Brooklyn, for five years, then moved to San Juan, Puerto Rico in 1974. After two years, they returned to New York City.[10] Then when he was eleven years old, his mother was committed to a mental institution and thereafter spent time in and out of institutions. At 15, Basquiat ran away from home.</p>
<p>He slept on park benches in Washington Square Park, and was arrested and returned to the care of his father within a week.</p>
<p>Basquiat dropped out of Edward R. Murrow High School in the tenth grade. His father banished him from the household and Basquiat stayed with friends in Brooklyn. He supported himself by selling T-shirts and homemade post cards. He also worked at the Unique Clothing Warehouse in West Broadway, Manhattan.</p>', 4, 'image1', '2013-01-09 11:20:37.906709', '2013-01-09 11:20:37.906709');
INSERT INTO slides VALUES (178, 22, NULL, NULL, 5, 'image2', '2013-01-09 11:20:37.917145', '2013-01-09 11:20:37.917145');
INSERT INTO slides VALUES (154, 14, 'Chinese', NULL, 1, 'cover', '2013-01-07 09:15:15.659963', '2013-01-07 09:15:15.659963');
INSERT INTO slides VALUES (155, 15, 'Chinese', NULL, 1, 'cover', '2013-01-07 09:18:27.802438', '2013-01-07 09:18:27.802438');
INSERT INTO slides VALUES (156, 16, 'Chinese', NULL, 1, 'cover', '2013-01-07 09:19:13.608119', '2013-01-07 09:19:13.608119');
INSERT INTO slides VALUES (157, 16, NULL, NULL, 2, 'video1', '2013-01-07 09:19:35.87262', '2013-01-07 09:19:35.87262');
INSERT INTO slides VALUES (158, 17, 'Chinese', NULL, 1, 'cover', '2013-01-07 09:19:53.937802', '2013-01-07 09:19:53.937802');
INSERT INTO slides VALUES (159, 17, NULL, NULL, 2, 'image3', '2013-01-07 09:20:30.496164', '2013-01-07 09:20:30.496164');
INSERT INTO slides VALUES (179, 22, NULL, NULL, 6, 'image2', '2013-01-09 11:20:37.932625', '2013-01-09 11:20:37.932625');
INSERT INTO slides VALUES (162, 19, 'Lezione 1', NULL, 1, 'cover', '2013-01-07 09:57:04.143888', '2013-01-07 09:58:14.280435');
INSERT INTO slides VALUES (163, 19, NULL, NULL, 2, 'image2', '2013-01-07 10:01:07.500326', '2013-01-07 10:01:07.500326');
INSERT INTO slides VALUES (164, 20, 'Lezione di prova', NULL, 1, 'cover', '2013-01-08 11:29:36.041661', '2013-01-08 11:29:36.041661');
INSERT INTO slides VALUES (180, 22, 'Final years and death', '<p><span class="size2">By 1986, Basquiat had left the Annina Nosei gallery, and was showing in the famous Mary Boone gallery in SoHo. On February 10, 1985, he appeared on the cover of The New York Times Magazine in a feature entitled "New Art, New Money: The Marketing of an American Artist".</span></p>
<p><span class="size2">He was a successful artist in this period, but his growing heroin addiction began to interfere with his personal relationships.</span><br /><span class="size2">When Andy Warhol died on February 22, 1987, Basquiat became increasingly isolated, and his heroin addiction and depression grew more severe.</span></p>
<p><span class="size2">Despite an attempt at sobriety during a trip to Maui, Hawaii, Basquiat died on August 12, 1988, of a heroin overdose at his art studio in Great Jones Street in New York City''s NoHo neighborhood. He was 27.</span></p>
<p><span class="size2">Basquiat was interred in Brooklyn''s Green-Wood Cemetery.</span></p>', 7, 'text', '2013-01-09 11:20:37.948113', '2013-01-09 11:20:37.948113');
INSERT INTO slides VALUES (181, 22, NULL, '<p><span class="size4" style="color: #ff00ff;">Mi piacerebbe averlo ....</span></p>
<p><span class="size4" style="color: #ff00ff;"> se Walter me lo regalasse!!</span></p>', 8, 'image1', '2013-01-09 11:25:00.259177', '2013-01-09 11:26:17.760463');
INSERT INTO slides VALUES (182, 23, 'Visive arts', NULL, 1, 'cover', '2013-01-09 13:28:41.419829', '2013-01-09 13:28:41.419829');
INSERT INTO slides VALUES (183, 23, 'The life is color', NULL, 2, 'image1', '2013-01-09 13:29:15.384632', '2013-01-09 13:29:31.878014');


--
-- Data for Name: media_elements_slides; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO media_elements_slides VALUES (1, 68, 1, 1, '2012-12-20 13:42:46.346762', '2012-12-20 13:42:46.346762', '', 0);
INSERT INTO media_elements_slides VALUES (2, 71, 2, 1, '2012-12-20 13:44:43.233056', '2012-12-20 13:44:43.233056', 'Jean-Michel Basquiat', -135);
INSERT INTO media_elements_slides VALUES (3, 69, 3, 1, '2012-12-20 13:45:23.395757', '2012-12-20 13:45:23.395757', 'J.M.Basquiat - The King', -38);
INSERT INTO media_elements_slides VALUES (4, 66, 4, 1, '2012-12-20 13:47:57.876905', '2012-12-20 13:47:57.876905', '', -41);
INSERT INTO media_elements_slides VALUES (5, 70, 5, 1, '2012-12-20 13:48:25.089417', '2012-12-20 13:48:25.089417', '', -36);
INSERT INTO media_elements_slides VALUES (6, 72, 5, 2, '2012-12-20 13:48:25.096398', '2012-12-20 13:48:25.096398', '', -47);
INSERT INTO media_elements_slides VALUES (7, 65, 7, 1, '2012-12-20 14:05:57.3276', '2012-12-20 14:05:57.3276', '', -29);
INSERT INTO media_elements_slides VALUES (8, 67, 7, 2, '2012-12-20 14:05:57.334637', '2012-12-20 14:05:57.334637', '', -89);
INSERT INTO media_elements_slides VALUES (9, 74, 8, 1, '2012-12-20 14:55:29.109435', '2012-12-20 14:55:29.109435', '', -31);
INSERT INTO media_elements_slides VALUES (10, 26, 10, 1, '2012-12-20 14:55:54.7366', '2012-12-20 14:55:54.7366', '', 0);
INSERT INTO media_elements_slides VALUES (12, 25, 13, 1, '2012-12-20 14:58:01.535165', '2012-12-20 14:58:01.535165', '', -29);
INSERT INTO media_elements_slides VALUES (13, 73, 14, 1, '2012-12-20 14:58:12.997373', '2012-12-20 14:58:12.997373', '', 0);
INSERT INTO media_elements_slides VALUES (14, 76, 15, 1, '2012-12-20 14:58:36.316227', '2012-12-20 14:58:36.316227', '', 0);
INSERT INTO media_elements_slides VALUES (11, 75, 11, 1, '2012-12-20 14:56:20.753748', '2012-12-20 15:05:43.673509', '', -100);
INSERT INTO media_elements_slides VALUES (15, 27, 17, 1, '2012-12-20 15:22:08.950571', '2012-12-20 15:22:08.950571', '', -115);
INSERT INTO media_elements_slides VALUES (16, 4, 18, 1, '2012-12-20 15:24:46.29237', '2012-12-20 15:24:46.29237', '', 0);
INSERT INTO media_elements_slides VALUES (19, 3, 20, 1, '2012-12-20 15:26:12.22633', '2012-12-20 15:26:12.22633', 'Staten Island', -143);
INSERT INTO media_elements_slides VALUES (17, 7, 19, 1, '2012-12-20 15:25:35.312685', '2012-12-20 15:26:50.939979', 'MOMA - Museum of Modern Art', 0);
INSERT INTO media_elements_slides VALUES (18, 22, 19, 2, '2012-12-20 15:25:35.318785', '2012-12-20 15:26:50.94744', 'MOMA - Museum of Modern Art', 0);
INSERT INTO media_elements_slides VALUES (20, 30, 21, 1, '2012-12-20 15:27:52.61853', '2012-12-20 15:27:52.61853', 'Brooklin Bridge', -48);
INSERT INTO media_elements_slides VALUES (21, 19, 22, 1, '2012-12-20 15:31:28.638819', '2012-12-20 15:31:28.638819', 'Harlem', 0);
INSERT INTO media_elements_slides VALUES (22, 82, 16, 1, '2012-12-20 16:27:30.1293', '2012-12-20 16:27:30.1293', '', 0);
INSERT INTO media_elements_slides VALUES (23, 78, 27, 1, '2012-12-20 16:33:36.404533', '2012-12-20 16:33:36.404533', '', -23);
INSERT INTO media_elements_slides VALUES (24, 90, 26, 1, '2012-12-20 16:34:54.781224', '2012-12-20 16:34:54.781224', 'Pleiadi', 0);
INSERT INTO media_elements_slides VALUES (25, 77, 28, 1, '2012-12-20 16:35:31.150074', '2012-12-20 16:35:31.150074', '', -147);
INSERT INTO media_elements_slides VALUES (28, 83, 31, 1, '2012-12-20 16:37:53.324446', '2012-12-20 16:37:53.324446', 'Egon Schiele', -23);
INSERT INTO media_elements_slides VALUES (30, 80, 34, 1, '2012-12-20 16:39:10.675418', '2012-12-20 16:39:10.675418', 'Arthur Roessler', -66);
INSERT INTO media_elements_slides VALUES (31, 99, 37, 1, '2012-12-20 16:45:48.011353', '2012-12-20 16:45:48.011353', '', -121);
INSERT INTO media_elements_slides VALUES (33, 89, 23, 1, '2012-12-20 16:51:13.823607', '2012-12-20 16:51:13.823607', '', -265);
INSERT INTO media_elements_slides VALUES (85, 127, 101, 1, '2012-12-21 10:05:29.876563', '2012-12-21 10:05:29.876563', '', 0);
INSERT INTO media_elements_slides VALUES (34, 91, 42, 1, '2012-12-20 16:53:00.759449', '2012-12-20 16:59:22.541907', 'Andy Warhol in New York', 0);
INSERT INTO media_elements_slides VALUES (36, 89, 45, 1, '2012-12-20 17:03:45.445751', '2012-12-20 17:03:45.445751', '', 0);
INSERT INTO media_elements_slides VALUES (37, 93, 48, 1, '2012-12-20 17:06:02.498925', '2012-12-20 17:06:02.498925', 'Keith Haring', -151);
INSERT INTO media_elements_slides VALUES (39, 101, 51, 1, '2012-12-20 17:09:27.320098', '2012-12-20 17:09:27.320098', 'Mario Schifano', -62);
INSERT INTO media_elements_slides VALUES (40, 98, 52, 1, '2012-12-20 17:09:47.702411', '2012-12-20 17:09:47.702411', 'Mario Schifano', 0);
INSERT INTO media_elements_slides VALUES (41, 102, 53, 1, '2012-12-20 17:10:52.992452', '2012-12-20 17:10:52.992452', '', -13);
INSERT INTO media_elements_slides VALUES (42, 97, 54, 1, '2012-12-20 17:11:19.725836', '2012-12-20 17:11:19.725836', 'Mimmo Rotella', 0);
INSERT INTO media_elements_slides VALUES (43, 95, 30, 1, '2012-12-21 08:11:25.35044', '2012-12-21 08:11:25.35044', 'Angry', -138);
INSERT INTO media_elements_slides VALUES (44, 104, 56, 1, '2012-12-21 08:39:40.382773', '2012-12-21 08:39:40.382773', 'Temple', -80);
INSERT INTO media_elements_slides VALUES (45, 107, 57, 1, '2012-12-21 08:43:27.068383', '2012-12-21 08:45:37.102865', '', -51);
INSERT INTO media_elements_slides VALUES (46, 106, 57, 2, '2012-12-21 08:43:27.125964', '2012-12-21 08:45:37.160765', 'Maize', -69);
INSERT INTO media_elements_slides VALUES (32, 100, 39, 1, '2012-12-20 16:49:33.412043', '2012-12-21 09:10:02.599361', 'Gustav Klimt, The Kiss (1908)', 0);
INSERT INTO media_elements_slides VALUES (38, 110, 49, 1, '2012-12-20 17:08:29.010353', '2012-12-21 09:24:45.898775', '', -40);
INSERT INTO media_elements_slides VALUES (26, 112, 29, 1, '2012-12-20 16:36:16.664302', '2012-12-21 09:26:35.302007', '', 0);
INSERT INTO media_elements_slides VALUES (27, 115, 29, 2, '2012-12-20 16:36:16.672411', '2012-12-21 09:26:35.311045', '', 0);
INSERT INTO media_elements_slides VALUES (47, 79, 60, 1, '2012-12-21 09:27:03.644904', '2012-12-21 09:27:03.644904', '', 0);
INSERT INTO media_elements_slides VALUES (48, 86, 60, 2, '2012-12-21 09:27:03.653195', '2012-12-21 09:27:03.653195', '', 0);
INSERT INTO media_elements_slides VALUES (49, 114, 63, 1, '2012-12-21 09:27:42.617815', '2012-12-21 09:27:42.617815', 'House with Shingles, 1915', 0);
INSERT INTO media_elements_slides VALUES (50, 113, 64, 1, '2012-12-21 09:28:17.273909', '2012-12-21 09:28:17.273909', 'Die kleine Stadt II, 1912–1913', -129);
INSERT INTO media_elements_slides VALUES (53, 108, 66, 1, '2012-12-21 09:29:18.961311', '2012-12-21 09:29:18.961311', 'Seated woman with bent knee, 1917', 0);
INSERT INTO media_elements_slides VALUES (54, 111, 66, 2, '2012-12-21 09:29:18.969678', '2012-12-21 09:29:18.969678', 'Reserve infantry corporal, 1916', 0);
INSERT INTO media_elements_slides VALUES (51, 88, 65, 1, '2012-12-21 09:28:49.129202', '2012-12-21 09:29:39.53205', 'Female Nude', 0);
INSERT INTO media_elements_slides VALUES (52, 109, 65, 2, '2012-12-21 09:28:49.137591', '2012-12-21 09:29:39.541163', 'Friendship, 1913', 0);
INSERT INTO media_elements_slides VALUES (55, 81, 67, 1, '2012-12-21 09:30:10.154776', '2012-12-21 09:30:10.154776', 'Reclining nude, 1910', 0);
INSERT INTO media_elements_slides VALUES (56, 116, 62, 1, '2012-12-21 09:30:30.872707', '2012-12-21 09:30:40.561308', '', -28);
INSERT INTO media_elements_slides VALUES (58, 16, 72, 1, '2012-12-21 09:37:11.916246', '2012-12-21 09:37:11.916246', '', -80);
INSERT INTO media_elements_slides VALUES (59, 1, 74, 1, '2012-12-21 09:41:16.041991', '2012-12-21 09:41:16.041991', '', -88);
INSERT INTO media_elements_slides VALUES (60, 56, 75, 1, '2012-12-21 09:41:45.296817', '2012-12-21 09:41:45.296817', NULL, NULL);
INSERT INTO media_elements_slides VALUES (61, 126, 68, 1, '2012-12-21 09:42:03.031044', '2012-12-21 09:42:03.031044', '', 0);
INSERT INTO media_elements_slides VALUES (62, 118, 77, 1, '2012-12-21 09:43:15.817712', '2012-12-21 09:43:15.817712', 'Golconda', 0);
INSERT INTO media_elements_slides VALUES (63, 119, 77, 2, '2012-12-21 09:43:15.82605', '2012-12-21 09:43:15.82605', 'The Son of Man', 0);
INSERT INTO media_elements_slides VALUES (64, 15, 80, 1, '2012-12-21 09:45:01.8251', '2012-12-21 09:45:01.8251', '', -119);
INSERT INTO media_elements_slides VALUES (65, 40, 81, 1, '2012-12-21 09:45:23.222769', '2012-12-21 09:45:23.222769', NULL, NULL);
INSERT INTO media_elements_slides VALUES (66, 136, 79, 1, '2012-12-21 09:46:22.967294', '2012-12-21 09:46:22.967294', 'Les amants', -37);
INSERT INTO media_elements_slides VALUES (67, 122, 73, 1, '2012-12-21 09:47:53.457409', '2012-12-21 09:47:53.457409', '', 0);
INSERT INTO media_elements_slides VALUES (68, 140, 84, 1, '2012-12-21 09:54:44.8107', '2012-12-21 09:54:44.8107', '© Kevin Scanlon', -199);
INSERT INTO media_elements_slides VALUES (69, 139, 85, 1, '2012-12-21 09:55:14.666053', '2012-12-21 09:55:14.666053', '', 0);
INSERT INTO media_elements_slides VALUES (70, 120, 86, 1, '2012-12-21 09:56:29.374726', '2012-12-21 09:56:29.374726', '', 0);
INSERT INTO media_elements_slides VALUES (77, 130, 88, 1, '2012-12-21 09:59:31.993639', '2012-12-21 09:59:31.993639', '', 0);
INSERT INTO media_elements_slides VALUES (78, 124, 96, 1, '2012-12-21 09:59:51.412226', '2012-12-21 09:59:51.412226', '', 0);
INSERT INTO media_elements_slides VALUES (79, 134, 97, 1, '2012-12-21 10:00:11.18773', '2012-12-21 10:00:11.18773', '', 0);
INSERT INTO media_elements_slides VALUES (57, 5, 70, 1, '2012-12-21 09:32:57.193015', '2012-12-21 10:02:32.255892', '', 0);
INSERT INTO media_elements_slides VALUES (80, 123, 98, 1, '2012-12-21 10:04:41.229645', '2012-12-21 10:04:41.229645', '', 0);
INSERT INTO media_elements_slides VALUES (81, 141, 98, 2, '2012-12-21 10:04:41.238134', '2012-12-21 10:04:41.238134', '', 0);
INSERT INTO media_elements_slides VALUES (82, 137, 98, 3, '2012-12-21 10:04:41.246294', '2012-12-21 10:04:41.246294', '', 0);
INSERT INTO media_elements_slides VALUES (84, 125, 100, 1, '2012-12-21 10:05:20.482259', '2012-12-21 10:05:20.482259', '', 0);
INSERT INTO media_elements_slides VALUES (86, 131, 102, 1, '2012-12-21 10:05:38.481012', '2012-12-21 10:05:38.481012', '', 0);
INSERT INTO media_elements_slides VALUES (87, 128, 103, 1, '2012-12-21 10:05:46.368479', '2012-12-21 10:05:46.368479', '', 0);
INSERT INTO media_elements_slides VALUES (88, 135, 104, 1, '2012-12-21 10:05:56.70552', '2012-12-21 10:05:56.70552', '', 0);
INSERT INTO media_elements_slides VALUES (89, 138, 105, 1, '2012-12-21 10:07:23.865795', '2012-12-21 10:07:23.865795', '', -305);
INSERT INTO media_elements_slides VALUES (90, 129, 105, 2, '2012-12-21 10:07:23.874317', '2012-12-21 10:07:23.874317', '', -14);
INSERT INTO media_elements_slides VALUES (91, 132, 106, 1, '2012-12-21 10:07:52.991724', '2012-12-21 10:07:52.991724', '', 0);
INSERT INTO media_elements_slides VALUES (92, 142, 107, 1, '2012-12-21 10:28:57.661958', '2012-12-21 10:28:57.661958', '', 0);
INSERT INTO media_elements_slides VALUES (83, 147, 98, 4, '2012-12-21 10:04:41.254412', '2012-12-21 10:52:13.1617', '', 0);
INSERT INTO media_elements_slides VALUES (93, 133, 111, 1, '2012-12-21 10:52:32.321992', '2012-12-21 10:52:32.321992', '', 0);
INSERT INTO media_elements_slides VALUES (95, 161, 114, 1, '2012-12-21 11:20:18.893571', '2012-12-21 11:20:18.893571', '', 0);
INSERT INTO media_elements_slides VALUES (96, 166, 115, 1, '2012-12-21 11:20:58.257714', '2012-12-21 11:20:58.257714', '', -141);
INSERT INTO media_elements_slides VALUES (97, 152, 120, 1, '2012-12-21 11:22:26.963673', '2012-12-21 11:22:26.963673', '', 0);
INSERT INTO media_elements_slides VALUES (98, 162, 121, 1, '2012-12-21 11:22:35.469153', '2012-12-21 11:22:35.469153', '', 0);
INSERT INTO media_elements_slides VALUES (99, 151, 122, 1, '2012-12-21 11:22:42.924636', '2012-12-21 11:22:42.924636', '', 0);
INSERT INTO media_elements_slides VALUES (100, 150, 123, 1, '2012-12-21 11:22:50.785388', '2012-12-21 11:22:50.785388', '', 0);
INSERT INTO media_elements_slides VALUES (94, 167, 113, 1, '2012-12-21 10:55:26.258959', '2012-12-21 11:23:52.427481', '', -152);
INSERT INTO media_elements_slides VALUES (101, 53, 127, 1, '2012-12-21 11:25:26.315694', '2012-12-21 11:25:26.315694', NULL, NULL);
INSERT INTO media_elements_slides VALUES (102, 18, 128, 1, '2012-12-21 11:25:45.134247', '2012-12-21 11:25:45.134247', '', 0);
INSERT INTO media_elements_slides VALUES (103, 168, 130, 1, '2012-12-21 11:31:21.806828', '2012-12-21 11:31:21.806828', '', 0);
INSERT INTO media_elements_slides VALUES (104, 172, 131, 1, '2012-12-21 11:32:13.317665', '2012-12-21 11:32:13.317665', '', 0);
INSERT INTO media_elements_slides VALUES (105, 173, 131, 2, '2012-12-21 11:32:13.327108', '2012-12-21 11:32:13.327108', '', 0);
INSERT INTO media_elements_slides VALUES (106, 170, 131, 3, '2012-12-21 11:32:13.336424', '2012-12-21 11:32:13.336424', '', -7);
INSERT INTO media_elements_slides VALUES (107, 169, 131, 4, '2012-12-21 11:32:13.344802', '2012-12-21 11:32:13.344802', '', -11);
INSERT INTO media_elements_slides VALUES (108, 176, 134, 1, '2012-12-21 11:38:42.688803', '2012-12-21 11:38:42.688803', '', -51);
INSERT INTO media_elements_slides VALUES (109, 174, 133, 1, '2012-12-21 11:40:00.30981', '2012-12-21 11:40:00.30981', '', -240);
INSERT INTO media_elements_slides VALUES (110, 175, 136, 1, '2012-12-21 11:40:16.092501', '2012-12-21 11:40:16.092501', '', -18);
INSERT INTO media_elements_slides VALUES (111, 156, 137, 1, '2012-12-21 11:40:26.766421', '2012-12-21 11:40:26.766421', '', 0);
INSERT INTO media_elements_slides VALUES (112, 149, 138, 1, '2012-12-21 11:40:42.646896', '2012-12-21 11:40:42.646896', '', 0);
INSERT INTO media_elements_slides VALUES (113, 164, 140, 1, '2012-12-21 11:41:24.54894', '2012-12-21 11:41:24.54894', '', 0);
INSERT INTO media_elements_slides VALUES (114, 178, 140, 2, '2012-12-21 11:41:24.558581', '2012-12-21 11:41:24.558581', '', 0);
INSERT INTO media_elements_slides VALUES (115, 165, 140, 3, '2012-12-21 11:41:24.568726', '2012-12-21 11:41:24.568726', '', 0);
INSERT INTO media_elements_slides VALUES (116, 158, 140, 4, '2012-12-21 11:41:24.57769', '2012-12-21 11:41:24.57769', '', 0);
INSERT INTO media_elements_slides VALUES (117, 177, 139, 1, '2012-12-21 11:41:35.665489', '2012-12-21 11:41:35.665489', '', 0);
INSERT INTO media_elements_slides VALUES (118, 163, 141, 1, '2012-12-21 11:42:10.018516', '2012-12-21 11:42:10.018516', '', 0);
INSERT INTO media_elements_slides VALUES (119, 155, 142, 1, '2012-12-21 11:42:18.747436', '2012-12-21 11:42:18.747436', '', 0);
INSERT INTO media_elements_slides VALUES (120, 154, 144, 1, '2012-12-21 11:43:15.605944', '2012-12-21 11:43:15.605944', '', -11);
INSERT INTO media_elements_slides VALUES (121, 153, 145, 1, '2012-12-21 11:43:45.586465', '2012-12-21 11:43:45.586465', '', 0);
INSERT INTO media_elements_slides VALUES (127, 16, 164, 1, '2013-01-08 11:30:12.91465', '2013-01-08 11:30:12.91465', '', 0);
INSERT INTO media_elements_slides VALUES (128, 101, 165, 1, '2013-01-08 11:31:36.893355', '2013-01-08 11:31:36.893355', 'hhdgfhgdhfgdfhgdhgfh', 0);
INSERT INTO media_elements_slides VALUES (129, 183, 166, 1, '2013-01-08 11:31:52.205901', '2013-01-08 11:31:52.205901', '', 0);
INSERT INTO media_elements_slides VALUES (130, 40, 167, 1, '2013-01-08 11:32:33.357252', '2013-01-08 11:32:33.357252', NULL, NULL);
INSERT INTO media_elements_slides VALUES (131, 4, 168, 1, '2013-01-08 11:34:04.247126', '2013-01-08 11:34:04.247126', '', -155);
INSERT INTO media_elements_slides VALUES (132, 144, 168, 2, '2013-01-08 11:34:04.254456', '2013-01-08 11:34:04.254456', '', -177);
INSERT INTO media_elements_slides VALUES (133, 89, 168, 3, '2013-01-08 11:34:04.261424', '2013-01-08 11:34:04.261424', '', -106);
INSERT INTO media_elements_slides VALUES (134, 16, 168, 4, '2013-01-08 11:34:04.269282', '2013-01-08 11:34:04.269282', '', -39);
INSERT INTO media_elements_slides VALUES (135, 16, 169, 1, '2013-01-08 11:34:43.511559', '2013-01-08 11:34:43.511559', '', -184);
INSERT INTO media_elements_slides VALUES (136, 144, 169, 2, '2013-01-08 11:34:43.519601', '2013-01-08 11:34:43.519601', '', 0);
INSERT INTO media_elements_slides VALUES (137, 40, 170, 1, '2013-01-08 11:35:06.402321', '2013-01-08 11:35:06.402321', NULL, NULL);
INSERT INTO media_elements_slides VALUES (138, 68, 174, 1, '2013-01-09 11:20:37.878625', '2013-01-09 11:20:37.878625', '', 0);
INSERT INTO media_elements_slides VALUES (139, 71, 175, 1, '2013-01-09 11:20:37.892047', '2013-01-09 11:20:37.892047', 'Jean-Michel Basquiat', -135);
INSERT INTO media_elements_slides VALUES (140, 69, 176, 1, '2013-01-09 11:20:37.902462', '2013-01-09 11:20:37.902462', 'J.M.Basquiat - The King', -38);
INSERT INTO media_elements_slides VALUES (141, 66, 177, 1, '2013-01-09 11:20:37.912719', '2013-01-09 11:20:37.912719', '', -41);
INSERT INTO media_elements_slides VALUES (142, 70, 178, 1, '2013-01-09 11:20:37.923183', '2013-01-09 11:20:37.923183', '', -36);
INSERT INTO media_elements_slides VALUES (143, 72, 178, 2, '2013-01-09 11:20:37.928295', '2013-01-09 11:20:37.928295', '', -47);
INSERT INTO media_elements_slides VALUES (144, 65, 179, 1, '2013-01-09 11:20:37.938809', '2013-01-09 11:20:37.938809', '', -29);
INSERT INTO media_elements_slides VALUES (145, 67, 179, 2, '2013-01-09 11:20:37.943858', '2013-01-09 11:20:37.943858', '', -89);
INSERT INTO media_elements_slides VALUES (146, 191, 181, 1, '2013-01-09 11:26:17.768184', '2013-01-09 11:26:17.768184', '', 0);
INSERT INTO media_elements_slides VALUES (147, 101, 182, 1, '2013-01-09 13:29:11.136551', '2013-01-09 13:29:11.136551', '', -96);


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO tags VALUES (1, 'animal', '2012-12-20 10:31:33.220098', '2012-12-20 10:31:33.220098');
INSERT INTO tags VALUES (2, 'smile', '2012-12-20 10:31:33.257366', '2012-12-20 10:31:33.257366');
INSERT INTO tags VALUES (3, 'teeth', '2012-12-20 10:31:33.266275', '2012-12-20 10:31:33.266275');
INSERT INTO tags VALUES (4, 'nature', '2012-12-20 10:31:33.274483', '2012-12-20 10:31:33.274483');
INSERT INTO tags VALUES (5, 'science', '2012-12-20 10:31:33.282583', '2012-12-20 10:31:33.282583');
INSERT INTO tags VALUES (6, 'future', '2012-12-20 10:31:33.845171', '2012-12-20 10:31:33.845171');
INSERT INTO tags VALUES (7, 'architecture', '2012-12-20 10:31:33.854222', '2012-12-20 10:31:33.854222');
INSERT INTO tags VALUES (8, 'art', '2012-12-20 10:31:33.862517', '2012-12-20 10:31:33.862517');
INSERT INTO tags VALUES (9, 'design', '2012-12-20 10:31:33.870609', '2012-12-20 10:31:33.870609');
INSERT INTO tags VALUES (10, 'spain', '2012-12-20 10:31:33.878785', '2012-12-20 10:31:33.878785');
INSERT INTO tags VALUES (11, 'valencia', '2012-12-20 10:31:33.886825', '2012-12-20 10:31:33.886825');
INSERT INTO tags VALUES (12, 'geography', '2012-12-20 10:31:33.894847', '2012-12-20 10:31:33.894847');
INSERT INTO tags VALUES (13, 'birds', '2012-12-20 10:31:34.52464', '2012-12-20 10:31:34.52464');
INSERT INTO tags VALUES (14, 'fly', '2012-12-20 10:31:34.533235', '2012-12-20 10:31:34.533235');
INSERT INTO tags VALUES (15, 'sea', '2012-12-20 10:31:34.541485', '2012-12-20 10:31:34.541485');
INSERT INTO tags VALUES (16, 'sky', '2012-12-20 10:31:34.549671', '2012-12-20 10:31:34.549671');
INSERT INTO tags VALUES (17, 'new york', '2012-12-20 10:31:34.557702', '2012-12-20 10:31:34.557702');
INSERT INTO tags VALUES (18, 'city', '2012-12-20 10:31:35.282103', '2012-12-20 10:31:35.282103');
INSERT INTO tags VALUES (19, 'traffic', '2012-12-20 10:31:35.291356', '2012-12-20 10:31:35.291356');
INSERT INTO tags VALUES (20, 'urban', '2012-12-20 10:31:35.299782', '2012-12-20 10:31:35.299782');
INSERT INTO tags VALUES (21, 'reptile', '2012-12-20 10:31:35.892874', '2012-12-20 10:31:35.892874');
INSERT INTO tags VALUES (22, 'iguana', '2012-12-20 10:31:35.906492', '2012-12-20 10:31:35.906492');
INSERT INTO tags VALUES (23, 'energy', '2012-12-20 10:31:37.27173', '2012-12-20 10:31:37.27173');
INSERT INTO tags VALUES (24, 'wind', '2012-12-20 10:31:37.280291', '2012-12-20 10:31:37.280291');
INSERT INTO tags VALUES (25, 'museum', '2012-12-20 10:31:37.946644', '2012-12-20 10:31:37.946644');
INSERT INTO tags VALUES (26, 'love', '2012-12-20 10:31:37.955134', '2012-12-20 10:31:37.955134');
INSERT INTO tags VALUES (27, 'creative', '2012-12-20 10:31:37.969285', '2012-12-20 10:31:37.969285');
INSERT INTO tags VALUES (28, 'idea', '2012-12-20 10:31:37.977483', '2012-12-20 10:31:37.977483');
INSERT INTO tags VALUES (29, 'mom', '2012-12-20 10:31:37.985806', '2012-12-20 10:31:37.985806');
INSERT INTO tags VALUES (30, 'close', '2012-12-20 10:31:37.99401', '2012-12-20 10:31:37.99401');
INSERT INTO tags VALUES (31, 'optical', '2012-12-20 10:31:38.499262', '2012-12-20 10:31:38.499262');
INSERT INTO tags VALUES (32, 'disc', '2012-12-20 10:31:38.50762', '2012-12-20 10:31:38.50762');
INSERT INTO tags VALUES (33, 'compact disc', '2012-12-20 10:31:38.515968', '2012-12-20 10:31:38.515968');
INSERT INTO tags VALUES (34, 'music', '2012-12-20 10:31:38.524342', '2012-12-20 10:31:38.524342');
INSERT INTO tags VALUES (35, 'light', '2012-12-20 10:31:38.532502', '2012-12-20 10:31:38.532502');
INSERT INTO tags VALUES (36, 'laser', '2012-12-20 10:31:38.540665', '2012-12-20 10:31:38.540665');
INSERT INTO tags VALUES (37, 'color', '2012-12-20 10:31:39.149981', '2012-12-20 10:31:39.149981');
INSERT INTO tags VALUES (38, 'flower', '2012-12-20 10:31:39.158314', '2012-12-20 10:31:39.158314');
INSERT INTO tags VALUES (39, 'air', '2012-12-20 10:31:39.166531', '2012-12-20 10:31:39.166531');
INSERT INTO tags VALUES (40, 'smell', '2012-12-20 10:31:39.174647', '2012-12-20 10:31:39.174647');
INSERT INTO tags VALUES (41, 'battery', '2012-12-20 10:31:39.732494', '2012-12-20 10:31:39.732494');
INSERT INTO tags VALUES (42, 'electric', '2012-12-20 10:31:39.741148', '2012-12-20 10:31:39.741148');
INSERT INTO tags VALUES (43, 'rome', '2012-12-20 10:31:40.387993', '2012-12-20 10:31:40.387993');
INSERT INTO tags VALUES (44, 'history', '2012-12-20 10:31:40.397464', '2012-12-20 10:31:40.397464');
INSERT INTO tags VALUES (45, 'roman', '2012-12-20 10:31:40.411669', '2012-12-20 10:31:40.411669');
INSERT INTO tags VALUES (46, 'temple', '2012-12-20 10:31:40.42005', '2012-12-20 10:31:40.42005');
INSERT INTO tags VALUES (47, 'god', '2012-12-20 10:31:40.428273', '2012-12-20 10:31:40.428273');
INSERT INTO tags VALUES (48, 'ancient', '2012-12-20 10:31:40.436559', '2012-12-20 10:31:40.436559');
INSERT INTO tags VALUES (49, 'lawn', '2012-12-20 10:31:40.969952', '2012-12-20 10:31:40.969952');
INSERT INTO tags VALUES (50, 'ear', '2012-12-20 10:31:40.991024', '2012-12-20 10:31:40.991024');
INSERT INTO tags VALUES (51, 'wood', '2012-12-20 10:31:42.495374', '2012-12-20 10:31:42.495374');
INSERT INTO tags VALUES (52, 'paper', '2012-12-20 10:31:42.510556', '2012-12-20 10:31:42.510556');
INSERT INTO tags VALUES (53, 'river', '2012-12-20 10:31:43.15516', '2012-12-20 10:31:43.15516');
INSERT INTO tags VALUES (54, 'bridge', '2012-12-20 10:31:43.163636', '2012-12-20 10:31:43.163636');
INSERT INTO tags VALUES (55, 'water', '2012-12-20 10:31:43.18289', '2012-12-20 10:31:43.18289');
INSERT INTO tags VALUES (56, 'bee', '2012-12-20 10:31:43.766325', '2012-12-20 10:31:43.766325');
INSERT INTO tags VALUES (57, 'honey', '2012-12-20 10:31:43.792651', '2012-12-20 10:31:43.792651');
INSERT INTO tags VALUES (58, 'gas', '2012-12-20 10:31:44.948988', '2012-12-20 10:31:44.948988');
INSERT INTO tags VALUES (59, 'fire', '2012-12-20 10:31:44.957713', '2012-12-20 10:31:44.957713');
INSERT INTO tags VALUES (60, 'energie', '2012-12-20 10:31:44.965992', '2012-12-20 10:31:44.965992');
INSERT INTO tags VALUES (61, 'school', '2012-12-20 10:31:45.507135', '2012-12-20 10:31:45.507135');
INSERT INTO tags VALUES (62, 'computer', '2012-12-20 10:31:45.516429', '2012-12-20 10:31:45.516429');
INSERT INTO tags VALUES (63, 'maths', '2012-12-20 10:31:45.536237', '2012-12-20 10:31:45.536237');
INSERT INTO tags VALUES (64, 'student', '2012-12-20 10:31:45.544549', '2012-12-20 10:31:45.544549');
INSERT INTO tags VALUES (65, 'mother', '2012-12-20 10:31:45.552662', '2012-12-20 10:31:45.552662');
INSERT INTO tags VALUES (66, 'woman', '2012-12-20 10:31:46.192915', '2012-12-20 10:31:46.192915');
INSERT INTO tags VALUES (67, 'colored', '2012-12-20 10:31:46.207096', '2012-12-20 10:31:46.207096');
INSERT INTO tags VALUES (68, 'walk', '2012-12-20 10:31:46.215525', '2012-12-20 10:31:46.215525');
INSERT INTO tags VALUES (69, 'modern', '2012-12-20 10:31:47.735375', '2012-12-20 10:31:47.735375');
INSERT INTO tags VALUES (70, 'peacock', '2012-12-20 10:31:48.313201', '2012-12-20 10:31:48.313201');
INSERT INTO tags VALUES (71, 'bird', '2012-12-20 10:31:48.333502', '2012-12-20 10:31:48.333502');
INSERT INTO tags VALUES (72, 'people', '2012-12-20 10:31:48.980609', '2012-12-20 10:31:48.980609');
INSERT INTO tags VALUES (73, 'culture', '2012-12-20 10:31:49.0012', '2012-12-20 10:31:49.0012');
INSERT INTO tags VALUES (74, 'money', '2012-12-20 10:31:49.88796', '2012-12-20 10:31:49.88796');
INSERT INTO tags VALUES (75, 'airport', '2012-12-20 10:31:50.240202', '2012-12-20 10:31:50.240202');
INSERT INTO tags VALUES (76, 'london', '2012-12-20 10:31:50.249702', '2012-12-20 10:31:50.249702');
INSERT INTO tags VALUES (77, 'departure', '2012-12-20 10:31:50.26368', '2012-12-20 10:31:50.26368');
INSERT INTO tags VALUES (78, 'underground', '2012-12-20 10:31:51.298119', '2012-12-20 10:31:51.298119');
INSERT INTO tags VALUES (79, 'train', '2012-12-20 10:31:51.320268', '2012-12-20 10:31:51.320268');
INSERT INTO tags VALUES (80, 'plane', '2012-12-20 10:31:52.66275', '2012-12-20 10:31:52.66275');
INSERT INTO tags VALUES (81, 'egypt', '2012-12-20 10:31:55.424576', '2012-12-20 10:31:55.424576');
INSERT INTO tags VALUES (82, 'dna', '2012-12-20 10:31:57.242241', '2012-12-20 10:31:57.242241');
INSERT INTO tags VALUES (83, 'chemical', '2012-12-20 10:31:57.257605', '2012-12-20 10:31:57.257605');
INSERT INTO tags VALUES (84, 'organic', '2012-12-20 10:31:57.265944', '2012-12-20 10:31:57.265944');
INSERT INTO tags VALUES (85, 'polymer', '2012-12-20 10:31:57.27423', '2012-12-20 10:31:57.27423');
INSERT INTO tags VALUES (86, 'basic', '2012-12-20 10:31:57.282496', '2012-12-20 10:31:57.282496');
INSERT INTO tags VALUES (87, 'space', '2012-12-20 10:31:57.794628', '2012-12-20 10:31:57.794628');
INSERT INTO tags VALUES (88, 'planet', '2012-12-20 10:31:57.816169', '2012-12-20 10:31:57.816169');
INSERT INTO tags VALUES (89, 'interview', '2012-12-20 10:31:58.023193', '2012-12-20 10:31:58.023193');
INSERT INTO tags VALUES (90, 'power', '2012-12-20 10:31:58.045346', '2012-12-20 10:31:58.045346');
INSERT INTO tags VALUES (91, 'numbers', '2012-12-20 10:31:58.266048', '2012-12-20 10:31:58.266048');
INSERT INTO tags VALUES (92, 'principles', '2012-12-20 10:31:58.491899', '2012-12-20 10:31:58.491899');
INSERT INTO tags VALUES (93, 'digital', '2012-12-20 10:31:58.976824', '2012-12-20 10:31:58.976824');
INSERT INTO tags VALUES (94, 'sound', '2012-12-20 10:31:58.986187', '2012-12-20 10:31:58.986187');
INSERT INTO tags VALUES (95, 'audio', '2012-12-20 10:31:58.996074', '2012-12-20 10:31:58.996074');
INSERT INTO tags VALUES (96, 'song', '2012-12-20 10:31:59.006026', '2012-12-20 10:31:59.006026');
INSERT INTO tags VALUES (97, 'atom', '2012-12-20 10:32:00.809028', '2012-12-20 10:32:00.809028');
INSERT INTO tags VALUES (98, 'neutrons', '2012-12-20 10:32:00.823322', '2012-12-20 10:32:00.823322');
INSERT INTO tags VALUES (99, 'molecules', '2012-12-20 10:32:00.831469', '2012-12-20 10:32:00.831469');
INSERT INTO tags VALUES (100, 'electrons', '2012-12-20 10:32:00.839547', '2012-12-20 10:32:00.839547');
INSERT INTO tags VALUES (101, 'bacteria', '2012-12-20 10:32:01.204552', '2012-12-20 10:32:01.204552');
INSERT INTO tags VALUES (102, 'microscope', '2012-12-20 10:32:01.224911', '2012-12-20 10:32:01.224911');
INSERT INTO tags VALUES (103, 'experiment', '2012-12-20 10:32:01.23873', '2012-12-20 10:32:01.23873');
INSERT INTO tags VALUES (104, 'laboratory', '2012-12-20 10:32:01.24693', '2012-12-20 10:32:01.24693');
INSERT INTO tags VALUES (105, 'cellular', '2012-12-20 10:32:01.792354', '2012-12-20 10:32:01.792354');
INSERT INTO tags VALUES (106, 'organism', '2012-12-20 10:32:01.823338', '2012-12-20 10:32:01.823338');
INSERT INTO tags VALUES (107, 'liquid', '2012-12-20 10:32:03.014094', '2012-12-20 10:32:03.014094');
INSERT INTO tags VALUES (108, 'sun', '2012-12-20 10:32:04.147252', '2012-12-20 10:32:04.147252');
INSERT INTO tags VALUES (109, 'chemistry', '2012-12-20 10:32:05.269554', '2012-12-20 10:32:05.269554');
INSERT INTO tags VALUES (110, 'ionic', '2012-12-20 10:32:05.954773', '2012-12-20 10:32:05.954773');
INSERT INTO tags VALUES (111, 'mathematics', '2012-12-20 10:32:06.580228', '2012-12-20 10:32:06.580228');
INSERT INTO tags VALUES (112, 'calculation', '2012-12-20 10:32:06.599494', '2012-12-20 10:32:06.599494');
INSERT INTO tags VALUES (113, 'equation', '2012-12-20 10:32:06.609482', '2012-12-20 10:32:06.609482');
INSERT INTO tags VALUES (114, 'geometry', '2012-12-20 10:32:07.135557', '2012-12-20 10:32:07.135557');
INSERT INTO tags VALUES (115, 'solid', '2012-12-20 10:32:07.144486', '2012-12-20 10:32:07.144486');
INSERT INTO tags VALUES (116, 'constructions', '2012-12-20 10:32:07.158877', '2012-12-20 10:32:07.158877');
INSERT INTO tags VALUES (117, 'floors', '2012-12-20 10:32:07.16826', '2012-12-20 10:32:07.16826');
INSERT INTO tags VALUES (118, 'objects', '2012-12-20 10:32:07.17839', '2012-12-20 10:32:07.17839');
INSERT INTO tags VALUES (119, 'renato zero', '2012-12-20 10:32:07.782252', '2012-12-20 10:32:07.782252');
INSERT INTO tags VALUES (120, 'triangle', '2012-12-20 10:32:07.840829', '2012-12-20 10:32:07.840829');
INSERT INTO tags VALUES (121, 'lab', '2012-12-20 10:32:08.51317', '2012-12-20 10:32:08.51317');
INSERT INTO tags VALUES (122, 'snail', '2012-12-20 10:32:09.713961', '2012-12-20 10:32:09.713961');
INSERT INTO tags VALUES (123, 'invertebrate', '2012-12-20 10:32:09.737193', '2012-12-20 10:32:09.737193');
INSERT INTO tags VALUES (124, 'ice', '2012-12-20 10:32:10.445659', '2012-12-20 10:32:10.445659');
INSERT INTO tags VALUES (125, 'titanic', '2012-12-20 10:32:10.460961', '2012-12-20 10:32:10.460961');
INSERT INTO tags VALUES (126, 'iceberg', '2012-12-20 10:32:10.469472', '2012-12-20 10:32:10.469472');
INSERT INTO tags VALUES (127, 'tragedy', '2012-12-20 10:32:10.477879', '2012-12-20 10:32:10.477879');
INSERT INTO tags VALUES (128, 'star', '2012-12-20 10:32:12.378006', '2012-12-20 10:32:12.378006');
INSERT INTO tags VALUES (129, 'virus', '2012-12-20 10:32:13.739898', '2012-12-20 10:32:13.739898');
INSERT INTO tags VALUES (130, 'biology', '2012-12-20 10:32:13.764383', '2012-12-20 10:32:13.764383');
INSERT INTO tags VALUES (131, 'museo', '2012-12-20 10:50:43.947811', '2012-12-20 10:50:43.947811');
INSERT INTO tags VALUES (132, 'logo', '2012-12-20 10:50:43.960993', '2012-12-20 10:50:43.960993');
INSERT INTO tags VALUES (133, 'arte', '2012-12-20 10:50:43.969906', '2012-12-20 10:50:43.969906');
INSERT INTO tags VALUES (134, 'basquiat', '2012-12-20 13:18:45.114062', '2012-12-20 13:18:45.114062');
INSERT INTO tags VALUES (135, 'usa', '2012-12-20 13:18:45.130267', '2012-12-20 13:18:45.130267');
INSERT INTO tags VALUES (136, 'pain', '2012-12-20 13:18:45.138727', '2012-12-20 13:18:45.138727');
INSERT INTO tags VALUES (137, 'paint', '2012-12-20 13:21:51.019331', '2012-12-20 13:21:51.019331');
INSERT INTO tags VALUES (138, 'samo', '2012-12-20 13:35:47.083402', '2012-12-20 13:35:47.083402');
INSERT INTO tags VALUES (139, 'ny', '2012-12-20 13:36:55.070121', '2012-12-20 13:36:55.070121');
INSERT INTO tags VALUES (140, 'ghost', '2012-12-20 13:37:53.229133', '2012-12-20 13:37:53.229133');
INSERT INTO tags VALUES (141, 'face', '2012-12-20 13:38:54.788795', '2012-12-20 13:38:54.788795');
INSERT INTO tags VALUES (142, 'english', '2012-12-20 14:26:18.725946', '2012-12-20 14:26:18.725946');
INSERT INTO tags VALUES (143, 'taxi', '2012-12-20 14:26:18.734689', '2012-12-20 14:26:18.734689');
INSERT INTO tags VALUES (144, 'car', '2012-12-20 14:28:12.909418', '2012-12-20 14:28:12.909418');
INSERT INTO tags VALUES (145, 'duffy', '2012-12-20 14:45:44.882071', '2012-12-20 14:45:44.882071');
INSERT INTO tags VALUES (146, 'pop', '2012-12-20 14:45:44.896747', '2012-12-20 14:45:44.896747');
INSERT INTO tags VALUES (147, 'lonfon', '2012-12-20 14:55:07.539698', '2012-12-20 14:55:07.539698');
INSERT INTO tags VALUES (148, 'phenomenon', '2012-12-20 14:59:28.731962', '2012-12-20 14:59:28.731962');
INSERT INTO tags VALUES (149, 'catastrophe', '2012-12-20 14:59:28.740022', '2012-12-20 14:59:28.740022');
INSERT INTO tags VALUES (150, 'predictions', '2012-12-20 14:59:28.74794', '2012-12-20 14:59:28.74794');
INSERT INTO tags VALUES (151, 'maya', '2012-12-20 14:59:28.755735', '2012-12-20 14:59:28.755735');
INSERT INTO tags VALUES (152, 'apple', '2012-12-20 15:21:55.921007', '2012-12-20 15:21:55.921007');
INSERT INTO tags VALUES (153, 'egon schiele', '2012-12-20 16:19:35.660822', '2012-12-20 16:19:35.660822');
INSERT INTO tags VALUES (154, 'portrait', '2012-12-20 16:19:35.674714', '2012-12-20 16:19:35.674714');
INSERT INTO tags VALUES (155, 'painting', '2012-12-20 16:19:35.683833', '2012-12-20 16:19:35.683833');
INSERT INTO tags VALUES (156, 'paintings', '2012-12-20 16:22:19.322912', '2012-12-20 16:22:19.322912');
INSERT INTO tags VALUES (157, 'self-portrait', '2012-12-20 16:22:19.331375', '2012-12-20 16:22:19.331375');
INSERT INTO tags VALUES (158, 'worhol', '2012-12-20 16:23:57.790431', '2012-12-20 16:23:57.790431');
INSERT INTO tags VALUES (159, 'painter', '2012-12-20 16:24:45.683843', '2012-12-20 16:24:45.683843');
INSERT INTO tags VALUES (160, 'expressionism', '2012-12-20 16:24:45.692419', '2012-12-20 16:24:45.692419');
INSERT INTO tags VALUES (161, 'astronomical', '2012-12-20 16:27:00.506155', '2012-12-20 16:27:00.506155');
INSERT INTO tags VALUES (162, 'calendar', '2012-12-20 16:27:00.515743', '2012-12-20 16:27:00.515743');
INSERT INTO tags VALUES (163, 'cataclysmic', '2012-12-20 16:27:00.53024', '2012-12-20 16:27:00.53024');
INSERT INTO tags VALUES (164, 'roy', '2012-12-20 16:30:23.135428', '2012-12-20 16:30:23.135428');
INSERT INTO tags VALUES (165, 'andy', '2012-12-20 16:32:57.562255', '2012-12-20 16:32:57.562255');
INSERT INTO tags VALUES (166, 'warhol', '2012-12-20 16:32:57.571938', '2012-12-20 16:32:57.571938');
INSERT INTO tags VALUES (167, 'lòkasd', '2012-12-20 16:33:59.301204', '2012-12-20 16:33:59.301204');
INSERT INTO tags VALUES (168, 'aslk', '2012-12-20 16:33:59.310955', '2012-12-20 16:33:59.310955');
INSERT INTO tags VALUES (169, 'cmnvbn', '2012-12-20 16:33:59.3197', '2012-12-20 16:33:59.3197');
INSERT INTO tags VALUES (170, 'shdjfh', '2012-12-20 16:33:59.328214', '2012-12-20 16:33:59.328214');
INSERT INTO tags VALUES (171, 'haring', '2012-12-20 16:38:23.515217', '2012-12-20 16:38:23.515217');
INSERT INTO tags VALUES (172, 'hering', '2012-12-20 16:39:25.424884', '2012-12-20 16:39:25.424884');
INSERT INTO tags VALUES (173, 'statue', '2012-12-20 16:39:39.789401', '2012-12-20 16:39:39.789401');
INSERT INTO tags VALUES (174, 'angry', '2012-12-20 16:39:39.804985', '2012-12-20 16:39:39.804985');
INSERT INTO tags VALUES (175, 'mimmo', '2012-12-20 16:42:06.270826', '2012-12-20 16:42:06.270826');
INSERT INTO tags VALUES (176, 'rotella', '2012-12-20 16:42:06.281172', '2012-12-20 16:42:06.281172');
INSERT INTO tags VALUES (177, 'italy', '2012-12-20 16:42:06.301925', '2012-12-20 16:42:06.301925');
INSERT INTO tags VALUES (178, 'artist', '2012-12-20 16:42:06.310349', '2012-12-20 16:42:06.310349');
INSERT INTO tags VALUES (179, 'wien', '2012-12-20 16:44:24.829881', '2012-12-20 16:44:24.829881');
INSERT INTO tags VALUES (180, 'academy of fine arts', '2012-12-20 16:44:24.839981', '2012-12-20 16:44:24.839981');
INSERT INTO tags VALUES (181, 'schiele', '2012-12-20 16:44:24.849295', '2012-12-20 16:44:24.849295');
INSERT INTO tags VALUES (182, 'austria', '2012-12-20 16:44:24.858444', '2012-12-20 16:44:24.858444');
INSERT INTO tags VALUES (183, 'gustav klimt', '2012-12-20 16:48:26.722762', '2012-12-20 16:48:26.722762');
INSERT INTO tags VALUES (184, 'coca cola', '2012-12-20 16:49:32.576967', '2012-12-20 16:49:32.576967');
INSERT INTO tags VALUES (185, 'mario schifano', '2012-12-20 16:50:32.128355', '2012-12-20 16:50:32.128355');
INSERT INTO tags VALUES (186, 'disaster', '2012-12-21 08:29:44.784484', '2012-12-21 08:29:44.784484');
INSERT INTO tags VALUES (187, 'prevision', '2012-12-21 08:29:44.8007', '2012-12-21 08:29:44.8007');
INSERT INTO tags VALUES (188, 'chiapas', '2012-12-21 08:39:08.435196', '2012-12-21 08:39:08.435196');
INSERT INTO tags VALUES (189, 'jungle', '2012-12-21 08:39:08.445223', '2012-12-21 08:39:08.445223');
INSERT INTO tags VALUES (190, 'mexican', '2012-12-21 08:39:08.45458', '2012-12-21 08:39:08.45458');
INSERT INTO tags VALUES (191, 'asjdlkdj', '2012-12-21 08:41:02.782665', '2012-12-21 08:41:02.782665');
INSERT INTO tags VALUES (192, 'aisudiosd', '2012-12-21 08:41:02.79335', '2012-12-21 08:41:02.79335');
INSERT INTO tags VALUES (193, 'asjdklj', '2012-12-21 08:41:02.803034', '2012-12-21 08:41:02.803034');
INSERT INTO tags VALUES (194, 'zxmnc', '2012-12-21 08:41:02.812635', '2012-12-21 08:41:02.812635');
INSERT INTO tags VALUES (195, 'female', '2012-12-21 08:42:46.39324', '2012-12-21 08:42:46.39324');
INSERT INTO tags VALUES (196, 'male', '2012-12-21 08:42:46.403492', '2012-12-21 08:42:46.403492');
INSERT INTO tags VALUES (197, 'calendrical', '2012-12-21 08:42:46.418754', '2012-12-21 08:42:46.418754');
INSERT INTO tags VALUES (198, 'elephant', '2012-12-21 08:45:04.003146', '2012-12-21 08:45:04.003146');
INSERT INTO tags VALUES (199, 'opdif', '2012-12-21 08:45:04.019951', '2012-12-21 08:45:04.019951');
INSERT INTO tags VALUES (200, 'xmc', '2012-12-21 08:45:04.029224', '2012-12-21 08:45:04.029224');
INSERT INTO tags VALUES (201, 'vnv', '2012-12-21 08:45:04.038085', '2012-12-21 08:45:04.038085');
INSERT INTO tags VALUES (202, 'oil', '2012-12-21 09:30:00.461135', '2012-12-21 09:30:00.461135');
INSERT INTO tags VALUES (203, 'brussels', '2012-12-21 09:30:00.469013', '2012-12-21 09:30:00.469013');
INSERT INTO tags VALUES (204, 'surrealist', '2012-12-21 09:30:00.476746', '2012-12-21 09:30:00.476746');
INSERT INTO tags VALUES (205, 'natural sciences', '2012-12-21 09:32:36.461933', '2012-12-21 09:32:36.461933');
INSERT INTO tags VALUES (206, 'animals', '2012-12-21 09:32:36.47066', '2012-12-21 09:32:36.47066');
INSERT INTO tags VALUES (207, 'world', '2012-12-21 09:32:36.484756', '2012-12-21 09:32:36.484756');
INSERT INTO tags VALUES (208, 'photo', '2012-12-21 09:33:21.28379', '2012-12-21 09:33:21.28379');
INSERT INTO tags VALUES (209, 'surrealism', '2012-12-21 09:33:21.29471', '2012-12-21 09:33:21.29471');
INSERT INTO tags VALUES (210, 'magritte', '2012-12-21 09:33:21.304193', '2012-12-21 09:33:21.304193');
INSERT INTO tags VALUES (211, 'photography', '2012-12-21 09:37:04.757976', '2012-12-21 09:37:04.757976');
INSERT INTO tags VALUES (212, 'reportage', '2012-12-21 09:37:04.814307', '2012-12-21 09:37:04.814307');
INSERT INTO tags VALUES (213, 'photojourmalism', '2012-12-21 09:37:04.829958', '2012-12-21 09:37:04.829958');
INSERT INTO tags VALUES (214, 'hand', '2012-12-21 09:37:53.947768', '2012-12-21 09:37:53.947768');
INSERT INTO tags VALUES (215, 'painted', '2012-12-21 09:37:53.958503', '2012-12-21 09:37:53.958503');
INSERT INTO tags VALUES (216, 'sebastião salgado', '2012-12-21 09:39:04.791268', '2012-12-21 09:39:04.791268');
INSERT INTO tags VALUES (217, 'social documentary', '2012-12-21 09:39:04.802066', '2012-12-21 09:39:04.802066');
INSERT INTO tags VALUES (218, 'photographer', '2012-12-21 09:39:04.810944', '2012-12-21 09:39:04.810944');
INSERT INTO tags VALUES (219, 'photojournalist', '2012-12-21 09:39:04.81979', '2012-12-21 09:39:04.81979');
INSERT INTO tags VALUES (220, 'sebastião', '2012-12-21 09:39:30.698264', '2012-12-21 09:39:30.698264');
INSERT INTO tags VALUES (221, 'photojournalism', '2012-12-21 09:40:47.883163', '2012-12-21 09:40:47.883163');
INSERT INTO tags VALUES (222, 'alaska', '2012-12-21 09:41:28.165515', '2012-12-21 09:41:28.165515');
INSERT INTO tags VALUES (223, 'africa', '2012-12-21 09:43:42.364458', '2012-12-21 09:43:42.364458');
INSERT INTO tags VALUES (224, 'journalism', '2012-12-21 09:44:19.574786', '2012-12-21 09:44:19.574786');
INSERT INTO tags VALUES (225, 'salgado', '2012-12-21 09:51:58.779206', '2012-12-21 09:51:58.779206');
INSERT INTO tags VALUES (226, 'sebastiao salgado', '2012-12-21 10:09:11.813864', '2012-12-21 10:09:11.813864');
INSERT INTO tags VALUES (227, 'albert', '2012-12-21 10:55:07.53235', '2012-12-21 10:55:07.53235');
INSERT INTO tags VALUES (228, 'koudelka', '2012-12-21 10:59:59.980165', '2012-12-21 10:59:59.980165');
INSERT INTO tags VALUES (229, 'josef koudelka', '2012-12-21 11:18:50.308279', '2012-12-21 11:18:50.308279');
INSERT INTO tags VALUES (230, 'einstein', '2012-12-21 11:22:20.382071', '2012-12-21 11:22:20.382071');
INSERT INTO tags VALUES (231, 'praga', '2012-12-21 11:27:16.282738', '2012-12-21 11:27:16.282738');
INSERT INTO tags VALUES (232, '1968', '2012-12-21 11:27:16.291948', '2012-12-21 11:27:16.291948');
INSERT INTO tags VALUES (233, 'gypsie', '2012-12-21 11:36:39.291974', '2012-12-21 11:36:39.291974');
INSERT INTO tags VALUES (234, 'pitagora', '2012-12-21 11:37:05.687171', '2012-12-21 11:37:05.687171');
INSERT INTO tags VALUES (235, 'gypsies', '2012-12-21 11:37:16.103661', '2012-12-21 11:37:16.103661');
INSERT INTO tags VALUES (236, 'stars', '2012-12-21 14:47:43.498443', '2012-12-21 14:47:43.498443');
INSERT INTO tags VALUES (237, 'universe', '2012-12-21 14:47:43.513424', '2012-12-21 14:47:43.513424');
INSERT INTO tags VALUES (238, 'constellation', '2012-12-21 14:47:43.52325', '2012-12-21 14:47:43.52325');
INSERT INTO tags VALUES (239, 'ape', '2012-12-21 15:19:12.694698', '2012-12-21 15:19:12.694698');
INSERT INTO tags VALUES (240, 'fiori', '2012-12-21 15:19:12.729938', '2012-12-21 15:19:12.729938');
INSERT INTO tags VALUES (241, 'ecologia', '2012-12-21 15:19:12.738616', '2012-12-21 15:19:12.738616');
INSERT INTO tags VALUES (242, 'insetti', '2012-12-21 15:19:12.746924', '2012-12-21 15:19:12.746924');
INSERT INTO tags VALUES (243, 'ambiente', '2012-12-21 15:50:33.663256', '2012-12-21 15:50:33.663256');
INSERT INTO tags VALUES (244, 'gatto', '2012-12-21 18:47:40.812477', '2012-12-21 18:47:40.812477');
INSERT INTO tags VALUES (245, 'cane', '2012-12-21 18:47:40.84812', '2012-12-21 18:47:40.84812');
INSERT INTO tags VALUES (246, 'topo', '2012-12-21 18:47:40.8567', '2012-12-21 18:47:40.8567');
INSERT INTO tags VALUES (247, 'pesce', '2012-12-21 18:47:40.86497', '2012-12-21 18:47:40.86497');
INSERT INTO tags VALUES (248, 'prova', '2012-12-21 18:48:56.385966', '2012-12-21 18:48:56.385966');
INSERT INTO tags VALUES (249, 'provaa', '2012-12-21 18:48:56.395211', '2012-12-21 18:48:56.395211');
INSERT INTO tags VALUES (250, 'film', '2012-12-23 16:25:35.798969', '2012-12-23 16:25:35.798969');
INSERT INTO tags VALUES (251, 'misfits', '2012-12-23 16:25:35.808496', '2012-12-23 16:25:35.808496');
INSERT INTO tags VALUES (252, 'boy', '2012-12-23 16:25:35.823319', '2012-12-23 16:25:35.823319');
INSERT INTO tags VALUES (253, 'picture', '2012-12-23 16:27:02.273913', '2012-12-23 16:27:02.273913');
INSERT INTO tags VALUES (254, 'subway', '2012-12-23 16:30:03.140946', '2012-12-23 16:30:03.140946');
INSERT INTO tags VALUES (255, 'horse', '2013-01-03 10:07:11.339697', '2013-01-03 10:07:11.339697');
INSERT INTO tags VALUES (256, 'cavallo', '2013-01-03 10:07:11.349936', '2013-01-03 10:07:11.349936');
INSERT INTO tags VALUES (257, 'bianco', '2013-01-03 10:07:11.358753', '2013-01-03 10:07:11.358753');
INSERT INTO tags VALUES (258, 'a', '2013-01-07 09:15:15.662964', '2013-01-07 09:15:15.662964');
INSERT INTO tags VALUES (259, 'b', '2013-01-07 09:15:15.671879', '2013-01-07 09:15:15.671879');
INSERT INTO tags VALUES (260, 'c', '2013-01-07 09:15:15.680321', '2013-01-07 09:15:15.680321');
INSERT INTO tags VALUES (261, 'd', '2013-01-07 09:15:15.688726', '2013-01-07 09:15:15.688726');
INSERT INTO tags VALUES (262, 's', '2013-01-07 09:46:06.152308', '2013-01-07 09:46:06.152308');
INSERT INTO tags VALUES (263, 'uff', '2013-01-07 09:55:45.715024', '2013-01-07 09:55:45.715024');
INSERT INTO tags VALUES (264, 'pizz', '2013-01-07 09:55:45.723413', '2013-01-07 09:55:45.723413');
INSERT INTO tags VALUES (265, 'sbuff', '2013-01-07 09:55:45.731384', '2013-01-07 09:55:45.731384');
INSERT INTO tags VALUES (266, 'pal', '2013-01-07 09:55:45.739339', '2013-01-07 09:55:45.739339');
INSERT INTO tags VALUES (267, 'jkahsd', '2013-01-07 09:57:04.146638', '2013-01-07 09:57:04.146638');
INSERT INTO tags VALUES (268, 'asdkds', '2013-01-07 09:57:04.155071', '2013-01-07 09:57:04.155071');
INSERT INTO tags VALUES (269, 'soifuidf', '2013-01-07 09:57:04.163156', '2013-01-07 09:57:04.163156');
INSERT INTO tags VALUES (270, 'lksdjfkljdsf', '2013-01-07 09:57:04.171106', '2013-01-07 09:57:04.171106');
INSERT INTO tags VALUES (271, 'flare', '2013-01-07 10:33:22.042791', '2013-01-07 10:33:22.042791');
INSERT INTO tags VALUES (272, 'lights', '2013-01-07 10:33:22.051952', '2013-01-07 10:33:22.051952');
INSERT INTO tags VALUES (273, 'sigaretta', '2013-01-08 11:22:36.435362', '2013-01-08 11:22:36.435362');
INSERT INTO tags VALUES (274, 'ragazzo', '2013-01-08 11:22:36.458216', '2013-01-08 11:22:36.458216');
INSERT INTO tags VALUES (275, 'television', '2013-01-08 11:22:36.46708', '2013-01-08 11:22:36.46708');
INSERT INTO tags VALUES (276, 'musica', '2013-01-08 11:29:36.045321', '2013-01-08 11:29:36.045321');
INSERT INTO tags VALUES (277, 'sole', '2013-01-08 11:29:36.054486', '2013-01-08 11:29:36.054486');
INSERT INTO tags VALUES (278, 'cuore', '2013-01-08 11:29:36.062922', '2013-01-08 11:29:36.062922');
INSERT INTO tags VALUES (279, 'amore', '2013-01-08 11:29:36.071585', '2013-01-08 11:29:36.071585');
INSERT INTO tags VALUES (280, 'blond', '2013-01-09 09:25:05.644436', '2013-01-09 09:25:05.644436');
INSERT INTO tags VALUES (281, 'eye', '2013-01-09 09:25:05.654867', '2013-01-09 09:25:05.654867');
INSERT INTO tags VALUES (282, 'lens', '2013-01-09 09:25:05.663713', '2013-01-09 09:25:05.663713');
INSERT INTO tags VALUES (283, 'asjdfsjad', '2013-01-09 09:57:44.95082', '2013-01-09 09:57:44.95082');
INSERT INTO tags VALUES (284, 'asjdjkfk', '2013-01-09 09:57:44.960317', '2013-01-09 09:57:44.960317');
INSERT INTO tags VALUES (285, 'iroetiiy', '2013-01-09 09:57:44.969469', '2013-01-09 09:57:44.969469');
INSERT INTO tags VALUES (286, 'zmxcnc', '2013-01-09 09:57:44.978884', '2013-01-09 09:57:44.978884');
INSERT INTO tags VALUES (287, 'fisica', '2013-01-09 10:21:46.83906', '2013-01-09 10:21:46.83906');
INSERT INTO tags VALUES (288, 'matematica', '2013-01-09 10:21:46.849843', '2013-01-09 10:21:46.849843');
INSERT INTO tags VALUES (289, 'genio', '2013-01-09 10:21:46.85917', '2013-01-09 10:21:46.85917');
INSERT INTO tags VALUES (290, 'sregolatezza', '2013-01-09 10:21:46.868357', '2013-01-09 10:21:46.868357');
INSERT INTO tags VALUES (291, 'rolex', '2013-01-09 10:45:21.866851', '2013-01-09 10:45:21.866851');
INSERT INTO tags VALUES (292, 'daytona', '2013-01-09 10:45:21.877998', '2013-01-09 10:45:21.877998');
INSERT INTO tags VALUES (293, 'nero', '2013-01-09 10:45:21.887316', '2013-01-09 10:45:21.887316');
INSERT INTO tags VALUES (294, 'pdv', '2013-01-09 10:45:21.896577', '2013-01-09 10:45:21.896577');
INSERT INTO tags VALUES (295, 'renna', '2013-01-09 10:46:47.931553', '2013-01-09 10:46:47.931553');
INSERT INTO tags VALUES (296, 'natale', '2013-01-09 10:46:47.942213', '2013-01-09 10:46:47.942213');
INSERT INTO tags VALUES (297, 'babbo natale', '2013-01-09 10:46:47.951309', '2013-01-09 10:46:47.951309');
INSERT INTO tags VALUES (298, 'slitta', '2013-01-09 10:46:47.960255', '2013-01-09 10:46:47.960255');
INSERT INTO tags VALUES (299, 'arts', '2013-01-09 13:28:41.423988', '2013-01-09 13:28:41.423988');
INSERT INTO tags VALUES (300, 'visive art', '2013-01-09 13:28:41.458367', '2013-01-09 13:28:41.458367');


--
-- Data for Name: taggings; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO taggings VALUES (1, 1, 1, 'MediaElement', '2012-12-20 10:31:33.253534', '2012-12-20 10:31:33.253534');
INSERT INTO taggings VALUES (2, 2, 1, 'MediaElement', '2012-12-20 10:31:33.26353', '2012-12-20 10:31:33.26353');
INSERT INTO taggings VALUES (3, 3, 1, 'MediaElement', '2012-12-20 10:31:33.271761', '2012-12-20 10:31:33.271761');
INSERT INTO taggings VALUES (4, 4, 1, 'MediaElement', '2012-12-20 10:31:33.27995', '2012-12-20 10:31:33.27995');
INSERT INTO taggings VALUES (5, 5, 1, 'MediaElement', '2012-12-20 10:31:33.287972', '2012-12-20 10:31:33.287972');
INSERT INTO taggings VALUES (6, 6, 2, 'MediaElement', '2012-12-20 10:31:33.851413', '2012-12-20 10:31:33.851413');
INSERT INTO taggings VALUES (7, 7, 2, 'MediaElement', '2012-12-20 10:31:33.859826', '2012-12-20 10:31:33.859826');
INSERT INTO taggings VALUES (8, 8, 2, 'MediaElement', '2012-12-20 10:31:33.867966', '2012-12-20 10:31:33.867966');
INSERT INTO taggings VALUES (9, 9, 2, 'MediaElement', '2012-12-20 10:31:33.876143', '2012-12-20 10:31:33.876143');
INSERT INTO taggings VALUES (10, 10, 2, 'MediaElement', '2012-12-20 10:31:33.884209', '2012-12-20 10:31:33.884209');
INSERT INTO taggings VALUES (11, 11, 2, 'MediaElement', '2012-12-20 10:31:33.89224', '2012-12-20 10:31:33.89224');
INSERT INTO taggings VALUES (12, 12, 2, 'MediaElement', '2012-12-20 10:31:33.900284', '2012-12-20 10:31:33.900284');
INSERT INTO taggings VALUES (13, 1, 3, 'MediaElement', '2012-12-20 10:31:34.521953', '2012-12-20 10:31:34.521953');
INSERT INTO taggings VALUES (14, 13, 3, 'MediaElement', '2012-12-20 10:31:34.530534', '2012-12-20 10:31:34.530534');
INSERT INTO taggings VALUES (15, 14, 3, 'MediaElement', '2012-12-20 10:31:34.538795', '2012-12-20 10:31:34.538795');
INSERT INTO taggings VALUES (16, 15, 3, 'MediaElement', '2012-12-20 10:31:34.547008', '2012-12-20 10:31:34.547008');
INSERT INTO taggings VALUES (17, 16, 3, 'MediaElement', '2012-12-20 10:31:34.555068', '2012-12-20 10:31:34.555068');
INSERT INTO taggings VALUES (18, 17, 3, 'MediaElement', '2012-12-20 10:31:34.563139', '2012-12-20 10:31:34.563139');
INSERT INTO taggings VALUES (19, 12, 3, 'MediaElement', '2012-12-20 10:31:34.568581', '2012-12-20 10:31:34.568581');
INSERT INTO taggings VALUES (20, 18, 4, 'MediaElement', '2012-12-20 10:31:35.288497', '2012-12-20 10:31:35.288497');
INSERT INTO taggings VALUES (21, 19, 4, 'MediaElement', '2012-12-20 10:31:35.297293', '2012-12-20 10:31:35.297293');
INSERT INTO taggings VALUES (22, 20, 4, 'MediaElement', '2012-12-20 10:31:35.305469', '2012-12-20 10:31:35.305469');
INSERT INTO taggings VALUES (23, 17, 4, 'MediaElement', '2012-12-20 10:31:35.311151', '2012-12-20 10:31:35.311151');
INSERT INTO taggings VALUES (24, 12, 4, 'MediaElement', '2012-12-20 10:31:35.316761', '2012-12-20 10:31:35.316761');
INSERT INTO taggings VALUES (25, 5, 5, 'MediaElement', '2012-12-20 10:31:35.878642', '2012-12-20 10:31:35.878642');
INSERT INTO taggings VALUES (26, 1, 5, 'MediaElement', '2012-12-20 10:31:35.884391', '2012-12-20 10:31:35.884391');
INSERT INTO taggings VALUES (27, 4, 5, 'MediaElement', '2012-12-20 10:31:35.890236', '2012-12-20 10:31:35.890236');
INSERT INTO taggings VALUES (28, 21, 5, 'MediaElement', '2012-12-20 10:31:35.898449', '2012-12-20 10:31:35.898449');
INSERT INTO taggings VALUES (29, 12, 5, 'MediaElement', '2012-12-20 10:31:35.903913', '2012-12-20 10:31:35.903913');
INSERT INTO taggings VALUES (30, 22, 5, 'MediaElement', '2012-12-20 10:31:35.911886', '2012-12-20 10:31:35.911886');
INSERT INTO taggings VALUES (31, 5, 6, 'MediaElement', '2012-12-20 10:31:37.268845', '2012-12-20 10:31:37.268845');
INSERT INTO taggings VALUES (32, 23, 6, 'MediaElement', '2012-12-20 10:31:37.27771', '2012-12-20 10:31:37.27771');
INSERT INTO taggings VALUES (33, 24, 6, 'MediaElement', '2012-12-20 10:31:37.286044', '2012-12-20 10:31:37.286044');
INSERT INTO taggings VALUES (34, 16, 6, 'MediaElement', '2012-12-20 10:31:37.291676', '2012-12-20 10:31:37.291676');
INSERT INTO taggings VALUES (35, 12, 6, 'MediaElement', '2012-12-20 10:31:37.297345', '2012-12-20 10:31:37.297345');
INSERT INTO taggings VALUES (36, 4, 6, 'MediaElement', '2012-12-20 10:31:37.303144', '2012-12-20 10:31:37.303144');
INSERT INTO taggings VALUES (37, 8, 7, 'MediaElement', '2012-12-20 10:31:37.94368', '2012-12-20 10:31:37.94368');
INSERT INTO taggings VALUES (38, 25, 7, 'MediaElement', '2012-12-20 10:31:37.952367', '2012-12-20 10:31:37.952367');
INSERT INTO taggings VALUES (39, 26, 7, 'MediaElement', '2012-12-20 10:31:37.960781', '2012-12-20 10:31:37.960781');
INSERT INTO taggings VALUES (40, 17, 7, 'MediaElement', '2012-12-20 10:31:37.96662', '2012-12-20 10:31:37.96662');
INSERT INTO taggings VALUES (41, 27, 7, 'MediaElement', '2012-12-20 10:31:37.974806', '2012-12-20 10:31:37.974806');
INSERT INTO taggings VALUES (42, 28, 7, 'MediaElement', '2012-12-20 10:31:37.983124', '2012-12-20 10:31:37.983124');
INSERT INTO taggings VALUES (43, 29, 7, 'MediaElement', '2012-12-20 10:31:37.991338', '2012-12-20 10:31:37.991338');
INSERT INTO taggings VALUES (44, 30, 7, 'MediaElement', '2012-12-20 10:31:37.999479', '2012-12-20 10:31:37.999479');
INSERT INTO taggings VALUES (45, 5, 8, 'MediaElement', '2012-12-20 10:31:38.49625', '2012-12-20 10:31:38.49625');
INSERT INTO taggings VALUES (46, 31, 8, 'MediaElement', '2012-12-20 10:31:38.505103', '2012-12-20 10:31:38.505103');
INSERT INTO taggings VALUES (47, 32, 8, 'MediaElement', '2012-12-20 10:31:38.513463', '2012-12-20 10:31:38.513463');
INSERT INTO taggings VALUES (48, 33, 8, 'MediaElement', '2012-12-20 10:31:38.521871', '2012-12-20 10:31:38.521871');
INSERT INTO taggings VALUES (49, 34, 8, 'MediaElement', '2012-12-20 10:31:38.530009', '2012-12-20 10:31:38.530009');
INSERT INTO taggings VALUES (50, 35, 8, 'MediaElement', '2012-12-20 10:31:38.538198', '2012-12-20 10:31:38.538198');
INSERT INTO taggings VALUES (51, 36, 8, 'MediaElement', '2012-12-20 10:31:38.546327', '2012-12-20 10:31:38.546327');
INSERT INTO taggings VALUES (52, 5, 9, 'MediaElement', '2012-12-20 10:31:39.141282', '2012-12-20 10:31:39.141282');
INSERT INTO taggings VALUES (53, 4, 9, 'MediaElement', '2012-12-20 10:31:39.147126', '2012-12-20 10:31:39.147126');
INSERT INTO taggings VALUES (54, 37, 9, 'MediaElement', '2012-12-20 10:31:39.155633', '2012-12-20 10:31:39.155633');
INSERT INTO taggings VALUES (55, 38, 9, 'MediaElement', '2012-12-20 10:31:39.163878', '2012-12-20 10:31:39.163878');
INSERT INTO taggings VALUES (56, 39, 9, 'MediaElement', '2012-12-20 10:31:39.172029', '2012-12-20 10:31:39.172029');
INSERT INTO taggings VALUES (57, 40, 9, 'MediaElement', '2012-12-20 10:31:39.180116', '2012-12-20 10:31:39.180116');
INSERT INTO taggings VALUES (58, 23, 10, 'MediaElement', '2012-12-20 10:31:39.723838', '2012-12-20 10:31:39.723838');
INSERT INTO taggings VALUES (59, 5, 10, 'MediaElement', '2012-12-20 10:31:39.729873', '2012-12-20 10:31:39.729873');
INSERT INTO taggings VALUES (60, 41, 10, 'MediaElement', '2012-12-20 10:31:39.738519', '2012-12-20 10:31:39.738519');
INSERT INTO taggings VALUES (61, 42, 10, 'MediaElement', '2012-12-20 10:31:39.746637', '2012-12-20 10:31:39.746637');
INSERT INTO taggings VALUES (62, 43, 11, 'MediaElement', '2012-12-20 10:31:40.394623', '2012-12-20 10:31:40.394623');
INSERT INTO taggings VALUES (63, 44, 11, 'MediaElement', '2012-12-20 10:31:40.403136', '2012-12-20 10:31:40.403136');
INSERT INTO taggings VALUES (64, 16, 11, 'MediaElement', '2012-12-20 10:31:40.408897', '2012-12-20 10:31:40.408897');
INSERT INTO taggings VALUES (65, 45, 11, 'MediaElement', '2012-12-20 10:31:40.41748', '2012-12-20 10:31:40.41748');
INSERT INTO taggings VALUES (66, 46, 11, 'MediaElement', '2012-12-20 10:31:40.425794', '2012-12-20 10:31:40.425794');
INSERT INTO taggings VALUES (67, 47, 11, 'MediaElement', '2012-12-20 10:31:40.434083', '2012-12-20 10:31:40.434083');
INSERT INTO taggings VALUES (68, 48, 11, 'MediaElement', '2012-12-20 10:31:40.442254', '2012-12-20 10:31:40.442254');
INSERT INTO taggings VALUES (69, 8, 11, 'MediaElement', '2012-12-20 10:31:40.447771', '2012-12-20 10:31:40.447771');
INSERT INTO taggings VALUES (70, 49, 12, 'MediaElement', '2012-12-20 10:31:40.976424', '2012-12-20 10:31:40.976424');
INSERT INTO taggings VALUES (71, 4, 12, 'MediaElement', '2012-12-20 10:31:40.982557', '2012-12-20 10:31:40.982557');
INSERT INTO taggings VALUES (72, 16, 12, 'MediaElement', '2012-12-20 10:31:40.988313', '2012-12-20 10:31:40.988313');
INSERT INTO taggings VALUES (73, 50, 12, 'MediaElement', '2012-12-20 10:31:40.996634', '2012-12-20 10:31:40.996634');
INSERT INTO taggings VALUES (74, 51, 13, 'MediaElement', '2012-12-20 10:31:42.502037', '2012-12-20 10:31:42.502037');
INSERT INTO taggings VALUES (75, 4, 13, 'MediaElement', '2012-12-20 10:31:42.507813', '2012-12-20 10:31:42.507813');
INSERT INTO taggings VALUES (76, 52, 13, 'MediaElement', '2012-12-20 10:31:42.516133', '2012-12-20 10:31:42.516133');
INSERT INTO taggings VALUES (77, 8, 13, 'MediaElement', '2012-12-20 10:31:42.521937', '2012-12-20 10:31:42.521937');
INSERT INTO taggings VALUES (78, 5, 13, 'MediaElement', '2012-12-20 10:31:42.527489', '2012-12-20 10:31:42.527489');
INSERT INTO taggings VALUES (79, 12, 13, 'MediaElement', '2012-12-20 10:31:42.533264', '2012-12-20 10:31:42.533264');
INSERT INTO taggings VALUES (80, 43, 14, 'MediaElement', '2012-12-20 10:31:43.15215', '2012-12-20 10:31:43.15215');
INSERT INTO taggings VALUES (81, 53, 14, 'MediaElement', '2012-12-20 10:31:43.161085', '2012-12-20 10:31:43.161085');
INSERT INTO taggings VALUES (82, 54, 14, 'MediaElement', '2012-12-20 10:31:43.169289', '2012-12-20 10:31:43.169289');
INSERT INTO taggings VALUES (83, 12, 14, 'MediaElement', '2012-12-20 10:31:43.174808', '2012-12-20 10:31:43.174808');
INSERT INTO taggings VALUES (84, 16, 14, 'MediaElement', '2012-12-20 10:31:43.180299', '2012-12-20 10:31:43.180299');
INSERT INTO taggings VALUES (85, 55, 14, 'MediaElement', '2012-12-20 10:31:43.188337', '2012-12-20 10:31:43.188337');
INSERT INTO taggings VALUES (86, 44, 14, 'MediaElement', '2012-12-20 10:31:43.193932', '2012-12-20 10:31:43.193932');
INSERT INTO taggings VALUES (87, 8, 14, 'MediaElement', '2012-12-20 10:31:43.19935', '2012-12-20 10:31:43.19935');
INSERT INTO taggings VALUES (88, 4, 15, 'MediaElement', '2012-12-20 10:31:43.763284', '2012-12-20 10:31:43.763284');
INSERT INTO taggings VALUES (89, 56, 15, 'MediaElement', '2012-12-20 10:31:43.772253', '2012-12-20 10:31:43.772253');
INSERT INTO taggings VALUES (90, 38, 15, 'MediaElement', '2012-12-20 10:31:43.778337', '2012-12-20 10:31:43.778337');
INSERT INTO taggings VALUES (91, 37, 15, 'MediaElement', '2012-12-20 10:31:43.784059', '2012-12-20 10:31:43.784059');
INSERT INTO taggings VALUES (92, 1, 15, 'MediaElement', '2012-12-20 10:31:43.790167', '2012-12-20 10:31:43.790167');
INSERT INTO taggings VALUES (93, 57, 15, 'MediaElement', '2012-12-20 10:31:43.798422', '2012-12-20 10:31:43.798422');
INSERT INTO taggings VALUES (94, 4, 16, 'MediaElement', '2012-12-20 10:31:44.331146', '2012-12-20 10:31:44.331146');
INSERT INTO taggings VALUES (95, 14, 16, 'MediaElement', '2012-12-20 10:31:44.33728', '2012-12-20 10:31:44.33728');
INSERT INTO taggings VALUES (96, 16, 16, 'MediaElement', '2012-12-20 10:31:44.343018', '2012-12-20 10:31:44.343018');
INSERT INTO taggings VALUES (97, 1, 16, 'MediaElement', '2012-12-20 10:31:44.348646', '2012-12-20 10:31:44.348646');
INSERT INTO taggings VALUES (98, 39, 16, 'MediaElement', '2012-12-20 10:31:44.354398', '2012-12-20 10:31:44.354398');
INSERT INTO taggings VALUES (99, 5, 16, 'MediaElement', '2012-12-20 10:31:44.359895', '2012-12-20 10:31:44.359895');
INSERT INTO taggings VALUES (100, 4, 17, 'MediaElement', '2012-12-20 10:31:44.946127', '2012-12-20 10:31:44.946127');
INSERT INTO taggings VALUES (101, 58, 17, 'MediaElement', '2012-12-20 10:31:44.954832', '2012-12-20 10:31:44.954832');
INSERT INTO taggings VALUES (102, 59, 17, 'MediaElement', '2012-12-20 10:31:44.963335', '2012-12-20 10:31:44.963335');
INSERT INTO taggings VALUES (103, 60, 17, 'MediaElement', '2012-12-20 10:31:44.971502', '2012-12-20 10:31:44.971502');
INSERT INTO taggings VALUES (104, 39, 17, 'MediaElement', '2012-12-20 10:31:44.977232', '2012-12-20 10:31:44.977232');
INSERT INTO taggings VALUES (105, 5, 17, 'MediaElement', '2012-12-20 10:31:44.982708', '2012-12-20 10:31:44.982708');
INSERT INTO taggings VALUES (106, 61, 18, 'MediaElement', '2012-12-20 10:31:45.513806', '2012-12-20 10:31:45.513806');
INSERT INTO taggings VALUES (107, 62, 18, 'MediaElement', '2012-12-20 10:31:45.522284', '2012-12-20 10:31:45.522284');
INSERT INTO taggings VALUES (108, 44, 18, 'MediaElement', '2012-12-20 10:31:45.527937', '2012-12-20 10:31:45.527937');
INSERT INTO taggings VALUES (109, 5, 18, 'MediaElement', '2012-12-20 10:31:45.533726', '2012-12-20 10:31:45.533726');
INSERT INTO taggings VALUES (110, 63, 18, 'MediaElement', '2012-12-20 10:31:45.542088', '2012-12-20 10:31:45.542088');
INSERT INTO taggings VALUES (111, 64, 18, 'MediaElement', '2012-12-20 10:31:45.550199', '2012-12-20 10:31:45.550199');
INSERT INTO taggings VALUES (112, 65, 18, 'MediaElement', '2012-12-20 10:31:45.558287', '2012-12-20 10:31:45.558287');
INSERT INTO taggings VALUES (113, 12, 19, 'MediaElement', '2012-12-20 10:31:46.184041', '2012-12-20 10:31:46.184041');
INSERT INTO taggings VALUES (114, 17, 19, 'MediaElement', '2012-12-20 10:31:46.190244', '2012-12-20 10:31:46.190244');
INSERT INTO taggings VALUES (115, 66, 19, 'MediaElement', '2012-12-20 10:31:46.198742', '2012-12-20 10:31:46.198742');
INSERT INTO taggings VALUES (116, 18, 19, 'MediaElement', '2012-12-20 10:31:46.20438', '2012-12-20 10:31:46.20438');
INSERT INTO taggings VALUES (117, 67, 19, 'MediaElement', '2012-12-20 10:31:46.212654', '2012-12-20 10:31:46.212654');
INSERT INTO taggings VALUES (118, 68, 19, 'MediaElement', '2012-12-20 10:31:46.221282', '2012-12-20 10:31:46.221282');
INSERT INTO taggings VALUES (119, 12, 20, 'MediaElement', '2012-12-20 10:31:47.726499', '2012-12-20 10:31:47.726499');
INSERT INTO taggings VALUES (120, 11, 20, 'MediaElement', '2012-12-20 10:31:47.732415', '2012-12-20 10:31:47.732415');
INSERT INTO taggings VALUES (121, 69, 20, 'MediaElement', '2012-12-20 10:31:47.741376', '2012-12-20 10:31:47.741376');
INSERT INTO taggings VALUES (122, 55, 20, 'MediaElement', '2012-12-20 10:31:47.747027', '2012-12-20 10:31:47.747027');
INSERT INTO taggings VALUES (123, 27, 20, 'MediaElement', '2012-12-20 10:31:47.752591', '2012-12-20 10:31:47.752591');
INSERT INTO taggings VALUES (124, 1, 21, 'MediaElement', '2012-12-20 10:31:48.310228', '2012-12-20 10:31:48.310228');
INSERT INTO taggings VALUES (125, 70, 21, 'MediaElement', '2012-12-20 10:31:48.318972', '2012-12-20 10:31:48.318972');
INSERT INTO taggings VALUES (126, 37, 21, 'MediaElement', '2012-12-20 10:31:48.32471', '2012-12-20 10:31:48.32471');
INSERT INTO taggings VALUES (127, 5, 21, 'MediaElement', '2012-12-20 10:31:48.330784', '2012-12-20 10:31:48.330784');
INSERT INTO taggings VALUES (128, 71, 21, 'MediaElement', '2012-12-20 10:31:48.339061', '2012-12-20 10:31:48.339061');
INSERT INTO taggings VALUES (129, 8, 22, 'MediaElement', '2012-12-20 10:31:48.977875', '2012-12-20 10:31:48.977875');
INSERT INTO taggings VALUES (130, 72, 22, 'MediaElement', '2012-12-20 10:31:48.986865', '2012-12-20 10:31:48.986865');
INSERT INTO taggings VALUES (131, 25, 22, 'MediaElement', '2012-12-20 10:31:48.992563', '2012-12-20 10:31:48.992563');
INSERT INTO taggings VALUES (132, 17, 22, 'MediaElement', '2012-12-20 10:31:48.998466', '2012-12-20 10:31:48.998466');
INSERT INTO taggings VALUES (133, 73, 22, 'MediaElement', '2012-12-20 10:31:49.006812', '2012-12-20 10:31:49.006812');
INSERT INTO taggings VALUES (134, 74, 23, 'MediaElement', '2012-12-20 10:31:49.894602', '2012-12-20 10:31:49.894602');
INSERT INTO taggings VALUES (135, 12, 23, 'MediaElement', '2012-12-20 10:31:49.900354', '2012-12-20 10:31:49.900354');
INSERT INTO taggings VALUES (136, 17, 23, 'MediaElement', '2012-12-20 10:31:49.906342', '2012-12-20 10:31:49.906342');
INSERT INTO taggings VALUES (137, 73, 23, 'MediaElement', '2012-12-20 10:31:49.912011', '2012-12-20 10:31:49.912011');
INSERT INTO taggings VALUES (138, 75, 24, 'MediaElement', '2012-12-20 10:31:50.246895', '2012-12-20 10:31:50.246895');
INSERT INTO taggings VALUES (139, 76, 24, 'MediaElement', '2012-12-20 10:31:50.255335', '2012-12-20 10:31:50.255335');
INSERT INTO taggings VALUES (140, 18, 24, 'MediaElement', '2012-12-20 10:31:50.261094', '2012-12-20 10:31:50.261094');
INSERT INTO taggings VALUES (141, 77, 24, 'MediaElement', '2012-12-20 10:31:50.269577', '2012-12-20 10:31:50.269577');
INSERT INTO taggings VALUES (142, 14, 24, 'MediaElement', '2012-12-20 10:31:50.275176', '2012-12-20 10:31:50.275176');
INSERT INTO taggings VALUES (143, 12, 24, 'MediaElement', '2012-12-20 10:31:50.280723', '2012-12-20 10:31:50.280723');
INSERT INTO taggings VALUES (144, 78, 25, 'MediaElement', '2012-12-20 10:31:51.305374', '2012-12-20 10:31:51.305374');
INSERT INTO taggings VALUES (145, 76, 25, 'MediaElement', '2012-12-20 10:31:51.311452', '2012-12-20 10:31:51.311452');
INSERT INTO taggings VALUES (146, 18, 25, 'MediaElement', '2012-12-20 10:31:51.317664', '2012-12-20 10:31:51.317664');
INSERT INTO taggings VALUES (147, 79, 25, 'MediaElement', '2012-12-20 10:31:51.722714', '2012-12-20 10:31:51.722714');
INSERT INTO taggings VALUES (148, 72, 25, 'MediaElement', '2012-12-20 10:31:51.728392', '2012-12-20 10:31:51.728392');
INSERT INTO taggings VALUES (149, 12, 25, 'MediaElement', '2012-12-20 10:31:51.734122', '2012-12-20 10:31:51.734122');
INSERT INTO taggings VALUES (150, 80, 26, 'MediaElement', '2012-12-20 10:31:52.669486', '2012-12-20 10:31:52.669486');
INSERT INTO taggings VALUES (151, 76, 26, 'MediaElement', '2012-12-20 10:31:52.675326', '2012-12-20 10:31:52.675326');
INSERT INTO taggings VALUES (152, 18, 26, 'MediaElement', '2012-12-20 10:31:52.681316', '2012-12-20 10:31:52.681316');
INSERT INTO taggings VALUES (153, 14, 26, 'MediaElement', '2012-12-20 10:31:52.687018', '2012-12-20 10:31:52.687018');
INSERT INTO taggings VALUES (154, 72, 26, 'MediaElement', '2012-12-20 10:31:52.692621', '2012-12-20 10:31:52.692621');
INSERT INTO taggings VALUES (155, 12, 26, 'MediaElement', '2012-12-20 10:31:52.698601', '2012-12-20 10:31:52.698601');
INSERT INTO taggings VALUES (156, 8, 27, 'MediaElement', '2012-12-20 10:31:53.62122', '2012-12-20 10:31:53.62122');
INSERT INTO taggings VALUES (157, 17, 27, 'MediaElement', '2012-12-20 10:31:53.627188', '2012-12-20 10:31:53.627188');
INSERT INTO taggings VALUES (158, 18, 27, 'MediaElement', '2012-12-20 10:31:53.633145', '2012-12-20 10:31:53.633145');
INSERT INTO taggings VALUES (159, 72, 27, 'MediaElement', '2012-12-20 10:31:53.638904', '2012-12-20 10:31:53.638904');
INSERT INTO taggings VALUES (160, 12, 27, 'MediaElement', '2012-12-20 10:31:53.644665', '2012-12-20 10:31:53.644665');
INSERT INTO taggings VALUES (161, 66, 28, 'MediaElement', '2012-12-20 10:31:54.502985', '2012-12-20 10:31:54.502985');
INSERT INTO taggings VALUES (162, 17, 28, 'MediaElement', '2012-12-20 10:31:54.50935', '2012-12-20 10:31:54.50935');
INSERT INTO taggings VALUES (163, 18, 28, 'MediaElement', '2012-12-20 10:31:54.515098', '2012-12-20 10:31:54.515098');
INSERT INTO taggings VALUES (164, 72, 28, 'MediaElement', '2012-12-20 10:31:54.520784', '2012-12-20 10:31:54.520784');
INSERT INTO taggings VALUES (165, 12, 28, 'MediaElement', '2012-12-20 10:31:54.526708', '2012-12-20 10:31:54.526708');
INSERT INTO taggings VALUES (166, 44, 29, 'MediaElement', '2012-12-20 10:31:55.421789', '2012-12-20 10:31:55.421789');
INSERT INTO taggings VALUES (167, 81, 29, 'MediaElement', '2012-12-20 10:31:55.430736', '2012-12-20 10:31:55.430736');
INSERT INTO taggings VALUES (168, 18, 29, 'MediaElement', '2012-12-20 10:31:55.436461', '2012-12-20 10:31:55.436461');
INSERT INTO taggings VALUES (169, 8, 29, 'MediaElement', '2012-12-20 10:31:55.44238', '2012-12-20 10:31:55.44238');
INSERT INTO taggings VALUES (170, 12, 29, 'MediaElement', '2012-12-20 10:31:55.448044', '2012-12-20 10:31:55.448044');
INSERT INTO taggings VALUES (171, 18, 30, 'MediaElement', '2012-12-20 10:31:56.73501', '2012-12-20 10:31:56.73501');
INSERT INTO taggings VALUES (172, 17, 30, 'MediaElement', '2012-12-20 10:31:56.741062', '2012-12-20 10:31:56.741062');
INSERT INTO taggings VALUES (173, 8, 30, 'MediaElement', '2012-12-20 10:31:56.746798', '2012-12-20 10:31:56.746798');
INSERT INTO taggings VALUES (174, 12, 30, 'MediaElement', '2012-12-20 10:31:56.752639', '2012-12-20 10:31:56.752639');
INSERT INTO taggings VALUES (175, 82, 31, 'MediaElement', '2012-12-20 10:31:57.248943', '2012-12-20 10:31:57.248943');
INSERT INTO taggings VALUES (176, 5, 31, 'MediaElement', '2012-12-20 10:31:57.254867', '2012-12-20 10:31:57.254867');
INSERT INTO taggings VALUES (177, 83, 31, 'MediaElement', '2012-12-20 10:31:57.263232', '2012-12-20 10:31:57.263232');
INSERT INTO taggings VALUES (178, 84, 31, 'MediaElement', '2012-12-20 10:31:57.271515', '2012-12-20 10:31:57.271515');
INSERT INTO taggings VALUES (179, 85, 31, 'MediaElement', '2012-12-20 10:31:57.279798', '2012-12-20 10:31:57.279798');
INSERT INTO taggings VALUES (180, 86, 31, 'MediaElement', '2012-12-20 10:31:57.288196', '2012-12-20 10:31:57.288196');
INSERT INTO taggings VALUES (181, 87, 32, 'MediaElement', '2012-12-20 10:31:57.801529', '2012-12-20 10:31:57.801529');
INSERT INTO taggings VALUES (182, 5, 32, 'MediaElement', '2012-12-20 10:31:57.807476', '2012-12-20 10:31:57.807476');
INSERT INTO taggings VALUES (183, 83, 32, 'MediaElement', '2012-12-20 10:31:57.813613', '2012-12-20 10:31:57.813613');
INSERT INTO taggings VALUES (184, 88, 32, 'MediaElement', '2012-12-20 10:31:57.822092', '2012-12-20 10:31:57.822092');
INSERT INTO taggings VALUES (185, 16, 32, 'MediaElement', '2012-12-20 10:31:57.827974', '2012-12-20 10:31:57.827974');
INSERT INTO taggings VALUES (186, 44, 32, 'MediaElement', '2012-12-20 10:31:57.833789', '2012-12-20 10:31:57.833789');
INSERT INTO taggings VALUES (187, 89, 33, 'MediaElement', '2012-12-20 10:31:58.030555', '2012-12-20 10:31:58.030555');
INSERT INTO taggings VALUES (188, 5, 33, 'MediaElement', '2012-12-20 10:31:58.036717', '2012-12-20 10:31:58.036717');
INSERT INTO taggings VALUES (189, 23, 33, 'MediaElement', '2012-12-20 10:31:58.042572', '2012-12-20 10:31:58.042572');
INSERT INTO taggings VALUES (190, 90, 33, 'MediaElement', '2012-12-20 10:31:58.050903', '2012-12-20 10:31:58.050903');
INSERT INTO taggings VALUES (191, 89, 34, 'MediaElement', '2012-12-20 10:31:58.246437', '2012-12-20 10:31:58.246437');
INSERT INTO taggings VALUES (192, 5, 34, 'MediaElement', '2012-12-20 10:31:58.252103', '2012-12-20 10:31:58.252103');
INSERT INTO taggings VALUES (193, 23, 34, 'MediaElement', '2012-12-20 10:31:58.257882', '2012-12-20 10:31:58.257882');
INSERT INTO taggings VALUES (194, 90, 34, 'MediaElement', '2012-12-20 10:31:58.263386', '2012-12-20 10:31:58.263386');
INSERT INTO taggings VALUES (195, 91, 34, 'MediaElement', '2012-12-20 10:31:58.27157', '2012-12-20 10:31:58.27157');
INSERT INTO taggings VALUES (196, 89, 35, 'MediaElement', '2012-12-20 10:31:58.472686', '2012-12-20 10:31:58.472686');
INSERT INTO taggings VALUES (197, 5, 35, 'MediaElement', '2012-12-20 10:31:58.478393', '2012-12-20 10:31:58.478393');
INSERT INTO taggings VALUES (198, 23, 35, 'MediaElement', '2012-12-20 10:31:58.483805', '2012-12-20 10:31:58.483805');
INSERT INTO taggings VALUES (199, 90, 35, 'MediaElement', '2012-12-20 10:31:58.489426', '2012-12-20 10:31:58.489426');
INSERT INTO taggings VALUES (200, 92, 35, 'MediaElement', '2012-12-20 10:31:58.497472', '2012-12-20 10:31:58.497472');
INSERT INTO taggings VALUES (201, 89, 36, 'MediaElement', '2012-12-20 10:31:58.740477', '2012-12-20 10:31:58.740477');
INSERT INTO taggings VALUES (202, 5, 36, 'MediaElement', '2012-12-20 10:31:58.747392', '2012-12-20 10:31:58.747392');
INSERT INTO taggings VALUES (203, 23, 36, 'MediaElement', '2012-12-20 10:31:58.753911', '2012-12-20 10:31:58.753911');
INSERT INTO taggings VALUES (204, 90, 36, 'MediaElement', '2012-12-20 10:31:58.76093', '2012-12-20 10:31:58.76093');
INSERT INTO taggings VALUES (205, 44, 36, 'MediaElement', '2012-12-20 10:31:58.767796', '2012-12-20 10:31:58.767796');
INSERT INTO taggings VALUES (206, 34, 37, 'MediaElement', '2012-12-20 10:31:58.973797', '2012-12-20 10:31:58.973797');
INSERT INTO taggings VALUES (207, 93, 37, 'MediaElement', '2012-12-20 10:31:58.98324', '2012-12-20 10:31:58.98324');
INSERT INTO taggings VALUES (208, 94, 37, 'MediaElement', '2012-12-20 10:31:58.992989', '2012-12-20 10:31:58.992989');
INSERT INTO taggings VALUES (209, 95, 37, 'MediaElement', '2012-12-20 10:31:59.003047', '2012-12-20 10:31:59.003047');
INSERT INTO taggings VALUES (210, 96, 37, 'MediaElement', '2012-12-20 10:31:59.012033', '2012-12-20 10:31:59.012033');
INSERT INTO taggings VALUES (211, 34, 38, 'MediaElement', '2012-12-20 10:31:59.229515', '2012-12-20 10:31:59.229515');
INSERT INTO taggings VALUES (212, 93, 38, 'MediaElement', '2012-12-20 10:31:59.236623', '2012-12-20 10:31:59.236623');
INSERT INTO taggings VALUES (213, 94, 38, 'MediaElement', '2012-12-20 10:31:59.243448', '2012-12-20 10:31:59.243448');
INSERT INTO taggings VALUES (214, 95, 38, 'MediaElement', '2012-12-20 10:31:59.249766', '2012-12-20 10:31:59.249766');
INSERT INTO taggings VALUES (215, 96, 38, 'MediaElement', '2012-12-20 10:31:59.25563', '2012-12-20 10:31:59.25563');
INSERT INTO taggings VALUES (216, 55, 39, 'MediaElement', '2012-12-20 10:31:59.637183', '2012-12-20 10:31:59.637183');
INSERT INTO taggings VALUES (217, 5, 39, 'MediaElement', '2012-12-20 10:31:59.643671', '2012-12-20 10:31:59.643671');
INSERT INTO taggings VALUES (218, 83, 39, 'MediaElement', '2012-12-20 10:31:59.649623', '2012-12-20 10:31:59.649623');
INSERT INTO taggings VALUES (219, 4, 39, 'MediaElement', '2012-12-20 10:31:59.655382', '2012-12-20 10:31:59.655382');
INSERT INTO taggings VALUES (220, 56, 40, 'MediaElement', '2012-12-20 10:32:00.363941', '2012-12-20 10:32:00.363941');
INSERT INTO taggings VALUES (221, 5, 40, 'MediaElement', '2012-12-20 10:32:00.37019', '2012-12-20 10:32:00.37019');
INSERT INTO taggings VALUES (222, 38, 40, 'MediaElement', '2012-12-20 10:32:00.375863', '2012-12-20 10:32:00.375863');
INSERT INTO taggings VALUES (223, 4, 40, 'MediaElement', '2012-12-20 10:32:00.381583', '2012-12-20 10:32:00.381583');
INSERT INTO taggings VALUES (224, 37, 40, 'MediaElement', '2012-12-20 10:32:00.387263', '2012-12-20 10:32:00.387263');
INSERT INTO taggings VALUES (225, 97, 41, 'MediaElement', '2012-12-20 10:32:00.815113', '2012-12-20 10:32:00.815113');
INSERT INTO taggings VALUES (226, 5, 41, 'MediaElement', '2012-12-20 10:32:00.820721', '2012-12-20 10:32:00.820721');
INSERT INTO taggings VALUES (227, 98, 41, 'MediaElement', '2012-12-20 10:32:00.828938', '2012-12-20 10:32:00.828938');
INSERT INTO taggings VALUES (228, 99, 41, 'MediaElement', '2012-12-20 10:32:00.836955', '2012-12-20 10:32:00.836955');
INSERT INTO taggings VALUES (229, 100, 41, 'MediaElement', '2012-12-20 10:32:00.845128', '2012-12-20 10:32:00.845128');
INSERT INTO taggings VALUES (230, 101, 42, 'MediaElement', '2012-12-20 10:32:01.210934', '2012-12-20 10:32:01.210934');
INSERT INTO taggings VALUES (231, 5, 42, 'MediaElement', '2012-12-20 10:32:01.216624', '2012-12-20 10:32:01.216624');
INSERT INTO taggings VALUES (232, 83, 42, 'MediaElement', '2012-12-20 10:32:01.222376', '2012-12-20 10:32:01.222376');
INSERT INTO taggings VALUES (233, 102, 42, 'MediaElement', '2012-12-20 10:32:01.230557', '2012-12-20 10:32:01.230557');
INSERT INTO taggings VALUES (234, 100, 42, 'MediaElement', '2012-12-20 10:32:01.236105', '2012-12-20 10:32:01.236105');
INSERT INTO taggings VALUES (235, 103, 42, 'MediaElement', '2012-12-20 10:32:01.244229', '2012-12-20 10:32:01.244229');
INSERT INTO taggings VALUES (236, 104, 42, 'MediaElement', '2012-12-20 10:32:01.297278', '2012-12-20 10:32:01.297278');
INSERT INTO taggings VALUES (237, 105, 43, 'MediaElement', '2012-12-20 10:32:01.798828', '2012-12-20 10:32:01.798828');
INSERT INTO taggings VALUES (238, 5, 43, 'MediaElement', '2012-12-20 10:32:01.806496', '2012-12-20 10:32:01.806496');
INSERT INTO taggings VALUES (239, 83, 43, 'MediaElement', '2012-12-20 10:32:01.813662', '2012-12-20 10:32:01.813662');
INSERT INTO taggings VALUES (240, 102, 43, 'MediaElement', '2012-12-20 10:32:01.820456', '2012-12-20 10:32:01.820456');
INSERT INTO taggings VALUES (241, 106, 43, 'MediaElement', '2012-12-20 10:32:01.830101', '2012-12-20 10:32:01.830101');
INSERT INTO taggings VALUES (242, 103, 43, 'MediaElement', '2012-12-20 10:32:01.836164', '2012-12-20 10:32:01.836164');
INSERT INTO taggings VALUES (243, 104, 43, 'MediaElement', '2012-12-20 10:32:01.842626', '2012-12-20 10:32:01.842626');
INSERT INTO taggings VALUES (244, 105, 44, 'MediaElement', '2012-12-20 10:32:02.410722', '2012-12-20 10:32:02.410722');
INSERT INTO taggings VALUES (245, 5, 44, 'MediaElement', '2012-12-20 10:32:02.417809', '2012-12-20 10:32:02.417809');
INSERT INTO taggings VALUES (246, 83, 44, 'MediaElement', '2012-12-20 10:32:02.424821', '2012-12-20 10:32:02.424821');
INSERT INTO taggings VALUES (247, 102, 44, 'MediaElement', '2012-12-20 10:32:02.431878', '2012-12-20 10:32:02.431878');
INSERT INTO taggings VALUES (248, 106, 44, 'MediaElement', '2012-12-20 10:32:02.438475', '2012-12-20 10:32:02.438475');
INSERT INTO taggings VALUES (249, 103, 44, 'MediaElement', '2012-12-20 10:32:02.445766', '2012-12-20 10:32:02.445766');
INSERT INTO taggings VALUES (250, 104, 44, 'MediaElement', '2012-12-20 10:32:02.45291', '2012-12-20 10:32:02.45291');
INSERT INTO taggings VALUES (251, 107, 45, 'MediaElement', '2012-12-20 10:32:03.022119', '2012-12-20 10:32:03.022119');
INSERT INTO taggings VALUES (252, 5, 45, 'MediaElement', '2012-12-20 10:32:03.029265', '2012-12-20 10:32:03.029265');
INSERT INTO taggings VALUES (253, 83, 45, 'MediaElement', '2012-12-20 10:32:03.036626', '2012-12-20 10:32:03.036626');
INSERT INTO taggings VALUES (254, 102, 45, 'MediaElement', '2012-12-20 10:32:03.044019', '2012-12-20 10:32:03.044019');
INSERT INTO taggings VALUES (255, 106, 45, 'MediaElement', '2012-12-20 10:32:03.051206', '2012-12-20 10:32:03.051206');
INSERT INTO taggings VALUES (256, 103, 45, 'MediaElement', '2012-12-20 10:32:03.057994', '2012-12-20 10:32:03.057994');
INSERT INTO taggings VALUES (257, 104, 45, 'MediaElement', '2012-12-20 10:32:03.064614', '2012-12-20 10:32:03.064614');
INSERT INTO taggings VALUES (258, 107, 46, 'MediaElement', '2012-12-20 10:32:03.562807', '2012-12-20 10:32:03.562807');
INSERT INTO taggings VALUES (259, 5, 46, 'MediaElement', '2012-12-20 10:32:03.569984', '2012-12-20 10:32:03.569984');
INSERT INTO taggings VALUES (260, 83, 46, 'MediaElement', '2012-12-20 10:32:03.577128', '2012-12-20 10:32:03.577128');
INSERT INTO taggings VALUES (261, 102, 46, 'MediaElement', '2012-12-20 10:32:03.584058', '2012-12-20 10:32:03.584058');
INSERT INTO taggings VALUES (262, 106, 46, 'MediaElement', '2012-12-20 10:32:03.591057', '2012-12-20 10:32:03.591057');
INSERT INTO taggings VALUES (263, 103, 46, 'MediaElement', '2012-12-20 10:32:03.597619', '2012-12-20 10:32:03.597619');
INSERT INTO taggings VALUES (264, 104, 46, 'MediaElement', '2012-12-20 10:32:03.603298', '2012-12-20 10:32:03.603298');
INSERT INTO taggings VALUES (265, 108, 47, 'MediaElement', '2012-12-20 10:32:04.15469', '2012-12-20 10:32:04.15469');
INSERT INTO taggings VALUES (266, 5, 47, 'MediaElement', '2012-12-20 10:32:04.161485', '2012-12-20 10:32:04.161485');
INSERT INTO taggings VALUES (267, 83, 47, 'MediaElement', '2012-12-20 10:32:04.168471', '2012-12-20 10:32:04.168471');
INSERT INTO taggings VALUES (268, 23, 47, 'MediaElement', '2012-12-20 10:32:04.175852', '2012-12-20 10:32:04.175852');
INSERT INTO taggings VALUES (269, 16, 47, 'MediaElement', '2012-12-20 10:32:04.183131', '2012-12-20 10:32:04.183131');
INSERT INTO taggings VALUES (270, 103, 47, 'MediaElement', '2012-12-20 10:32:04.190174', '2012-12-20 10:32:04.190174');
INSERT INTO taggings VALUES (271, 108, 48, 'MediaElement', '2012-12-20 10:32:04.729632', '2012-12-20 10:32:04.729632');
INSERT INTO taggings VALUES (272, 5, 48, 'MediaElement', '2012-12-20 10:32:04.736308', '2012-12-20 10:32:04.736308');
INSERT INTO taggings VALUES (273, 83, 48, 'MediaElement', '2012-12-20 10:32:04.7435', '2012-12-20 10:32:04.7435');
INSERT INTO taggings VALUES (274, 23, 48, 'MediaElement', '2012-12-20 10:32:04.750976', '2012-12-20 10:32:04.750976');
INSERT INTO taggings VALUES (275, 16, 48, 'MediaElement', '2012-12-20 10:32:04.758172', '2012-12-20 10:32:04.758172');
INSERT INTO taggings VALUES (276, 103, 48, 'MediaElement', '2012-12-20 10:32:04.765004', '2012-12-20 10:32:04.765004');
INSERT INTO taggings VALUES (277, 87, 48, 'MediaElement', '2012-12-20 10:32:04.772109', '2012-12-20 10:32:04.772109');
INSERT INTO taggings VALUES (278, 107, 49, 'MediaElement', '2012-12-20 10:32:05.24533', '2012-12-20 10:32:05.24533');
INSERT INTO taggings VALUES (279, 5, 49, 'MediaElement', '2012-12-20 10:32:05.252182', '2012-12-20 10:32:05.252182');
INSERT INTO taggings VALUES (280, 83, 49, 'MediaElement', '2012-12-20 10:32:05.259395', '2012-12-20 10:32:05.259395');
INSERT INTO taggings VALUES (281, 103, 49, 'MediaElement', '2012-12-20 10:32:05.266242', '2012-12-20 10:32:05.266242');
INSERT INTO taggings VALUES (282, 109, 49, 'MediaElement', '2012-12-20 10:32:05.276318', '2012-12-20 10:32:05.276318');
INSERT INTO taggings VALUES (283, 110, 50, 'MediaElement', '2012-12-20 10:32:05.962309', '2012-12-20 10:32:05.962309');
INSERT INTO taggings VALUES (284, 107, 50, 'MediaElement', '2012-12-20 10:32:05.968586', '2012-12-20 10:32:05.968586');
INSERT INTO taggings VALUES (285, 5, 50, 'MediaElement', '2012-12-20 10:32:05.975301', '2012-12-20 10:32:05.975301');
INSERT INTO taggings VALUES (286, 83, 50, 'MediaElement', '2012-12-20 10:32:05.982209', '2012-12-20 10:32:05.982209');
INSERT INTO taggings VALUES (287, 103, 50, 'MediaElement', '2012-12-20 10:32:05.989131', '2012-12-20 10:32:05.989131');
INSERT INTO taggings VALUES (288, 109, 50, 'MediaElement', '2012-12-20 10:32:05.995764', '2012-12-20 10:32:05.995764');
INSERT INTO taggings VALUES (289, 111, 51, 'MediaElement', '2012-12-20 10:32:06.588332', '2012-12-20 10:32:06.588332');
INSERT INTO taggings VALUES (290, 5, 51, 'MediaElement', '2012-12-20 10:32:06.596075', '2012-12-20 10:32:06.596075');
INSERT INTO taggings VALUES (291, 112, 51, 'MediaElement', '2012-12-20 10:32:06.606413', '2012-12-20 10:32:06.606413');
INSERT INTO taggings VALUES (292, 113, 51, 'MediaElement', '2012-12-20 10:32:06.616062', '2012-12-20 10:32:06.616062');
INSERT INTO taggings VALUES (293, 111, 52, 'MediaElement', '2012-12-20 10:32:07.132656', '2012-12-20 10:32:07.132656');
INSERT INTO taggings VALUES (294, 114, 52, 'MediaElement', '2012-12-20 10:32:07.141763', '2012-12-20 10:32:07.141763');
INSERT INTO taggings VALUES (295, 115, 52, 'MediaElement', '2012-12-20 10:32:07.15043', '2012-12-20 10:32:07.15043');
INSERT INTO taggings VALUES (296, 5, 52, 'MediaElement', '2012-12-20 10:32:07.156175', '2012-12-20 10:32:07.156175');
INSERT INTO taggings VALUES (297, 116, 52, 'MediaElement', '2012-12-20 10:32:07.16508', '2012-12-20 10:32:07.16508');
INSERT INTO taggings VALUES (298, 117, 52, 'MediaElement', '2012-12-20 10:32:07.175159', '2012-12-20 10:32:07.175159');
INSERT INTO taggings VALUES (299, 118, 52, 'MediaElement', '2012-12-20 10:32:07.18457', '2012-12-20 10:32:07.18457');
INSERT INTO taggings VALUES (300, 119, 53, 'MediaElement', '2012-12-20 10:32:07.789182', '2012-12-20 10:32:07.789182');
INSERT INTO taggings VALUES (301, 63, 53, 'MediaElement', '2012-12-20 10:32:07.796124', '2012-12-20 10:32:07.796124');
INSERT INTO taggings VALUES (302, 114, 53, 'MediaElement', '2012-12-20 10:32:07.803242', '2012-12-20 10:32:07.803242');
INSERT INTO taggings VALUES (303, 115, 53, 'MediaElement', '2012-12-20 10:32:07.810269', '2012-12-20 10:32:07.810269');
INSERT INTO taggings VALUES (304, 5, 53, 'MediaElement', '2012-12-20 10:32:07.817175', '2012-12-20 10:32:07.817175');
INSERT INTO taggings VALUES (305, 116, 53, 'MediaElement', '2012-12-20 10:32:07.824055', '2012-12-20 10:32:07.824055');
INSERT INTO taggings VALUES (306, 117, 53, 'MediaElement', '2012-12-20 10:32:07.831142', '2012-12-20 10:32:07.831142');
INSERT INTO taggings VALUES (307, 118, 53, 'MediaElement', '2012-12-20 10:32:07.837586', '2012-12-20 10:32:07.837586');
INSERT INTO taggings VALUES (308, 120, 53, 'MediaElement', '2012-12-20 10:32:07.847789', '2012-12-20 10:32:07.847789');
INSERT INTO taggings VALUES (309, 109, 54, 'MediaElement', '2012-12-20 10:32:08.491849', '2012-12-20 10:32:08.491849');
INSERT INTO taggings VALUES (310, 107, 54, 'MediaElement', '2012-12-20 10:32:08.498259', '2012-12-20 10:32:08.498259');
INSERT INTO taggings VALUES (311, 103, 54, 'MediaElement', '2012-12-20 10:32:08.504233', '2012-12-20 10:32:08.504233');
INSERT INTO taggings VALUES (312, 5, 54, 'MediaElement', '2012-12-20 10:32:08.510286', '2012-12-20 10:32:08.510286');
INSERT INTO taggings VALUES (313, 121, 54, 'MediaElement', '2012-12-20 10:32:08.519238', '2012-12-20 10:32:08.519238');
INSERT INTO taggings VALUES (314, 109, 55, 'MediaElement', '2012-12-20 10:32:09.002373', '2012-12-20 10:32:09.002373');
INSERT INTO taggings VALUES (315, 107, 55, 'MediaElement', '2012-12-20 10:32:09.009748', '2012-12-20 10:32:09.009748');
INSERT INTO taggings VALUES (316, 103, 55, 'MediaElement', '2012-12-20 10:32:09.016862', '2012-12-20 10:32:09.016862');
INSERT INTO taggings VALUES (317, 5, 55, 'MediaElement', '2012-12-20 10:32:09.024096', '2012-12-20 10:32:09.024096');
INSERT INTO taggings VALUES (318, 121, 55, 'MediaElement', '2012-12-20 10:32:09.031019', '2012-12-20 10:32:09.031019');
INSERT INTO taggings VALUES (319, 1, 56, 'MediaElement', '2012-12-20 10:32:09.710254', '2012-12-20 10:32:09.710254');
INSERT INTO taggings VALUES (320, 122, 56, 'MediaElement', '2012-12-20 10:32:09.720603', '2012-12-20 10:32:09.720603');
INSERT INTO taggings VALUES (321, 5, 56, 'MediaElement', '2012-12-20 10:32:09.727479', '2012-12-20 10:32:09.727479');
INSERT INTO taggings VALUES (322, 4, 56, 'MediaElement', '2012-12-20 10:32:09.734277', '2012-12-20 10:32:09.734277');
INSERT INTO taggings VALUES (323, 123, 56, 'MediaElement', '2012-12-20 10:32:09.743917', '2012-12-20 10:32:09.743917');
INSERT INTO taggings VALUES (324, 124, 57, 'MediaElement', '2012-12-20 10:32:10.452246', '2012-12-20 10:32:10.452246');
INSERT INTO taggings VALUES (325, 15, 57, 'MediaElement', '2012-12-20 10:32:10.458328', '2012-12-20 10:32:10.458328');
INSERT INTO taggings VALUES (326, 125, 57, 'MediaElement', '2012-12-20 10:32:10.466774', '2012-12-20 10:32:10.466774');
INSERT INTO taggings VALUES (327, 126, 57, 'MediaElement', '2012-12-20 10:32:10.475208', '2012-12-20 10:32:10.475208');
INSERT INTO taggings VALUES (328, 127, 57, 'MediaElement', '2012-12-20 10:32:10.483518', '2012-12-20 10:32:10.483518');
INSERT INTO taggings VALUES (329, 23, 58, 'MediaElement', '2012-12-20 10:32:11.114685', '2012-12-20 10:32:11.114685');
INSERT INTO taggings VALUES (330, 5, 58, 'MediaElement', '2012-12-20 10:32:11.120649', '2012-12-20 10:32:11.120649');
INSERT INTO taggings VALUES (331, 24, 58, 'MediaElement', '2012-12-20 10:32:11.126798', '2012-12-20 10:32:11.126798');
INSERT INTO taggings VALUES (332, 16, 58, 'MediaElement', '2012-12-20 10:32:11.132818', '2012-12-20 10:32:11.132818');
INSERT INTO taggings VALUES (333, 90, 58, 'MediaElement', '2012-12-20 10:32:11.138591', '2012-12-20 10:32:11.138591');
INSERT INTO taggings VALUES (334, 23, 59, 'MediaElement', '2012-12-20 10:32:11.601712', '2012-12-20 10:32:11.601712');
INSERT INTO taggings VALUES (335, 5, 59, 'MediaElement', '2012-12-20 10:32:11.607725', '2012-12-20 10:32:11.607725');
INSERT INTO taggings VALUES (336, 121, 59, 'MediaElement', '2012-12-20 10:32:11.613959', '2012-12-20 10:32:11.613959');
INSERT INTO taggings VALUES (337, 109, 59, 'MediaElement', '2012-12-20 10:32:11.620028', '2012-12-20 10:32:11.620028');
INSERT INTO taggings VALUES (338, 103, 59, 'MediaElement', '2012-12-20 10:32:11.626357', '2012-12-20 10:32:11.626357');
INSERT INTO taggings VALUES (339, 23, 60, 'MediaElement', '2012-12-20 10:32:12.345626', '2012-12-20 10:32:12.345626');
INSERT INTO taggings VALUES (340, 5, 60, 'MediaElement', '2012-12-20 10:32:12.353334', '2012-12-20 10:32:12.353334');
INSERT INTO taggings VALUES (341, 87, 60, 'MediaElement', '2012-12-20 10:32:12.360914', '2012-12-20 10:32:12.360914');
INSERT INTO taggings VALUES (342, 16, 60, 'MediaElement', '2012-12-20 10:32:12.368438', '2012-12-20 10:32:12.368438');
INSERT INTO taggings VALUES (343, 59, 60, 'MediaElement', '2012-12-20 10:32:12.375117', '2012-12-20 10:32:12.375117');
INSERT INTO taggings VALUES (344, 128, 60, 'MediaElement', '2012-12-20 10:32:12.430138', '2012-12-20 10:32:12.430138');
INSERT INTO taggings VALUES (345, 90, 60, 'MediaElement', '2012-12-20 10:32:12.436569', '2012-12-20 10:32:12.436569');
INSERT INTO taggings VALUES (346, 44, 60, 'MediaElement', '2012-12-20 10:32:12.442952', '2012-12-20 10:32:12.442952');
INSERT INTO taggings VALUES (347, 64, 61, 'MediaElement', '2012-12-20 10:32:13.041709', '2012-12-20 10:32:13.041709');
INSERT INTO taggings VALUES (348, 5, 61, 'MediaElement', '2012-12-20 10:32:13.048132', '2012-12-20 10:32:13.048132');
INSERT INTO taggings VALUES (349, 61, 61, 'MediaElement', '2012-12-20 10:32:13.05498', '2012-12-20 10:32:13.05498');
INSERT INTO taggings VALUES (350, 103, 61, 'MediaElement', '2012-12-20 10:32:13.061762', '2012-12-20 10:32:13.061762');
INSERT INTO taggings VALUES (351, 121, 61, 'MediaElement', '2012-12-20 10:32:13.068254', '2012-12-20 10:32:13.068254');
INSERT INTO taggings VALUES (352, 129, 62, 'MediaElement', '2012-12-20 10:32:13.74743', '2012-12-20 10:32:13.74743');
INSERT INTO taggings VALUES (353, 103, 62, 'MediaElement', '2012-12-20 10:32:13.754196', '2012-12-20 10:32:13.754196');
INSERT INTO taggings VALUES (354, 121, 62, 'MediaElement', '2012-12-20 10:32:13.761505', '2012-12-20 10:32:13.761505');
INSERT INTO taggings VALUES (355, 130, 62, 'MediaElement', '2012-12-20 10:32:13.771201', '2012-12-20 10:32:13.771201');
INSERT INTO taggings VALUES (365, 131, 65, 'MediaElement', '2012-12-20 13:20:09.715038', '2012-12-20 13:20:09.715038');
INSERT INTO taggings VALUES (366, 132, 65, 'MediaElement', '2012-12-20 13:20:09.721758', '2012-12-20 13:20:09.721758');
INSERT INTO taggings VALUES (367, 133, 65, 'MediaElement', '2012-12-20 13:20:09.727627', '2012-12-20 13:20:09.727627');
INSERT INTO taggings VALUES (368, 44, 65, 'MediaElement', '2012-12-20 13:20:09.733437', '2012-12-20 13:20:09.733437');
INSERT INTO taggings VALUES (369, 8, 66, 'MediaElement', '2012-12-20 13:21:51.004261', '2012-12-20 13:21:51.004261');
INSERT INTO taggings VALUES (370, 134, 66, 'MediaElement', '2012-12-20 13:21:51.010612', '2012-12-20 13:21:51.010612');
INSERT INTO taggings VALUES (371, 44, 66, 'MediaElement', '2012-12-20 13:21:51.01648', '2012-12-20 13:21:51.01648');
INSERT INTO taggings VALUES (372, 137, 66, 'MediaElement', '2012-12-20 13:21:51.025347', '2012-12-20 13:21:51.025347');
INSERT INTO taggings VALUES (373, 8, 67, 'MediaElement', '2012-12-20 13:33:22.989461', '2012-12-20 13:33:22.989461');
INSERT INTO taggings VALUES (374, 134, 67, 'MediaElement', '2012-12-20 13:33:22.995663', '2012-12-20 13:33:22.995663');
INSERT INTO taggings VALUES (375, 137, 67, 'MediaElement', '2012-12-20 13:33:23.001752', '2012-12-20 13:33:23.001752');
INSERT INTO taggings VALUES (376, 44, 67, 'MediaElement', '2012-12-20 13:33:23.007676', '2012-12-20 13:33:23.007676');
INSERT INTO taggings VALUES (377, 37, 67, 'MediaElement', '2012-12-20 13:33:23.013598', '2012-12-20 13:33:23.013598');
INSERT INTO taggings VALUES (378, 138, 68, 'MediaElement', '2012-12-20 13:35:47.090434', '2012-12-20 13:35:47.090434');
INSERT INTO taggings VALUES (379, 134, 68, 'MediaElement', '2012-12-20 13:35:47.09637', '2012-12-20 13:35:47.09637');
INSERT INTO taggings VALUES (380, 8, 68, 'MediaElement', '2012-12-20 13:35:47.102451', '2012-12-20 13:35:47.102451');
INSERT INTO taggings VALUES (381, 44, 68, 'MediaElement', '2012-12-20 13:35:47.10835', '2012-12-20 13:35:47.10835');
INSERT INTO taggings VALUES (382, 8, 69, 'MediaElement', '2012-12-20 13:36:55.055038', '2012-12-20 13:36:55.055038');
INSERT INTO taggings VALUES (383, 138, 69, 'MediaElement', '2012-12-20 13:36:55.061413', '2012-12-20 13:36:55.061413');
INSERT INTO taggings VALUES (384, 134, 69, 'MediaElement', '2012-12-20 13:36:55.067251', '2012-12-20 13:36:55.067251');
INSERT INTO taggings VALUES (385, 139, 69, 'MediaElement', '2012-12-20 13:36:55.075902', '2012-12-20 13:36:55.075902');
INSERT INTO taggings VALUES (386, 44, 69, 'MediaElement', '2012-12-20 13:36:55.081826', '2012-12-20 13:36:55.081826');
INSERT INTO taggings VALUES (387, 8, 70, 'MediaElement', '2012-12-20 13:37:53.226043', '2012-12-20 13:37:53.226043');
INSERT INTO taggings VALUES (388, 140, 70, 'MediaElement', '2012-12-20 13:37:53.235374', '2012-12-20 13:37:53.235374');
INSERT INTO taggings VALUES (389, 134, 70, 'MediaElement', '2012-12-20 13:37:53.241794', '2012-12-20 13:37:53.241794');
INSERT INTO taggings VALUES (390, 17, 70, 'MediaElement', '2012-12-20 13:37:53.24763', '2012-12-20 13:37:53.24763');
INSERT INTO taggings VALUES (391, 44, 70, 'MediaElement', '2012-12-20 13:37:53.253637', '2012-12-20 13:37:53.253637');
INSERT INTO taggings VALUES (392, 141, 71, 'MediaElement', '2012-12-20 13:38:54.795657', '2012-12-20 13:38:54.795657');
INSERT INTO taggings VALUES (393, 134, 71, 'MediaElement', '2012-12-20 13:38:54.801878', '2012-12-20 13:38:54.801878');
INSERT INTO taggings VALUES (394, 8, 71, 'MediaElement', '2012-12-20 13:38:54.807771', '2012-12-20 13:38:54.807771');
INSERT INTO taggings VALUES (395, 138, 71, 'MediaElement', '2012-12-20 13:38:54.813741', '2012-12-20 13:38:54.813741');
INSERT INTO taggings VALUES (396, 17, 71, 'MediaElement', '2012-12-20 13:38:54.819441', '2012-12-20 13:38:54.819441');
INSERT INTO taggings VALUES (397, 44, 71, 'MediaElement', '2012-12-20 13:38:54.825452', '2012-12-20 13:38:54.825452');
INSERT INTO taggings VALUES (398, 138, 72, 'MediaElement', '2012-12-20 13:39:58.387339', '2012-12-20 13:39:58.387339');
INSERT INTO taggings VALUES (399, 134, 72, 'MediaElement', '2012-12-20 13:39:58.393571', '2012-12-20 13:39:58.393571');
INSERT INTO taggings VALUES (400, 17, 72, 'MediaElement', '2012-12-20 13:39:58.399443', '2012-12-20 13:39:58.399443');
INSERT INTO taggings VALUES (401, 44, 72, 'MediaElement', '2012-12-20 13:39:58.405489', '2012-12-20 13:39:58.405489');
INSERT INTO taggings VALUES (402, 8, 72, 'MediaElement', '2012-12-20 13:39:58.411241', '2012-12-20 13:39:58.411241');
INSERT INTO taggings VALUES (403, 134, 1, 'Lesson', '2012-12-20 13:42:17.799645', '2012-12-20 13:42:17.799645');
INSERT INTO taggings VALUES (404, 138, 1, 'Lesson', '2012-12-20 13:42:17.80546', '2012-12-20 13:42:17.80546');
INSERT INTO taggings VALUES (405, 8, 1, 'Lesson', '2012-12-20 13:42:17.810897', '2012-12-20 13:42:17.810897');
INSERT INTO taggings VALUES (406, 44, 1, 'Lesson', '2012-12-20 13:42:17.8163', '2012-12-20 13:42:17.8163');
INSERT INTO taggings VALUES (407, 17, 1, 'Lesson', '2012-12-20 13:42:17.821875', '2012-12-20 13:42:17.821875');
INSERT INTO taggings VALUES (408, 12, 73, 'MediaElement', '2012-12-20 14:26:18.710216', '2012-12-20 14:26:18.710216');
INSERT INTO taggings VALUES (409, 76, 73, 'MediaElement', '2012-12-20 14:26:18.716894', '2012-12-20 14:26:18.716894');
INSERT INTO taggings VALUES (410, 72, 73, 'MediaElement', '2012-12-20 14:26:18.723025', '2012-12-20 14:26:18.723025');
INSERT INTO taggings VALUES (411, 142, 73, 'MediaElement', '2012-12-20 14:26:18.731762', '2012-12-20 14:26:18.731762');
INSERT INTO taggings VALUES (412, 143, 73, 'MediaElement', '2012-12-20 14:26:18.740378', '2012-12-20 14:26:18.740378');
INSERT INTO taggings VALUES (413, 76, 74, 'MediaElement', '2012-12-20 14:28:12.837925', '2012-12-20 14:28:12.837925');
INSERT INTO taggings VALUES (414, 12, 74, 'MediaElement', '2012-12-20 14:28:12.900601', '2012-12-20 14:28:12.900601');
INSERT INTO taggings VALUES (415, 143, 74, 'MediaElement', '2012-12-20 14:28:12.90664', '2012-12-20 14:28:12.90664');
INSERT INTO taggings VALUES (416, 144, 74, 'MediaElement', '2012-12-20 14:28:12.914989', '2012-12-20 14:28:12.914989');
INSERT INTO taggings VALUES (417, 142, 74, 'MediaElement', '2012-12-20 14:28:12.920393', '2012-12-20 14:28:12.920393');
INSERT INTO taggings VALUES (418, 76, 75, 'MediaElement', '2012-12-20 14:33:10.872589', '2012-12-20 14:33:10.872589');
INSERT INTO taggings VALUES (419, 12, 75, 'MediaElement', '2012-12-20 14:33:10.879074', '2012-12-20 14:33:10.879074');
INSERT INTO taggings VALUES (420, 142, 75, 'MediaElement', '2012-12-20 14:33:10.885284', '2012-12-20 14:33:10.885284');
INSERT INTO taggings VALUES (421, 18, 75, 'MediaElement', '2012-12-20 14:33:10.891082', '2012-12-20 14:33:10.891082');
INSERT INTO taggings VALUES (422, 76, 76, 'MediaElement', '2012-12-20 14:45:44.878908', '2012-12-20 14:45:44.878908');
INSERT INTO taggings VALUES (423, 145, 76, 'MediaElement', '2012-12-20 14:45:44.888096', '2012-12-20 14:45:44.888096');
INSERT INTO taggings VALUES (424, 142, 76, 'MediaElement', '2012-12-20 14:45:44.894236', '2012-12-20 14:45:44.894236');
INSERT INTO taggings VALUES (425, 146, 76, 'MediaElement', '2012-12-20 14:45:44.902666', '2012-12-20 14:45:44.902666');
INSERT INTO taggings VALUES (426, 147, 2, 'Lesson', '2012-12-20 14:55:07.545372', '2012-12-20 14:55:07.545372');
INSERT INTO taggings VALUES (427, 12, 2, 'Lesson', '2012-12-20 14:55:07.550765', '2012-12-20 14:55:07.550765');
INSERT INTO taggings VALUES (428, 18, 2, 'Lesson', '2012-12-20 14:55:07.556149', '2012-12-20 14:55:07.556149');
INSERT INTO taggings VALUES (429, 142, 2, 'Lesson', '2012-12-20 14:55:07.561495', '2012-12-20 14:55:07.561495');
INSERT INTO taggings VALUES (430, 148, 3, 'Lesson', '2012-12-20 14:59:28.73756', '2012-12-20 14:59:28.73756');
INSERT INTO taggings VALUES (431, 149, 3, 'Lesson', '2012-12-20 14:59:28.745555', '2012-12-20 14:59:28.745555');
INSERT INTO taggings VALUES (432, 150, 3, 'Lesson', '2012-12-20 14:59:28.75335', '2012-12-20 14:59:28.75335');
INSERT INTO taggings VALUES (433, 151, 3, 'Lesson', '2012-12-20 14:59:28.761277', '2012-12-20 14:59:28.761277');
INSERT INTO taggings VALUES (434, 17, 4, 'Lesson', '2012-12-20 15:21:55.905772', '2012-12-20 15:21:55.905772');
INSERT INTO taggings VALUES (435, 12, 4, 'Lesson', '2012-12-20 15:21:55.912459', '2012-12-20 15:21:55.912459');
INSERT INTO taggings VALUES (436, 18, 4, 'Lesson', '2012-12-20 15:21:55.917932', '2012-12-20 15:21:55.917932');
INSERT INTO taggings VALUES (437, 152, 4, 'Lesson', '2012-12-20 15:21:55.927367', '2012-12-20 15:21:55.927367');
INSERT INTO taggings VALUES (438, 153, 77, 'MediaElement', '2012-12-20 16:19:35.670815', '2012-12-20 16:19:35.670815');
INSERT INTO taggings VALUES (439, 154, 77, 'MediaElement', '2012-12-20 16:19:35.681156', '2012-12-20 16:19:35.681156');
INSERT INTO taggings VALUES (440, 155, 77, 'MediaElement', '2012-12-20 16:19:35.689785', '2012-12-20 16:19:35.689785');
INSERT INTO taggings VALUES (441, 8, 77, 'MediaElement', '2012-12-20 16:19:35.695393', '2012-12-20 16:19:35.695393');
INSERT INTO taggings VALUES (442, 153, 78, 'MediaElement', '2012-12-20 16:22:19.313908', '2012-12-20 16:22:19.313908');
INSERT INTO taggings VALUES (443, 8, 78, 'MediaElement', '2012-12-20 16:22:19.319987', '2012-12-20 16:22:19.319987');
INSERT INTO taggings VALUES (444, 156, 78, 'MediaElement', '2012-12-20 16:22:19.328605', '2012-12-20 16:22:19.328605');
INSERT INTO taggings VALUES (445, 157, 78, 'MediaElement', '2012-12-20 16:22:19.337089', '2012-12-20 16:22:19.337089');
INSERT INTO taggings VALUES (446, 146, 5, 'Lesson', '2012-12-20 16:23:57.776484', '2012-12-20 16:23:57.776484');
INSERT INTO taggings VALUES (447, 8, 5, 'Lesson', '2012-12-20 16:23:57.782255', '2012-12-20 16:23:57.782255');
INSERT INTO taggings VALUES (448, 135, 5, 'Lesson', '2012-12-20 16:23:57.78773', '2012-12-20 16:23:57.78773');
INSERT INTO taggings VALUES (449, 158, 5, 'Lesson', '2012-12-20 16:23:57.795915', '2012-12-20 16:23:57.795915');
INSERT INTO taggings VALUES (450, 17, 5, 'Lesson', '2012-12-20 16:23:57.801522', '2012-12-20 16:23:57.801522');
INSERT INTO taggings VALUES (451, 153, 79, 'MediaElement', '2012-12-20 16:24:45.675012', '2012-12-20 16:24:45.675012');
INSERT INTO taggings VALUES (452, 8, 79, 'MediaElement', '2012-12-20 16:24:45.681187', '2012-12-20 16:24:45.681187');
INSERT INTO taggings VALUES (453, 159, 79, 'MediaElement', '2012-12-20 16:24:45.689871', '2012-12-20 16:24:45.689871');
INSERT INTO taggings VALUES (454, 160, 79, 'MediaElement', '2012-12-20 16:24:45.698267', '2012-12-20 16:24:45.698267');
INSERT INTO taggings VALUES (455, 153, 80, 'MediaElement', '2012-12-20 16:25:30.299085', '2012-12-20 16:25:30.299085');
INSERT INTO taggings VALUES (456, 8, 80, 'MediaElement', '2012-12-20 16:25:30.305211', '2012-12-20 16:25:30.305211');
INSERT INTO taggings VALUES (457, 159, 80, 'MediaElement', '2012-12-20 16:25:30.310999', '2012-12-20 16:25:30.310999');
INSERT INTO taggings VALUES (458, 160, 80, 'MediaElement', '2012-12-20 16:25:30.316816', '2012-12-20 16:25:30.316816');
INSERT INTO taggings VALUES (459, 153, 81, 'MediaElement', '2012-12-20 16:26:22.945352', '2012-12-20 16:26:22.945352');
INSERT INTO taggings VALUES (460, 8, 81, 'MediaElement', '2012-12-20 16:26:22.951426', '2012-12-20 16:26:22.951426');
INSERT INTO taggings VALUES (461, 159, 81, 'MediaElement', '2012-12-20 16:26:22.957534', '2012-12-20 16:26:22.957534');
INSERT INTO taggings VALUES (462, 160, 81, 'MediaElement', '2012-12-20 16:26:22.963292', '2012-12-20 16:26:22.963292');
INSERT INTO taggings VALUES (463, 161, 82, 'MediaElement', '2012-12-20 16:27:00.512882', '2012-12-20 16:27:00.512882');
INSERT INTO taggings VALUES (464, 162, 82, 'MediaElement', '2012-12-20 16:27:00.521664', '2012-12-20 16:27:00.521664');
INSERT INTO taggings VALUES (465, 151, 82, 'MediaElement', '2012-12-20 16:27:00.52747', '2012-12-20 16:27:00.52747');
INSERT INTO taggings VALUES (466, 163, 82, 'MediaElement', '2012-12-20 16:27:00.535961', '2012-12-20 16:27:00.535961');
INSERT INTO taggings VALUES (467, 153, 83, 'MediaElement', '2012-12-20 16:27:10.766426', '2012-12-20 16:27:10.766426');
INSERT INTO taggings VALUES (468, 8, 83, 'MediaElement', '2012-12-20 16:27:10.772386', '2012-12-20 16:27:10.772386');
INSERT INTO taggings VALUES (469, 159, 83, 'MediaElement', '2012-12-20 16:27:10.778479', '2012-12-20 16:27:10.778479');
INSERT INTO taggings VALUES (470, 160, 83, 'MediaElement', '2012-12-20 16:27:10.78423', '2012-12-20 16:27:10.78423');
INSERT INTO taggings VALUES (471, 153, 84, 'MediaElement', '2012-12-20 16:28:21.717083', '2012-12-20 16:28:21.717083');
INSERT INTO taggings VALUES (472, 8, 84, 'MediaElement', '2012-12-20 16:28:21.779379', '2012-12-20 16:28:21.779379');
INSERT INTO taggings VALUES (473, 159, 84, 'MediaElement', '2012-12-20 16:28:21.786016', '2012-12-20 16:28:21.786016');
INSERT INTO taggings VALUES (474, 160, 84, 'MediaElement', '2012-12-20 16:28:21.791557', '2012-12-20 16:28:21.791557');
INSERT INTO taggings VALUES (476, 8, 85, 'MediaElement', '2012-12-20 16:28:35.86844', '2012-12-20 16:28:35.86844');
INSERT INTO taggings VALUES (477, 146, 85, 'MediaElement', '2012-12-20 16:28:35.874589', '2012-12-20 16:28:35.874589');
INSERT INTO taggings VALUES (478, 17, 85, 'MediaElement', '2012-12-20 16:28:35.88048', '2012-12-20 16:28:35.88048');
INSERT INTO taggings VALUES (479, 37, 85, 'MediaElement', '2012-12-20 16:28:35.886453', '2012-12-20 16:28:35.886453');
INSERT INTO taggings VALUES (480, 153, 86, 'MediaElement', '2012-12-20 16:29:45.185203', '2012-12-20 16:29:45.185203');
INSERT INTO taggings VALUES (481, 8, 86, 'MediaElement', '2012-12-20 16:29:45.191109', '2012-12-20 16:29:45.191109');
INSERT INTO taggings VALUES (482, 159, 86, 'MediaElement', '2012-12-20 16:29:45.197302', '2012-12-20 16:29:45.197302');
INSERT INTO taggings VALUES (483, 160, 86, 'MediaElement', '2012-12-20 16:29:45.203126', '2012-12-20 16:29:45.203126');
INSERT INTO taggings VALUES (484, 146, 87, 'MediaElement', '2012-12-20 16:30:23.126495', '2012-12-20 16:30:23.126495');
INSERT INTO taggings VALUES (485, 8, 87, 'MediaElement', '2012-12-20 16:30:23.132532', '2012-12-20 16:30:23.132532');
INSERT INTO taggings VALUES (486, 164, 87, 'MediaElement', '2012-12-20 16:30:23.141564', '2012-12-20 16:30:23.141564');
INSERT INTO taggings VALUES (487, 17, 87, 'MediaElement', '2012-12-20 16:30:23.147443', '2012-12-20 16:30:23.147443');
INSERT INTO taggings VALUES (488, 153, 88, 'MediaElement', '2012-12-20 16:30:58.986351', '2012-12-20 16:30:58.986351');
INSERT INTO taggings VALUES (489, 8, 88, 'MediaElement', '2012-12-20 16:30:58.992288', '2012-12-20 16:30:58.992288');
INSERT INTO taggings VALUES (490, 159, 88, 'MediaElement', '2012-12-20 16:30:58.99829', '2012-12-20 16:30:58.99829');
INSERT INTO taggings VALUES (491, 160, 88, 'MediaElement', '2012-12-20 16:30:59.004019', '2012-12-20 16:30:59.004019');
INSERT INTO taggings VALUES (492, 165, 89, 'MediaElement', '2012-12-20 16:32:57.569204', '2012-12-20 16:32:57.569204');
INSERT INTO taggings VALUES (493, 166, 89, 'MediaElement', '2012-12-20 16:32:57.578092', '2012-12-20 16:32:57.578092');
INSERT INTO taggings VALUES (494, 146, 89, 'MediaElement', '2012-12-20 16:32:57.58393', '2012-12-20 16:32:57.58393');
INSERT INTO taggings VALUES (495, 8, 89, 'MediaElement', '2012-12-20 16:32:57.589923', '2012-12-20 16:32:57.589923');
INSERT INTO taggings VALUES (496, 153, 6, 'Lesson', '2012-12-20 16:33:20.421098', '2012-12-20 16:33:20.421098');
INSERT INTO taggings VALUES (497, 8, 6, 'Lesson', '2012-12-20 16:33:20.426565', '2012-12-20 16:33:20.426565');
INSERT INTO taggings VALUES (498, 159, 6, 'Lesson', '2012-12-20 16:33:20.431918', '2012-12-20 16:33:20.431918');
INSERT INTO taggings VALUES (499, 160, 6, 'Lesson', '2012-12-20 16:33:20.437349', '2012-12-20 16:33:20.437349');
INSERT INTO taggings VALUES (500, 166, 85, 'MediaElement', '2012-12-20 16:33:20.605124', '2012-12-20 16:33:20.605124');
INSERT INTO taggings VALUES (505, 166, 91, 'MediaElement', '2012-12-20 16:34:00.438362', '2012-12-20 16:34:00.438362');
INSERT INTO taggings VALUES (506, 8, 91, 'MediaElement', '2012-12-20 16:34:00.444508', '2012-12-20 16:34:00.444508');
INSERT INTO taggings VALUES (507, 146, 91, 'MediaElement', '2012-12-20 16:34:00.450534', '2012-12-20 16:34:00.450534');
INSERT INTO taggings VALUES (508, 17, 91, 'MediaElement', '2012-12-20 16:34:00.456329', '2012-12-20 16:34:00.456329');
INSERT INTO taggings VALUES (509, 37, 91, 'MediaElement', '2012-12-20 16:34:00.462266', '2012-12-20 16:34:00.462266');
INSERT INTO taggings VALUES (510, 8, 92, 'MediaElement', '2012-12-20 16:35:44.217856', '2012-12-20 16:35:44.217856');
INSERT INTO taggings VALUES (511, 166, 92, 'MediaElement', '2012-12-20 16:35:44.22419', '2012-12-20 16:35:44.22419');
INSERT INTO taggings VALUES (512, 146, 92, 'MediaElement', '2012-12-20 16:35:44.230224', '2012-12-20 16:35:44.230224');
INSERT INTO taggings VALUES (513, 17, 92, 'MediaElement', '2012-12-20 16:35:44.23615', '2012-12-20 16:35:44.23615');
INSERT INTO taggings VALUES (514, 146, 93, 'MediaElement', '2012-12-20 16:38:23.506126', '2012-12-20 16:38:23.506126');
INSERT INTO taggings VALUES (515, 8, 93, 'MediaElement', '2012-12-20 16:38:23.512244', '2012-12-20 16:38:23.512244');
INSERT INTO taggings VALUES (516, 171, 93, 'MediaElement', '2012-12-20 16:38:23.521297', '2012-12-20 16:38:23.521297');
INSERT INTO taggings VALUES (517, 37, 93, 'MediaElement', '2012-12-20 16:38:23.527097', '2012-12-20 16:38:23.527097');
INSERT INTO taggings VALUES (518, 139, 93, 'MediaElement', '2012-12-20 16:38:23.533094', '2012-12-20 16:38:23.533094');
INSERT INTO taggings VALUES (524, 173, 95, 'MediaElement', '2012-12-20 16:39:39.796271', '2012-12-20 16:39:39.796271');
INSERT INTO taggings VALUES (525, 151, 95, 'MediaElement', '2012-12-20 16:39:39.802269', '2012-12-20 16:39:39.802269');
INSERT INTO taggings VALUES (526, 174, 95, 'MediaElement', '2012-12-20 16:39:39.810804', '2012-12-20 16:39:39.810804');
INSERT INTO taggings VALUES (527, 25, 95, 'MediaElement', '2012-12-20 16:39:39.81653', '2012-12-20 16:39:39.81653');
INSERT INTO taggings VALUES (528, 146, 96, 'MediaElement', '2012-12-20 16:40:29.798473', '2012-12-20 16:40:29.798473');
INSERT INTO taggings VALUES (529, 172, 96, 'MediaElement', '2012-12-20 16:40:29.804827', '2012-12-20 16:40:29.804827');
INSERT INTO taggings VALUES (530, 139, 96, 'MediaElement', '2012-12-20 16:40:29.811226', '2012-12-20 16:40:29.811226');
INSERT INTO taggings VALUES (531, 8, 96, 'MediaElement', '2012-12-20 16:40:29.817306', '2012-12-20 16:40:29.817306');
INSERT INTO taggings VALUES (532, 37, 96, 'MediaElement', '2012-12-20 16:40:29.823014', '2012-12-20 16:40:29.823014');
INSERT INTO taggings VALUES (533, 175, 97, 'MediaElement', '2012-12-20 16:42:06.27799', '2012-12-20 16:42:06.27799');
INSERT INTO taggings VALUES (534, 176, 97, 'MediaElement', '2012-12-20 16:42:06.287159', '2012-12-20 16:42:06.287159');
INSERT INTO taggings VALUES (535, 146, 97, 'MediaElement', '2012-12-20 16:42:06.293254', '2012-12-20 16:42:06.293254');
INSERT INTO taggings VALUES (536, 8, 97, 'MediaElement', '2012-12-20 16:42:06.299073', '2012-12-20 16:42:06.299073');
INSERT INTO taggings VALUES (537, 177, 97, 'MediaElement', '2012-12-20 16:42:06.307596', '2012-12-20 16:42:06.307596');
INSERT INTO taggings VALUES (538, 178, 97, 'MediaElement', '2012-12-20 16:42:06.31602', '2012-12-20 16:42:06.31602');
INSERT INTO taggings VALUES (539, 146, 98, 'MediaElement', '2012-12-20 16:44:03.722927', '2012-12-20 16:44:03.722927');
INSERT INTO taggings VALUES (540, 8, 98, 'MediaElement', '2012-12-20 16:44:03.729009', '2012-12-20 16:44:03.729009');
INSERT INTO taggings VALUES (541, 177, 98, 'MediaElement', '2012-12-20 16:44:03.734993', '2012-12-20 16:44:03.734993');
INSERT INTO taggings VALUES (542, 178, 98, 'MediaElement', '2012-12-20 16:44:03.740915', '2012-12-20 16:44:03.740915');
INSERT INTO taggings VALUES (543, 37, 98, 'MediaElement', '2012-12-20 16:44:03.746792', '2012-12-20 16:44:03.746792');
INSERT INTO taggings VALUES (544, 179, 99, 'MediaElement', '2012-12-20 16:44:24.837141', '2012-12-20 16:44:24.837141');
INSERT INTO taggings VALUES (545, 180, 99, 'MediaElement', '2012-12-20 16:44:24.846312', '2012-12-20 16:44:24.846312');
INSERT INTO taggings VALUES (546, 181, 99, 'MediaElement', '2012-12-20 16:44:24.855535', '2012-12-20 16:44:24.855535');
INSERT INTO taggings VALUES (547, 182, 99, 'MediaElement', '2012-12-20 16:44:24.864172', '2012-12-20 16:44:24.864172');
INSERT INTO taggings VALUES (548, 183, 100, 'MediaElement', '2012-12-20 16:48:26.729898', '2012-12-20 16:48:26.729898');
INSERT INTO taggings VALUES (549, 160, 100, 'MediaElement', '2012-12-20 16:48:26.736064', '2012-12-20 16:48:26.736064');
INSERT INTO taggings VALUES (550, 159, 100, 'MediaElement', '2012-12-20 16:48:26.742208', '2012-12-20 16:48:26.742208');
INSERT INTO taggings VALUES (551, 8, 100, 'MediaElement', '2012-12-20 16:48:26.748076', '2012-12-20 16:48:26.748076');
INSERT INTO taggings VALUES (552, 146, 101, 'MediaElement', '2012-12-20 16:49:32.555908', '2012-12-20 16:49:32.555908');
INSERT INTO taggings VALUES (553, 8, 101, 'MediaElement', '2012-12-20 16:49:32.562157', '2012-12-20 16:49:32.562157');
INSERT INTO taggings VALUES (554, 177, 101, 'MediaElement', '2012-12-20 16:49:32.568094', '2012-12-20 16:49:32.568094');
INSERT INTO taggings VALUES (555, 178, 101, 'MediaElement', '2012-12-20 16:49:32.574227', '2012-12-20 16:49:32.574227');
INSERT INTO taggings VALUES (556, 184, 101, 'MediaElement', '2012-12-20 16:49:32.58298', '2012-12-20 16:49:32.58298');
INSERT INTO taggings VALUES (557, 185, 102, 'MediaElement', '2012-12-20 16:50:32.135626', '2012-12-20 16:50:32.135626');
INSERT INTO taggings VALUES (558, 146, 102, 'MediaElement', '2012-12-20 16:50:32.143', '2012-12-20 16:50:32.143');
INSERT INTO taggings VALUES (559, 8, 102, 'MediaElement', '2012-12-20 16:50:32.150119', '2012-12-20 16:50:32.150119');
INSERT INTO taggings VALUES (560, 177, 102, 'MediaElement', '2012-12-20 16:50:32.156484', '2012-12-20 16:50:32.156484');
INSERT INTO taggings VALUES (565, 46, 104, 'MediaElement', '2012-12-21 08:39:08.431694', '2012-12-21 08:39:08.431694');
INSERT INTO taggings VALUES (566, 188, 104, 'MediaElement', '2012-12-21 08:39:08.442061', '2012-12-21 08:39:08.442061');
INSERT INTO taggings VALUES (567, 189, 104, 'MediaElement', '2012-12-21 08:39:08.451695', '2012-12-21 08:39:08.451695');
INSERT INTO taggings VALUES (568, 190, 104, 'MediaElement', '2012-12-21 08:39:08.460587', '2012-12-21 08:39:08.460587');
INSERT INTO taggings VALUES (569, 191, 105, 'MediaElement', '2012-12-21 08:41:02.790313', '2012-12-21 08:41:02.790313');
INSERT INTO taggings VALUES (570, 192, 105, 'MediaElement', '2012-12-21 08:41:02.800016', '2012-12-21 08:41:02.800016');
INSERT INTO taggings VALUES (571, 193, 105, 'MediaElement', '2012-12-21 08:41:02.809535', '2012-12-21 08:41:02.809535');
INSERT INTO taggings VALUES (572, 194, 105, 'MediaElement', '2012-12-21 08:41:02.818725', '2012-12-21 08:41:02.818725');
INSERT INTO taggings VALUES (573, 195, 106, 'MediaElement', '2012-12-21 08:42:46.400451', '2012-12-21 08:42:46.400451');
INSERT INTO taggings VALUES (574, 196, 106, 'MediaElement', '2012-12-21 08:42:46.409795', '2012-12-21 08:42:46.409795');
INSERT INTO taggings VALUES (575, 47, 106, 'MediaElement', '2012-12-21 08:42:46.415844', '2012-12-21 08:42:46.415844');
INSERT INTO taggings VALUES (576, 197, 106, 'MediaElement', '2012-12-21 08:42:46.424723', '2012-12-21 08:42:46.424723');
INSERT INTO taggings VALUES (577, 198, 107, 'MediaElement', '2012-12-21 08:45:04.010777', '2012-12-21 08:45:04.010777');
INSERT INTO taggings VALUES (578, 151, 107, 'MediaElement', '2012-12-21 08:45:04.017231', '2012-12-21 08:45:04.017231');
INSERT INTO taggings VALUES (579, 199, 107, 'MediaElement', '2012-12-21 08:45:04.026163', '2012-12-21 08:45:04.026163');
INSERT INTO taggings VALUES (580, 200, 107, 'MediaElement', '2012-12-21 08:45:04.035192', '2012-12-21 08:45:04.035192');
INSERT INTO taggings VALUES (581, 201, 107, 'MediaElement', '2012-12-21 08:45:04.044006', '2012-12-21 08:45:04.044006');
INSERT INTO taggings VALUES (582, 153, 108, 'MediaElement', '2012-12-21 09:19:02.450311', '2012-12-21 09:19:02.450311');
INSERT INTO taggings VALUES (583, 159, 108, 'MediaElement', '2012-12-21 09:19:02.457538', '2012-12-21 09:19:02.457538');
INSERT INTO taggings VALUES (584, 8, 108, 'MediaElement', '2012-12-21 09:19:02.46388', '2012-12-21 09:19:02.46388');
INSERT INTO taggings VALUES (585, 160, 108, 'MediaElement', '2012-12-21 09:19:02.470512', '2012-12-21 09:19:02.470512');
INSERT INTO taggings VALUES (586, 153, 109, 'MediaElement', '2012-12-21 09:20:24.85112', '2012-12-21 09:20:24.85112');
INSERT INTO taggings VALUES (587, 8, 109, 'MediaElement', '2012-12-21 09:20:24.858022', '2012-12-21 09:20:24.858022');
INSERT INTO taggings VALUES (588, 159, 109, 'MediaElement', '2012-12-21 09:20:24.864223', '2012-12-21 09:20:24.864223');
INSERT INTO taggings VALUES (589, 160, 109, 'MediaElement', '2012-12-21 09:20:24.87158', '2012-12-21 09:20:24.87158');
INSERT INTO taggings VALUES (590, 146, 110, 'MediaElement', '2012-12-21 09:22:39.766679', '2012-12-21 09:22:39.766679');
INSERT INTO taggings VALUES (591, 8, 110, 'MediaElement', '2012-12-21 09:22:39.773765', '2012-12-21 09:22:39.773765');
INSERT INTO taggings VALUES (592, 17, 110, 'MediaElement', '2012-12-21 09:22:39.780264', '2012-12-21 09:22:39.780264');
INSERT INTO taggings VALUES (593, 171, 110, 'MediaElement', '2012-12-21 09:22:39.786613', '2012-12-21 09:22:39.786613');
INSERT INTO taggings VALUES (594, 137, 110, 'MediaElement', '2012-12-21 09:22:39.793113', '2012-12-21 09:22:39.793113');
INSERT INTO taggings VALUES (595, 153, 111, 'MediaElement', '2012-12-21 09:22:46.422766', '2012-12-21 09:22:46.422766');
INSERT INTO taggings VALUES (596, 8, 111, 'MediaElement', '2012-12-21 09:22:46.429367', '2012-12-21 09:22:46.429367');
INSERT INTO taggings VALUES (597, 159, 111, 'MediaElement', '2012-12-21 09:22:46.435604', '2012-12-21 09:22:46.435604');
INSERT INTO taggings VALUES (598, 160, 111, 'MediaElement', '2012-12-21 09:22:46.442043', '2012-12-21 09:22:46.442043');
INSERT INTO taggings VALUES (599, 153, 112, 'MediaElement', '2012-12-21 09:23:38.190111', '2012-12-21 09:23:38.190111');
INSERT INTO taggings VALUES (600, 160, 112, 'MediaElement', '2012-12-21 09:23:38.197558', '2012-12-21 09:23:38.197558');
INSERT INTO taggings VALUES (601, 8, 112, 'MediaElement', '2012-12-21 09:23:38.203774', '2012-12-21 09:23:38.203774');
INSERT INTO taggings VALUES (602, 159, 112, 'MediaElement', '2012-12-21 09:23:38.210191', '2012-12-21 09:23:38.210191');
INSERT INTO taggings VALUES (603, 153, 113, 'MediaElement', '2012-12-21 09:24:32.071303', '2012-12-21 09:24:32.071303');
INSERT INTO taggings VALUES (604, 160, 113, 'MediaElement', '2012-12-21 09:24:32.0782', '2012-12-21 09:24:32.0782');
INSERT INTO taggings VALUES (605, 8, 113, 'MediaElement', '2012-12-21 09:24:32.084556', '2012-12-21 09:24:32.084556');
INSERT INTO taggings VALUES (606, 159, 113, 'MediaElement', '2012-12-21 09:24:32.091093', '2012-12-21 09:24:32.091093');
INSERT INTO taggings VALUES (607, 153, 114, 'MediaElement', '2012-12-21 09:25:07.755666', '2012-12-21 09:25:07.755666');
INSERT INTO taggings VALUES (608, 160, 114, 'MediaElement', '2012-12-21 09:25:07.762099', '2012-12-21 09:25:07.762099');
INSERT INTO taggings VALUES (609, 8, 114, 'MediaElement', '2012-12-21 09:25:07.768174', '2012-12-21 09:25:07.768174');
INSERT INTO taggings VALUES (610, 159, 114, 'MediaElement', '2012-12-21 09:25:07.774365', '2012-12-21 09:25:07.774365');
INSERT INTO taggings VALUES (611, 153, 115, 'MediaElement', '2012-12-21 09:25:44.277409', '2012-12-21 09:25:44.277409');
INSERT INTO taggings VALUES (612, 160, 115, 'MediaElement', '2012-12-21 09:25:44.283916', '2012-12-21 09:25:44.283916');
INSERT INTO taggings VALUES (613, 8, 115, 'MediaElement', '2012-12-21 09:25:44.289624', '2012-12-21 09:25:44.289624');
INSERT INTO taggings VALUES (614, 159, 115, 'MediaElement', '2012-12-21 09:25:44.295088', '2012-12-21 09:25:44.295088');
INSERT INTO taggings VALUES (615, 146, 116, 'MediaElement', '2012-12-21 09:29:58.980974', '2012-12-21 09:29:58.980974');
INSERT INTO taggings VALUES (616, 8, 116, 'MediaElement', '2012-12-21 09:29:58.987352', '2012-12-21 09:29:58.987352');
INSERT INTO taggings VALUES (617, 177, 116, 'MediaElement', '2012-12-21 09:29:58.99374', '2012-12-21 09:29:58.99374');
INSERT INTO taggings VALUES (618, 37, 116, 'MediaElement', '2012-12-21 09:29:58.999889', '2012-12-21 09:29:58.999889');
INSERT INTO taggings VALUES (619, 178, 116, 'MediaElement', '2012-12-21 09:29:59.006217', '2012-12-21 09:29:59.006217');
INSERT INTO taggings VALUES (620, 156, 7, 'Lesson', '2012-12-21 09:30:00.458522', '2012-12-21 09:30:00.458522');
INSERT INTO taggings VALUES (621, 202, 7, 'Lesson', '2012-12-21 09:30:00.466504', '2012-12-21 09:30:00.466504');
INSERT INTO taggings VALUES (622, 203, 7, 'Lesson', '2012-12-21 09:30:00.474305', '2012-12-21 09:30:00.474305');
INSERT INTO taggings VALUES (623, 204, 7, 'Lesson', '2012-12-21 09:30:00.48208', '2012-12-21 09:30:00.48208');
INSERT INTO taggings VALUES (624, 205, 8, 'Lesson', '2012-12-21 09:32:36.467862', '2012-12-21 09:32:36.467862');
INSERT INTO taggings VALUES (625, 206, 8, 'Lesson', '2012-12-21 09:32:36.476276', '2012-12-21 09:32:36.476276');
INSERT INTO taggings VALUES (626, 4, 8, 'Lesson', '2012-12-21 09:32:36.482119', '2012-12-21 09:32:36.482119');
INSERT INTO taggings VALUES (627, 207, 8, 'Lesson', '2012-12-21 09:32:36.490516', '2012-12-21 09:32:36.490516');
INSERT INTO taggings VALUES (628, 12, 8, 'Lesson', '2012-12-21 09:32:36.496255', '2012-12-21 09:32:36.496255');
INSERT INTO taggings VALUES (633, 202, 118, 'MediaElement', '2012-12-21 09:34:35.005239', '2012-12-21 09:34:35.005239');
INSERT INTO taggings VALUES (634, 155, 118, 'MediaElement', '2012-12-21 09:34:35.011819', '2012-12-21 09:34:35.011819');
INSERT INTO taggings VALUES (635, 209, 118, 'MediaElement', '2012-12-21 09:34:35.018674', '2012-12-21 09:34:35.018674');
INSERT INTO taggings VALUES (636, 146, 118, 'MediaElement', '2012-12-21 09:34:35.025385', '2012-12-21 09:34:35.025385');
INSERT INTO taggings VALUES (637, 211, 9, 'Lesson', '2012-12-21 09:37:04.810708', '2012-12-21 09:37:04.810708');
INSERT INTO taggings VALUES (638, 212, 9, 'Lesson', '2012-12-21 09:37:04.820901', '2012-12-21 09:37:04.820901');
INSERT INTO taggings VALUES (639, 8, 9, 'Lesson', '2012-12-21 09:37:04.827167', '2012-12-21 09:37:04.827167');
INSERT INTO taggings VALUES (640, 213, 9, 'Lesson', '2012-12-21 09:37:04.835531', '2012-12-21 09:37:04.835531');
INSERT INTO taggings VALUES (641, 214, 119, 'MediaElement', '2012-12-21 09:37:53.955351', '2012-12-21 09:37:53.955351');
INSERT INTO taggings VALUES (642, 215, 119, 'MediaElement', '2012-12-21 09:37:53.964702', '2012-12-21 09:37:53.964702');
INSERT INTO taggings VALUES (643, 210, 119, 'MediaElement', '2012-12-21 09:37:53.971391', '2012-12-21 09:37:53.971391');
INSERT INTO taggings VALUES (644, 202, 119, 'MediaElement', '2012-12-21 09:37:53.978054', '2012-12-21 09:37:53.978054');
INSERT INTO taggings VALUES (645, 216, 120, 'MediaElement', '2012-12-21 09:39:04.798839', '2012-12-21 09:39:04.798839');
INSERT INTO taggings VALUES (646, 217, 120, 'MediaElement', '2012-12-21 09:39:04.808099', '2012-12-21 09:39:04.808099');
INSERT INTO taggings VALUES (647, 218, 120, 'MediaElement', '2012-12-21 09:39:04.816961', '2012-12-21 09:39:04.816961');
INSERT INTO taggings VALUES (648, 219, 120, 'MediaElement', '2012-12-21 09:39:04.826051', '2012-12-21 09:39:04.826051');
INSERT INTO taggings VALUES (649, 8, 121, 'MediaElement', '2012-12-21 09:39:27.800114', '2012-12-21 09:39:27.800114');
INSERT INTO taggings VALUES (650, 155, 121, 'MediaElement', '2012-12-21 09:39:27.806376', '2012-12-21 09:39:27.806376');
INSERT INTO taggings VALUES (651, 209, 121, 'MediaElement', '2012-12-21 09:39:27.812443', '2012-12-21 09:39:27.812443');
INSERT INTO taggings VALUES (652, 210, 121, 'MediaElement', '2012-12-21 09:39:27.818437', '2012-12-21 09:39:27.818437');
INSERT INTO taggings VALUES (653, 220, 122, 'MediaElement', '2012-12-21 09:39:30.704789', '2012-12-21 09:39:30.704789');
INSERT INTO taggings VALUES (654, 217, 122, 'MediaElement', '2012-12-21 09:39:30.71088', '2012-12-21 09:39:30.71088');
INSERT INTO taggings VALUES (655, 218, 122, 'MediaElement', '2012-12-21 09:39:30.716699', '2012-12-21 09:39:30.716699');
INSERT INTO taggings VALUES (656, 219, 122, 'MediaElement', '2012-12-21 09:39:30.722594', '2012-12-21 09:39:30.722594');
INSERT INTO taggings VALUES (657, 216, 123, 'MediaElement', '2012-12-21 09:40:12.451365', '2012-12-21 09:40:12.451365');
INSERT INTO taggings VALUES (658, 217, 123, 'MediaElement', '2012-12-21 09:40:12.457973', '2012-12-21 09:40:12.457973');
INSERT INTO taggings VALUES (659, 218, 123, 'MediaElement', '2012-12-21 09:40:12.464203', '2012-12-21 09:40:12.464203');
INSERT INTO taggings VALUES (660, 219, 123, 'MediaElement', '2012-12-21 09:40:12.470539', '2012-12-21 09:40:12.470539');
INSERT INTO taggings VALUES (661, 216, 124, 'MediaElement', '2012-12-21 09:40:47.879859', '2012-12-21 09:40:47.879859');
INSERT INTO taggings VALUES (662, 221, 124, 'MediaElement', '2012-12-21 09:40:47.889218', '2012-12-21 09:40:47.889218');
INSERT INTO taggings VALUES (663, 212, 124, 'MediaElement', '2012-12-21 09:40:47.894998', '2012-12-21 09:40:47.894998');
INSERT INTO taggings VALUES (664, 211, 124, 'MediaElement', '2012-12-21 09:40:47.901247', '2012-12-21 09:40:47.901247');
INSERT INTO taggings VALUES (665, 216, 125, 'MediaElement', '2012-12-21 09:41:28.149496', '2012-12-21 09:41:28.149496');
INSERT INTO taggings VALUES (666, 221, 125, 'MediaElement', '2012-12-21 09:41:28.156026', '2012-12-21 09:41:28.156026');
INSERT INTO taggings VALUES (667, 211, 125, 'MediaElement', '2012-12-21 09:41:28.162418', '2012-12-21 09:41:28.162418');
INSERT INTO taggings VALUES (668, 222, 125, 'MediaElement', '2012-12-21 09:41:28.17164', '2012-12-21 09:41:28.17164');
INSERT INTO taggings VALUES (669, 208, 126, 'MediaElement', '2012-12-21 09:41:44.313911', '2012-12-21 09:41:44.313911');
INSERT INTO taggings VALUES (670, 209, 126, 'MediaElement', '2012-12-21 09:41:44.320248', '2012-12-21 09:41:44.320248');
INSERT INTO taggings VALUES (671, 8, 126, 'MediaElement', '2012-12-21 09:41:44.326675', '2012-12-21 09:41:44.326675');
INSERT INTO taggings VALUES (672, 155, 126, 'MediaElement', '2012-12-21 09:41:44.332872', '2012-12-21 09:41:44.332872');
INSERT INTO taggings VALUES (673, 216, 127, 'MediaElement', '2012-12-21 09:41:58.227827', '2012-12-21 09:41:58.227827');
INSERT INTO taggings VALUES (674, 211, 127, 'MediaElement', '2012-12-21 09:41:58.235291', '2012-12-21 09:41:58.235291');
INSERT INTO taggings VALUES (675, 222, 127, 'MediaElement', '2012-12-21 09:41:58.241798', '2012-12-21 09:41:58.241798');
INSERT INTO taggings VALUES (676, 221, 127, 'MediaElement', '2012-12-21 09:41:58.248026', '2012-12-21 09:41:58.248026');
INSERT INTO taggings VALUES (677, 216, 128, 'MediaElement', '2012-12-21 09:42:33.945229', '2012-12-21 09:42:33.945229');
INSERT INTO taggings VALUES (678, 211, 128, 'MediaElement', '2012-12-21 09:42:33.952401', '2012-12-21 09:42:33.952401');
INSERT INTO taggings VALUES (679, 222, 128, 'MediaElement', '2012-12-21 09:42:33.959012', '2012-12-21 09:42:33.959012');
INSERT INTO taggings VALUES (680, 212, 128, 'MediaElement', '2012-12-21 09:42:33.965867', '2012-12-21 09:42:33.965867');
INSERT INTO taggings VALUES (681, 216, 129, 'MediaElement', '2012-12-21 09:42:56.057691', '2012-12-21 09:42:56.057691');
INSERT INTO taggings VALUES (682, 211, 129, 'MediaElement', '2012-12-21 09:42:56.063757', '2012-12-21 09:42:56.063757');
INSERT INTO taggings VALUES (683, 222, 129, 'MediaElement', '2012-12-21 09:42:56.069875', '2012-12-21 09:42:56.069875');
INSERT INTO taggings VALUES (684, 212, 129, 'MediaElement', '2012-12-21 09:42:56.075696', '2012-12-21 09:42:56.075696');
INSERT INTO taggings VALUES (685, 216, 130, 'MediaElement', '2012-12-21 09:43:17.882173', '2012-12-21 09:43:17.882173');
INSERT INTO taggings VALUES (686, 211, 130, 'MediaElement', '2012-12-21 09:43:17.888446', '2012-12-21 09:43:17.888446');
INSERT INTO taggings VALUES (687, 222, 130, 'MediaElement', '2012-12-21 09:43:17.895003', '2012-12-21 09:43:17.895003');
INSERT INTO taggings VALUES (688, 212, 130, 'MediaElement', '2012-12-21 09:43:17.90138', '2012-12-21 09:43:17.90138');
INSERT INTO taggings VALUES (689, 216, 131, 'MediaElement', '2012-12-21 09:43:42.35454', '2012-12-21 09:43:42.35454');
INSERT INTO taggings VALUES (690, 211, 131, 'MediaElement', '2012-12-21 09:43:42.361462', '2012-12-21 09:43:42.361462');
INSERT INTO taggings VALUES (691, 223, 131, 'MediaElement', '2012-12-21 09:43:42.370743', '2012-12-21 09:43:42.370743');
INSERT INTO taggings VALUES (692, 212, 131, 'MediaElement', '2012-12-21 09:43:42.376833', '2012-12-21 09:43:42.376833');
INSERT INTO taggings VALUES (693, 216, 132, 'MediaElement', '2012-12-21 09:44:19.564705', '2012-12-21 09:44:19.564705');
INSERT INTO taggings VALUES (694, 211, 132, 'MediaElement', '2012-12-21 09:44:19.571512', '2012-12-21 09:44:19.571512');
INSERT INTO taggings VALUES (695, 224, 132, 'MediaElement', '2012-12-21 09:44:19.581252', '2012-12-21 09:44:19.581252');
INSERT INTO taggings VALUES (696, 212, 132, 'MediaElement', '2012-12-21 09:44:19.587263', '2012-12-21 09:44:19.587263');
INSERT INTO taggings VALUES (697, 216, 133, 'MediaElement', '2012-12-21 09:44:50.616176', '2012-12-21 09:44:50.616176');
INSERT INTO taggings VALUES (698, 211, 133, 'MediaElement', '2012-12-21 09:44:50.622915', '2012-12-21 09:44:50.622915');
INSERT INTO taggings VALUES (699, 224, 133, 'MediaElement', '2012-12-21 09:44:50.6293', '2012-12-21 09:44:50.6293');
INSERT INTO taggings VALUES (700, 212, 133, 'MediaElement', '2012-12-21 09:44:50.635419', '2012-12-21 09:44:50.635419');
INSERT INTO taggings VALUES (701, 216, 134, 'MediaElement', '2012-12-21 09:45:21.403356', '2012-12-21 09:45:21.403356');
INSERT INTO taggings VALUES (702, 211, 134, 'MediaElement', '2012-12-21 09:45:21.490135', '2012-12-21 09:45:21.490135');
INSERT INTO taggings VALUES (703, 224, 134, 'MediaElement', '2012-12-21 09:45:21.4967', '2012-12-21 09:45:21.4967');
INSERT INTO taggings VALUES (704, 212, 134, 'MediaElement', '2012-12-21 09:45:21.502274', '2012-12-21 09:45:21.502274');
INSERT INTO taggings VALUES (705, 216, 135, 'MediaElement', '2012-12-21 09:45:43.157021', '2012-12-21 09:45:43.157021');
INSERT INTO taggings VALUES (706, 211, 135, 'MediaElement', '2012-12-21 09:45:43.163355', '2012-12-21 09:45:43.163355');
INSERT INTO taggings VALUES (707, 224, 135, 'MediaElement', '2012-12-21 09:45:43.169753', '2012-12-21 09:45:43.169753');
INSERT INTO taggings VALUES (708, 212, 135, 'MediaElement', '2012-12-21 09:45:43.175779', '2012-12-21 09:45:43.175779');
INSERT INTO taggings VALUES (709, 8, 136, 'MediaElement', '2012-12-21 09:45:58.403433', '2012-12-21 09:45:58.403433');
INSERT INTO taggings VALUES (710, 202, 136, 'MediaElement', '2012-12-21 09:45:58.410113', '2012-12-21 09:45:58.410113');
INSERT INTO taggings VALUES (711, 146, 136, 'MediaElement', '2012-12-21 09:45:58.416242', '2012-12-21 09:45:58.416242');
INSERT INTO taggings VALUES (712, 209, 136, 'MediaElement', '2012-12-21 09:45:58.422526', '2012-12-21 09:45:58.422526');
INSERT INTO taggings VALUES (713, 216, 137, 'MediaElement', '2012-12-21 09:46:03.628107', '2012-12-21 09:46:03.628107');
INSERT INTO taggings VALUES (714, 211, 137, 'MediaElement', '2012-12-21 09:46:03.634648', '2012-12-21 09:46:03.634648');
INSERT INTO taggings VALUES (715, 224, 137, 'MediaElement', '2012-12-21 09:46:03.640852', '2012-12-21 09:46:03.640852');
INSERT INTO taggings VALUES (716, 212, 137, 'MediaElement', '2012-12-21 09:46:03.647159', '2012-12-21 09:46:03.647159');
INSERT INTO taggings VALUES (717, 216, 138, 'MediaElement', '2012-12-21 09:46:28.759495', '2012-12-21 09:46:28.759495');
INSERT INTO taggings VALUES (718, 211, 138, 'MediaElement', '2012-12-21 09:46:28.766238', '2012-12-21 09:46:28.766238');
INSERT INTO taggings VALUES (719, 224, 138, 'MediaElement', '2012-12-21 09:46:28.772628', '2012-12-21 09:46:28.772628');
INSERT INTO taggings VALUES (720, 212, 138, 'MediaElement', '2012-12-21 09:46:28.779263', '2012-12-21 09:46:28.779263');
INSERT INTO taggings VALUES (721, 216, 139, 'MediaElement', '2012-12-21 09:46:51.931224', '2012-12-21 09:46:51.931224');
INSERT INTO taggings VALUES (722, 211, 139, 'MediaElement', '2012-12-21 09:46:51.938472', '2012-12-21 09:46:51.938472');
INSERT INTO taggings VALUES (723, 224, 139, 'MediaElement', '2012-12-21 09:46:51.94529', '2012-12-21 09:46:51.94529');
INSERT INTO taggings VALUES (724, 212, 139, 'MediaElement', '2012-12-21 09:46:51.951838', '2012-12-21 09:46:51.951838');
INSERT INTO taggings VALUES (725, 225, 140, 'MediaElement', '2012-12-21 09:51:58.786862', '2012-12-21 09:51:58.786862');
INSERT INTO taggings VALUES (726, 211, 140, 'MediaElement', '2012-12-21 09:51:58.793771', '2012-12-21 09:51:58.793771');
INSERT INTO taggings VALUES (727, 212, 140, 'MediaElement', '2012-12-21 09:51:58.800062', '2012-12-21 09:51:58.800062');
INSERT INTO taggings VALUES (728, 221, 140, 'MediaElement', '2012-12-21 09:51:58.806542', '2012-12-21 09:51:58.806542');
INSERT INTO taggings VALUES (729, 225, 141, 'MediaElement', '2012-12-21 09:52:41.801893', '2012-12-21 09:52:41.801893');
INSERT INTO taggings VALUES (730, 211, 141, 'MediaElement', '2012-12-21 09:52:41.80898', '2012-12-21 09:52:41.80898');
INSERT INTO taggings VALUES (731, 221, 141, 'MediaElement', '2012-12-21 09:52:41.815512', '2012-12-21 09:52:41.815512');
INSERT INTO taggings VALUES (732, 212, 141, 'MediaElement', '2012-12-21 09:52:41.822373', '2012-12-21 09:52:41.822373');
INSERT INTO taggings VALUES (738, 226, 142, 'MediaElement', '2012-12-21 10:09:11.821337', '2012-12-21 10:09:11.821337');
INSERT INTO taggings VALUES (739, 221, 142, 'MediaElement', '2012-12-21 10:09:11.828007', '2012-12-21 10:09:11.828007');
INSERT INTO taggings VALUES (740, 212, 142, 'MediaElement', '2012-12-21 10:09:11.834348', '2012-12-21 10:09:11.834348');
INSERT INTO taggings VALUES (741, 211, 142, 'MediaElement', '2012-12-21 10:09:11.840306', '2012-12-21 10:09:11.840306');
INSERT INTO taggings VALUES (742, 226, 143, 'MediaElement', '2012-12-21 10:31:24.787083', '2012-12-21 10:31:24.787083');
INSERT INTO taggings VALUES (743, 211, 143, 'MediaElement', '2012-12-21 10:31:24.794275', '2012-12-21 10:31:24.794275');
INSERT INTO taggings VALUES (744, 224, 143, 'MediaElement', '2012-12-21 10:31:24.800866', '2012-12-21 10:31:24.800866');
INSERT INTO taggings VALUES (745, 212, 143, 'MediaElement', '2012-12-21 10:31:24.807504', '2012-12-21 10:31:24.807504');
INSERT INTO taggings VALUES (746, 225, 144, 'MediaElement', '2012-12-21 10:35:45.503658', '2012-12-21 10:35:45.503658');
INSERT INTO taggings VALUES (747, 218, 144, 'MediaElement', '2012-12-21 10:35:45.510663', '2012-12-21 10:35:45.510663');
INSERT INTO taggings VALUES (748, 221, 144, 'MediaElement', '2012-12-21 10:35:45.517407', '2012-12-21 10:35:45.517407');
INSERT INTO taggings VALUES (749, 212, 144, 'MediaElement', '2012-12-21 10:35:45.523704', '2012-12-21 10:35:45.523704');
INSERT INTO taggings VALUES (750, 225, 145, 'MediaElement', '2012-12-21 10:40:32.800619', '2012-12-21 10:40:32.800619');
INSERT INTO taggings VALUES (751, 221, 145, 'MediaElement', '2012-12-21 10:40:32.807732', '2012-12-21 10:40:32.807732');
INSERT INTO taggings VALUES (752, 212, 145, 'MediaElement', '2012-12-21 10:40:32.814683', '2012-12-21 10:40:32.814683');
INSERT INTO taggings VALUES (753, 211, 145, 'MediaElement', '2012-12-21 10:40:32.821246', '2012-12-21 10:40:32.821246');
INSERT INTO taggings VALUES (754, 225, 146, 'MediaElement', '2012-12-21 10:41:10.987064', '2012-12-21 10:41:10.987064');
INSERT INTO taggings VALUES (755, 211, 146, 'MediaElement', '2012-12-21 10:41:10.993644', '2012-12-21 10:41:10.993644');
INSERT INTO taggings VALUES (756, 221, 146, 'MediaElement', '2012-12-21 10:41:10.999843', '2012-12-21 10:41:10.999843');
INSERT INTO taggings VALUES (757, 212, 146, 'MediaElement', '2012-12-21 10:41:11.006132', '2012-12-21 10:41:11.006132');
INSERT INTO taggings VALUES (758, 212, 147, 'MediaElement', '2012-12-21 10:41:55.446788', '2012-12-21 10:41:55.446788');
INSERT INTO taggings VALUES (759, 225, 147, 'MediaElement', '2012-12-21 10:41:55.453499', '2012-12-21 10:41:55.453499');
INSERT INTO taggings VALUES (760, 221, 147, 'MediaElement', '2012-12-21 10:41:55.45971', '2012-12-21 10:41:55.45971');
INSERT INTO taggings VALUES (761, 211, 147, 'MediaElement', '2012-12-21 10:41:55.466012', '2012-12-21 10:41:55.466012');
INSERT INTO taggings VALUES (762, 63, 11, 'Lesson', '2012-12-21 10:55:07.529562', '2012-12-21 10:55:07.529562');
INSERT INTO taggings VALUES (763, 227, 11, 'Lesson', '2012-12-21 10:55:07.538278', '2012-12-21 10:55:07.538278');
INSERT INTO taggings VALUES (764, 5, 11, 'Lesson', '2012-12-21 10:55:07.544208', '2012-12-21 10:55:07.544208');
INSERT INTO taggings VALUES (765, 61, 11, 'Lesson', '2012-12-21 10:55:07.550135', '2012-12-21 10:55:07.550135');
INSERT INTO taggings VALUES (766, 228, 148, 'MediaElement', '2012-12-21 10:59:59.987583', '2012-12-21 10:59:59.987583');
INSERT INTO taggings VALUES (767, 218, 148, 'MediaElement', '2012-12-21 10:59:59.994484', '2012-12-21 10:59:59.994484');
INSERT INTO taggings VALUES (768, 212, 148, 'MediaElement', '2012-12-21 11:00:00.373261', '2012-12-21 11:00:00.373261');
INSERT INTO taggings VALUES (769, 224, 148, 'MediaElement', '2012-12-21 11:00:00.379202', '2012-12-21 11:00:00.379202');
INSERT INTO taggings VALUES (770, 228, 149, 'MediaElement', '2012-12-21 11:00:21.017623', '2012-12-21 11:00:21.017623');
INSERT INTO taggings VALUES (771, 218, 149, 'MediaElement', '2012-12-21 11:00:21.023915', '2012-12-21 11:00:21.023915');
INSERT INTO taggings VALUES (772, 212, 149, 'MediaElement', '2012-12-21 11:00:21.030431', '2012-12-21 11:00:21.030431');
INSERT INTO taggings VALUES (773, 224, 149, 'MediaElement', '2012-12-21 11:00:21.036567', '2012-12-21 11:00:21.036567');
INSERT INTO taggings VALUES (774, 228, 150, 'MediaElement', '2012-12-21 11:00:38.264203', '2012-12-21 11:00:38.264203');
INSERT INTO taggings VALUES (775, 218, 150, 'MediaElement', '2012-12-21 11:00:38.27127', '2012-12-21 11:00:38.27127');
INSERT INTO taggings VALUES (776, 212, 150, 'MediaElement', '2012-12-21 11:00:38.278059', '2012-12-21 11:00:38.278059');
INSERT INTO taggings VALUES (777, 224, 150, 'MediaElement', '2012-12-21 11:00:38.284777', '2012-12-21 11:00:38.284777');
INSERT INTO taggings VALUES (778, 228, 151, 'MediaElement', '2012-12-21 11:00:51.244973', '2012-12-21 11:00:51.244973');
INSERT INTO taggings VALUES (779, 218, 151, 'MediaElement', '2012-12-21 11:00:51.251301', '2012-12-21 11:00:51.251301');
INSERT INTO taggings VALUES (780, 212, 151, 'MediaElement', '2012-12-21 11:00:51.25764', '2012-12-21 11:00:51.25764');
INSERT INTO taggings VALUES (781, 224, 151, 'MediaElement', '2012-12-21 11:00:51.263631', '2012-12-21 11:00:51.263631');
INSERT INTO taggings VALUES (782, 228, 152, 'MediaElement', '2012-12-21 11:01:04.991222', '2012-12-21 11:01:04.991222');
INSERT INTO taggings VALUES (783, 218, 152, 'MediaElement', '2012-12-21 11:01:04.997737', '2012-12-21 11:01:04.997737');
INSERT INTO taggings VALUES (784, 212, 152, 'MediaElement', '2012-12-21 11:01:05.003879', '2012-12-21 11:01:05.003879');
INSERT INTO taggings VALUES (785, 224, 152, 'MediaElement', '2012-12-21 11:01:05.010205', '2012-12-21 11:01:05.010205');
INSERT INTO taggings VALUES (786, 228, 153, 'MediaElement', '2012-12-21 11:03:48.283417', '2012-12-21 11:03:48.283417');
INSERT INTO taggings VALUES (787, 218, 153, 'MediaElement', '2012-12-21 11:03:48.289951', '2012-12-21 11:03:48.289951');
INSERT INTO taggings VALUES (788, 212, 153, 'MediaElement', '2012-12-21 11:03:48.295967', '2012-12-21 11:03:48.295967');
INSERT INTO taggings VALUES (789, 224, 153, 'MediaElement', '2012-12-21 11:03:48.302126', '2012-12-21 11:03:48.302126');
INSERT INTO taggings VALUES (790, 228, 154, 'MediaElement', '2012-12-21 11:08:20.508001', '2012-12-21 11:08:20.508001');
INSERT INTO taggings VALUES (791, 212, 154, 'MediaElement', '2012-12-21 11:08:20.514803', '2012-12-21 11:08:20.514803');
INSERT INTO taggings VALUES (792, 211, 154, 'MediaElement', '2012-12-21 11:08:20.520973', '2012-12-21 11:08:20.520973');
INSERT INTO taggings VALUES (793, 8, 154, 'MediaElement', '2012-12-21 11:08:20.527239', '2012-12-21 11:08:20.527239');
INSERT INTO taggings VALUES (794, 228, 155, 'MediaElement', '2012-12-21 11:08:52.071999', '2012-12-21 11:08:52.071999');
INSERT INTO taggings VALUES (795, 212, 155, 'MediaElement', '2012-12-21 11:08:52.078854', '2012-12-21 11:08:52.078854');
INSERT INTO taggings VALUES (796, 211, 155, 'MediaElement', '2012-12-21 11:08:52.085609', '2012-12-21 11:08:52.085609');
INSERT INTO taggings VALUES (797, 8, 155, 'MediaElement', '2012-12-21 11:08:52.091668', '2012-12-21 11:08:52.091668');
INSERT INTO taggings VALUES (798, 228, 156, 'MediaElement', '2012-12-21 11:09:10.593493', '2012-12-21 11:09:10.593493');
INSERT INTO taggings VALUES (799, 212, 156, 'MediaElement', '2012-12-21 11:09:10.59995', '2012-12-21 11:09:10.59995');
INSERT INTO taggings VALUES (800, 211, 156, 'MediaElement', '2012-12-21 11:09:10.60627', '2012-12-21 11:09:10.60627');
INSERT INTO taggings VALUES (801, 8, 156, 'MediaElement', '2012-12-21 11:09:10.612665', '2012-12-21 11:09:10.612665');
INSERT INTO taggings VALUES (802, 228, 157, 'MediaElement', '2012-12-21 11:09:30.743868', '2012-12-21 11:09:30.743868');
INSERT INTO taggings VALUES (803, 212, 157, 'MediaElement', '2012-12-21 11:09:30.750006', '2012-12-21 11:09:30.750006');
INSERT INTO taggings VALUES (804, 211, 157, 'MediaElement', '2012-12-21 11:09:30.755816', '2012-12-21 11:09:30.755816');
INSERT INTO taggings VALUES (805, 8, 157, 'MediaElement', '2012-12-21 11:09:30.761843', '2012-12-21 11:09:30.761843');
INSERT INTO taggings VALUES (806, 228, 158, 'MediaElement', '2012-12-21 11:09:57.977963', '2012-12-21 11:09:57.977963');
INSERT INTO taggings VALUES (807, 212, 158, 'MediaElement', '2012-12-21 11:09:57.984256', '2012-12-21 11:09:57.984256');
INSERT INTO taggings VALUES (808, 211, 158, 'MediaElement', '2012-12-21 11:09:57.990581', '2012-12-21 11:09:57.990581');
INSERT INTO taggings VALUES (809, 8, 158, 'MediaElement', '2012-12-21 11:09:57.99666', '2012-12-21 11:09:57.99666');
INSERT INTO taggings VALUES (810, 228, 159, 'MediaElement', '2012-12-21 11:12:48.972116', '2012-12-21 11:12:48.972116');
INSERT INTO taggings VALUES (811, 212, 159, 'MediaElement', '2012-12-21 11:12:48.978809', '2012-12-21 11:12:48.978809');
INSERT INTO taggings VALUES (812, 211, 159, 'MediaElement', '2012-12-21 11:12:48.985031', '2012-12-21 11:12:48.985031');
INSERT INTO taggings VALUES (813, 8, 159, 'MediaElement', '2012-12-21 11:12:48.9913', '2012-12-21 11:12:48.9913');
INSERT INTO taggings VALUES (814, 228, 160, 'MediaElement', '2012-12-21 11:13:13.425499', '2012-12-21 11:13:13.425499');
INSERT INTO taggings VALUES (815, 212, 160, 'MediaElement', '2012-12-21 11:13:13.432121', '2012-12-21 11:13:13.432121');
INSERT INTO taggings VALUES (816, 211, 160, 'MediaElement', '2012-12-21 11:13:13.438495', '2012-12-21 11:13:13.438495');
INSERT INTO taggings VALUES (817, 8, 160, 'MediaElement', '2012-12-21 11:13:13.444502', '2012-12-21 11:13:13.444502');
INSERT INTO taggings VALUES (818, 228, 161, 'MediaElement', '2012-12-21 11:13:37.226417', '2012-12-21 11:13:37.226417');
INSERT INTO taggings VALUES (819, 212, 161, 'MediaElement', '2012-12-21 11:13:37.232623', '2012-12-21 11:13:37.232623');
INSERT INTO taggings VALUES (820, 211, 161, 'MediaElement', '2012-12-21 11:13:37.238759', '2012-12-21 11:13:37.238759');
INSERT INTO taggings VALUES (821, 8, 161, 'MediaElement', '2012-12-21 11:13:37.244838', '2012-12-21 11:13:37.244838');
INSERT INTO taggings VALUES (822, 228, 162, 'MediaElement', '2012-12-21 11:14:19.50185', '2012-12-21 11:14:19.50185');
INSERT INTO taggings VALUES (823, 212, 162, 'MediaElement', '2012-12-21 11:14:19.50818', '2012-12-21 11:14:19.50818');
INSERT INTO taggings VALUES (824, 211, 162, 'MediaElement', '2012-12-21 11:14:19.514569', '2012-12-21 11:14:19.514569');
INSERT INTO taggings VALUES (825, 8, 162, 'MediaElement', '2012-12-21 11:14:19.520849', '2012-12-21 11:14:19.520849');
INSERT INTO taggings VALUES (826, 228, 163, 'MediaElement', '2012-12-21 11:15:00.627914', '2012-12-21 11:15:00.627914');
INSERT INTO taggings VALUES (827, 212, 163, 'MediaElement', '2012-12-21 11:15:00.634634', '2012-12-21 11:15:00.634634');
INSERT INTO taggings VALUES (828, 211, 163, 'MediaElement', '2012-12-21 11:15:00.640931', '2012-12-21 11:15:00.640931');
INSERT INTO taggings VALUES (829, 8, 163, 'MediaElement', '2012-12-21 11:15:00.647084', '2012-12-21 11:15:00.647084');
INSERT INTO taggings VALUES (830, 228, 164, 'MediaElement', '2012-12-21 11:15:25.836364', '2012-12-21 11:15:25.836364');
INSERT INTO taggings VALUES (831, 212, 164, 'MediaElement', '2012-12-21 11:15:25.842653', '2012-12-21 11:15:25.842653');
INSERT INTO taggings VALUES (832, 211, 164, 'MediaElement', '2012-12-21 11:15:25.848728', '2012-12-21 11:15:25.848728');
INSERT INTO taggings VALUES (833, 8, 164, 'MediaElement', '2012-12-21 11:15:25.854786', '2012-12-21 11:15:25.854786');
INSERT INTO taggings VALUES (834, 228, 165, 'MediaElement', '2012-12-21 11:15:45.671962', '2012-12-21 11:15:45.671962');
INSERT INTO taggings VALUES (835, 212, 165, 'MediaElement', '2012-12-21 11:15:45.678448', '2012-12-21 11:15:45.678448');
INSERT INTO taggings VALUES (836, 211, 165, 'MediaElement', '2012-12-21 11:15:45.684449', '2012-12-21 11:15:45.684449');
INSERT INTO taggings VALUES (837, 8, 165, 'MediaElement', '2012-12-21 11:15:45.690922', '2012-12-21 11:15:45.690922');
INSERT INTO taggings VALUES (838, 228, 166, 'MediaElement', '2012-12-21 11:17:00.176144', '2012-12-21 11:17:00.176144');
INSERT INTO taggings VALUES (839, 212, 166, 'MediaElement', '2012-12-21 11:17:00.183001', '2012-12-21 11:17:00.183001');
INSERT INTO taggings VALUES (840, 211, 166, 'MediaElement', '2012-12-21 11:17:00.189705', '2012-12-21 11:17:00.189705');
INSERT INTO taggings VALUES (841, 8, 166, 'MediaElement', '2012-12-21 11:17:00.19613', '2012-12-21 11:17:00.19613');
INSERT INTO taggings VALUES (842, 229, 12, 'Lesson', '2012-12-21 11:18:50.314323', '2012-12-21 11:18:50.314323');
INSERT INTO taggings VALUES (843, 211, 12, 'Lesson', '2012-12-21 11:18:50.320178', '2012-12-21 11:18:50.320178');
INSERT INTO taggings VALUES (844, 224, 12, 'Lesson', '2012-12-21 11:18:50.326144', '2012-12-21 11:18:50.326144');
INSERT INTO taggings VALUES (845, 212, 12, 'Lesson', '2012-12-21 11:18:50.332211', '2012-12-21 11:18:50.332211');
INSERT INTO taggings VALUES (846, 63, 167, 'MediaElement', '2012-12-21 11:22:20.365132', '2012-12-21 11:22:20.365132');
INSERT INTO taggings VALUES (847, 227, 167, 'MediaElement', '2012-12-21 11:22:20.371661', '2012-12-21 11:22:20.371661');
INSERT INTO taggings VALUES (848, 5, 167, 'MediaElement', '2012-12-21 11:22:20.378809', '2012-12-21 11:22:20.378809');
INSERT INTO taggings VALUES (849, 230, 167, 'MediaElement', '2012-12-21 11:22:20.388808', '2012-12-21 11:22:20.388808');
INSERT INTO taggings VALUES (850, 228, 168, 'MediaElement', '2012-12-21 11:27:16.272591', '2012-12-21 11:27:16.272591');
INSERT INTO taggings VALUES (851, 211, 168, 'MediaElement', '2012-12-21 11:27:16.279619', '2012-12-21 11:27:16.279619');
INSERT INTO taggings VALUES (852, 231, 168, 'MediaElement', '2012-12-21 11:27:16.289299', '2012-12-21 11:27:16.289299');
INSERT INTO taggings VALUES (853, 232, 168, 'MediaElement', '2012-12-21 11:27:16.298068', '2012-12-21 11:27:16.298068');
INSERT INTO taggings VALUES (854, 228, 169, 'MediaElement', '2012-12-21 11:27:33.056961', '2012-12-21 11:27:33.056961');
INSERT INTO taggings VALUES (855, 211, 169, 'MediaElement', '2012-12-21 11:27:33.063501', '2012-12-21 11:27:33.063501');
INSERT INTO taggings VALUES (856, 231, 169, 'MediaElement', '2012-12-21 11:27:33.070055', '2012-12-21 11:27:33.070055');
INSERT INTO taggings VALUES (857, 232, 169, 'MediaElement', '2012-12-21 11:27:33.076144', '2012-12-21 11:27:33.076144');
INSERT INTO taggings VALUES (858, 228, 170, 'MediaElement', '2012-12-21 11:27:49.974285', '2012-12-21 11:27:49.974285');
INSERT INTO taggings VALUES (859, 211, 170, 'MediaElement', '2012-12-21 11:27:49.980491', '2012-12-21 11:27:49.980491');
INSERT INTO taggings VALUES (860, 231, 170, 'MediaElement', '2012-12-21 11:27:49.986499', '2012-12-21 11:27:49.986499');
INSERT INTO taggings VALUES (861, 232, 170, 'MediaElement', '2012-12-21 11:27:49.992424', '2012-12-21 11:27:49.992424');
INSERT INTO taggings VALUES (862, 228, 171, 'MediaElement', '2012-12-21 11:28:07.312973', '2012-12-21 11:28:07.312973');
INSERT INTO taggings VALUES (863, 211, 171, 'MediaElement', '2012-12-21 11:28:07.319121', '2012-12-21 11:28:07.319121');
INSERT INTO taggings VALUES (864, 231, 171, 'MediaElement', '2012-12-21 11:28:07.325162', '2012-12-21 11:28:07.325162');
INSERT INTO taggings VALUES (865, 232, 171, 'MediaElement', '2012-12-21 11:28:07.331645', '2012-12-21 11:28:07.331645');
INSERT INTO taggings VALUES (866, 228, 172, 'MediaElement', '2012-12-21 11:28:24.944645', '2012-12-21 11:28:24.944645');
INSERT INTO taggings VALUES (867, 211, 172, 'MediaElement', '2012-12-21 11:28:24.951279', '2012-12-21 11:28:24.951279');
INSERT INTO taggings VALUES (868, 231, 172, 'MediaElement', '2012-12-21 11:28:24.957539', '2012-12-21 11:28:24.957539');
INSERT INTO taggings VALUES (869, 232, 172, 'MediaElement', '2012-12-21 11:28:24.963553', '2012-12-21 11:28:24.963553');
INSERT INTO taggings VALUES (870, 228, 173, 'MediaElement', '2012-12-21 11:28:42.338026', '2012-12-21 11:28:42.338026');
INSERT INTO taggings VALUES (871, 211, 173, 'MediaElement', '2012-12-21 11:28:42.344213', '2012-12-21 11:28:42.344213');
INSERT INTO taggings VALUES (872, 231, 173, 'MediaElement', '2012-12-21 11:28:42.350466', '2012-12-21 11:28:42.350466');
INSERT INTO taggings VALUES (873, 232, 173, 'MediaElement', '2012-12-21 11:28:42.356496', '2012-12-21 11:28:42.356496');
INSERT INTO taggings VALUES (874, 228, 174, 'MediaElement', '2012-12-21 11:36:39.288387', '2012-12-21 11:36:39.288387');
INSERT INTO taggings VALUES (875, 233, 174, 'MediaElement', '2012-12-21 11:36:39.298715', '2012-12-21 11:36:39.298715');
INSERT INTO taggings VALUES (876, 211, 174, 'MediaElement', '2012-12-21 11:36:39.305581', '2012-12-21 11:36:39.305581');
INSERT INTO taggings VALUES (877, 212, 174, 'MediaElement', '2012-12-21 11:36:39.311944', '2012-12-21 11:36:39.311944');
INSERT INTO taggings VALUES (878, 228, 175, 'MediaElement', '2012-12-21 11:36:57.478799', '2012-12-21 11:36:57.478799');
INSERT INTO taggings VALUES (879, 233, 175, 'MediaElement', '2012-12-21 11:36:57.485204', '2012-12-21 11:36:57.485204');
INSERT INTO taggings VALUES (880, 211, 175, 'MediaElement', '2012-12-21 11:36:57.491299', '2012-12-21 11:36:57.491299');
INSERT INTO taggings VALUES (881, 212, 175, 'MediaElement', '2012-12-21 11:36:57.497522', '2012-12-21 11:36:57.497522');
INSERT INTO taggings VALUES (882, 63, 176, 'MediaElement', '2012-12-21 11:37:05.683992', '2012-12-21 11:37:05.683992');
INSERT INTO taggings VALUES (883, 234, 176, 'MediaElement', '2012-12-21 11:37:05.693476', '2012-12-21 11:37:05.693476');
INSERT INTO taggings VALUES (884, 5, 176, 'MediaElement', '2012-12-21 11:37:05.699564', '2012-12-21 11:37:05.699564');
INSERT INTO taggings VALUES (885, 120, 176, 'MediaElement', '2012-12-21 11:37:05.705928', '2012-12-21 11:37:05.705928');
INSERT INTO taggings VALUES (886, 228, 177, 'MediaElement', '2012-12-21 11:37:16.100662', '2012-12-21 11:37:16.100662');
INSERT INTO taggings VALUES (887, 235, 177, 'MediaElement', '2012-12-21 11:37:16.109644', '2012-12-21 11:37:16.109644');
INSERT INTO taggings VALUES (888, 211, 177, 'MediaElement', '2012-12-21 11:37:16.115359', '2012-12-21 11:37:16.115359');
INSERT INTO taggings VALUES (889, 212, 177, 'MediaElement', '2012-12-21 11:37:16.121306', '2012-12-21 11:37:16.121306');
INSERT INTO taggings VALUES (890, 228, 178, 'MediaElement', '2012-12-21 11:37:36.827034', '2012-12-21 11:37:36.827034');
INSERT INTO taggings VALUES (891, 233, 178, 'MediaElement', '2012-12-21 11:37:36.834417', '2012-12-21 11:37:36.834417');
INSERT INTO taggings VALUES (892, 211, 178, 'MediaElement', '2012-12-21 11:37:36.841016', '2012-12-21 11:37:36.841016');
INSERT INTO taggings VALUES (893, 212, 178, 'MediaElement', '2012-12-21 11:37:36.899362', '2012-12-21 11:37:36.899362');
INSERT INTO taggings VALUES (894, 236, 90, 'MediaElement', '2012-12-21 14:47:43.509535', '2012-12-21 14:47:43.509535');
INSERT INTO taggings VALUES (895, 237, 90, 'MediaElement', '2012-12-21 14:47:43.520191', '2012-12-21 14:47:43.520191');
INSERT INTO taggings VALUES (896, 238, 90, 'MediaElement', '2012-12-21 14:47:43.529725', '2012-12-21 14:47:43.529725');
INSERT INTO taggings VALUES (897, 16, 90, 'MediaElement', '2012-12-21 14:47:43.535732', '2012-12-21 14:47:43.535732');
INSERT INTO taggings VALUES (902, 239, 180, 'MediaElement', '2012-12-21 15:50:33.646592', '2012-12-21 15:50:33.646592');
INSERT INTO taggings VALUES (903, 240, 180, 'MediaElement', '2012-12-21 15:50:33.653962', '2012-12-21 15:50:33.653962');
INSERT INTO taggings VALUES (904, 242, 180, 'MediaElement', '2012-12-21 15:50:33.659811', '2012-12-21 15:50:33.659811');
INSERT INTO taggings VALUES (905, 243, 180, 'MediaElement', '2012-12-21 15:50:33.67035', '2012-12-21 15:50:33.67035');
INSERT INTO taggings VALUES (906, 244, 181, 'MediaElement', '2012-12-21 18:47:40.844412', '2012-12-21 18:47:40.844412');
INSERT INTO taggings VALUES (907, 245, 181, 'MediaElement', '2012-12-21 18:47:40.854092', '2012-12-21 18:47:40.854092');
INSERT INTO taggings VALUES (908, 246, 181, 'MediaElement', '2012-12-21 18:47:40.862329', '2012-12-21 18:47:40.862329');
INSERT INTO taggings VALUES (909, 247, 181, 'MediaElement', '2012-12-21 18:47:40.870375', '2012-12-21 18:47:40.870375');
INSERT INTO taggings VALUES (914, 250, 182, 'MediaElement', '2012-12-23 16:25:35.805725', '2012-12-23 16:25:35.805725');
INSERT INTO taggings VALUES (915, 251, 182, 'MediaElement', '2012-12-23 16:25:35.814553', '2012-12-23 16:25:35.814553');
INSERT INTO taggings VALUES (916, 208, 182, 'MediaElement', '2012-12-23 16:25:35.820477', '2012-12-23 16:25:35.820477');
INSERT INTO taggings VALUES (917, 252, 182, 'MediaElement', '2012-12-23 16:25:35.829229', '2012-12-23 16:25:35.829229');
INSERT INTO taggings VALUES (918, 250, 183, 'MediaElement', '2012-12-23 16:27:02.270771', '2012-12-23 16:27:02.270771');
INSERT INTO taggings VALUES (919, 253, 183, 'MediaElement', '2012-12-23 16:27:02.27991', '2012-12-23 16:27:02.27991');
INSERT INTO taggings VALUES (920, 208, 183, 'MediaElement', '2012-12-23 16:27:02.286155', '2012-12-23 16:27:02.286155');
INSERT INTO taggings VALUES (921, 141, 183, 'MediaElement', '2012-12-23 16:27:02.292054', '2012-12-23 16:27:02.292054');
INSERT INTO taggings VALUES (930, 258, 14, 'Lesson', '2013-01-07 09:15:15.669178', '2013-01-07 09:15:15.669178');
INSERT INTO taggings VALUES (931, 259, 14, 'Lesson', '2013-01-07 09:15:15.677718', '2013-01-07 09:15:15.677718');
INSERT INTO taggings VALUES (932, 260, 14, 'Lesson', '2013-01-07 09:15:15.686123', '2013-01-07 09:15:15.686123');
INSERT INTO taggings VALUES (933, 261, 14, 'Lesson', '2013-01-07 09:15:15.694564', '2013-01-07 09:15:15.694564');
INSERT INTO taggings VALUES (934, 258, 15, 'Lesson', '2013-01-07 09:18:27.808428', '2013-01-07 09:18:27.808428');
INSERT INTO taggings VALUES (935, 259, 15, 'Lesson', '2013-01-07 09:18:27.814261', '2013-01-07 09:18:27.814261');
INSERT INTO taggings VALUES (936, 260, 15, 'Lesson', '2013-01-07 09:18:27.819968', '2013-01-07 09:18:27.819968');
INSERT INTO taggings VALUES (937, 261, 15, 'Lesson', '2013-01-07 09:18:27.825804', '2013-01-07 09:18:27.825804');
INSERT INTO taggings VALUES (938, 258, 16, 'Lesson', '2013-01-07 09:19:13.614487', '2013-01-07 09:19:13.614487');
INSERT INTO taggings VALUES (939, 259, 16, 'Lesson', '2013-01-07 09:19:13.620377', '2013-01-07 09:19:13.620377');
INSERT INTO taggings VALUES (940, 260, 16, 'Lesson', '2013-01-07 09:19:13.626415', '2013-01-07 09:19:13.626415');
INSERT INTO taggings VALUES (941, 261, 16, 'Lesson', '2013-01-07 09:19:13.632377', '2013-01-07 09:19:13.632377');
INSERT INTO taggings VALUES (942, 258, 17, 'Lesson', '2013-01-07 09:19:53.944191', '2013-01-07 09:19:53.944191');
INSERT INTO taggings VALUES (943, 259, 17, 'Lesson', '2013-01-07 09:19:53.950367', '2013-01-07 09:19:53.950367');
INSERT INTO taggings VALUES (944, 260, 17, 'Lesson', '2013-01-07 09:19:53.956254', '2013-01-07 09:19:53.956254');
INSERT INTO taggings VALUES (945, 261, 17, 'Lesson', '2013-01-07 09:19:53.962388', '2013-01-07 09:19:53.962388');
INSERT INTO taggings VALUES (946, 258, 186, 'MediaElement', '2013-01-07 09:46:06.136897', '2013-01-07 09:46:06.136897');
INSERT INTO taggings VALUES (947, 259, 186, 'MediaElement', '2013-01-07 09:46:06.143365', '2013-01-07 09:46:06.143365');
INSERT INTO taggings VALUES (948, 260, 186, 'MediaElement', '2013-01-07 09:46:06.14948', '2013-01-07 09:46:06.14948');
INSERT INTO taggings VALUES (949, 262, 186, 'MediaElement', '2013-01-07 09:46:06.158371', '2013-01-07 09:46:06.158371');
INSERT INTO taggings VALUES (954, 267, 19, 'Lesson', '2013-01-07 09:57:04.152363', '2013-01-07 09:57:04.152363');
INSERT INTO taggings VALUES (955, 268, 19, 'Lesson', '2013-01-07 09:57:04.160501', '2013-01-07 09:57:04.160501');
INSERT INTO taggings VALUES (956, 269, 19, 'Lesson', '2013-01-07 09:57:04.168499', '2013-01-07 09:57:04.168499');
INSERT INTO taggings VALUES (957, 270, 19, 'Lesson', '2013-01-07 09:57:04.176553', '2013-01-07 09:57:04.176553');
INSERT INTO taggings VALUES (958, 108, 187, 'MediaElement', '2013-01-07 10:33:22.0395', '2013-01-07 10:33:22.0395');
INSERT INTO taggings VALUES (959, 271, 187, 'MediaElement', '2013-01-07 10:33:22.049087', '2013-01-07 10:33:22.049087');
INSERT INTO taggings VALUES (960, 272, 187, 'MediaElement', '2013-01-07 10:33:22.057994', '2013-01-07 10:33:22.057994');
INSERT INTO taggings VALUES (961, 237, 187, 'MediaElement', '2013-01-07 10:33:22.063858', '2013-01-07 10:33:22.063858');
INSERT INTO taggings VALUES (967, 276, 20, 'Lesson', '2013-01-08 11:29:36.05161', '2013-01-08 11:29:36.05161');
INSERT INTO taggings VALUES (968, 277, 20, 'Lesson', '2013-01-08 11:29:36.06017', '2013-01-08 11:29:36.06017');
INSERT INTO taggings VALUES (969, 278, 20, 'Lesson', '2013-01-08 11:29:36.068632', '2013-01-08 11:29:36.068632');
INSERT INTO taggings VALUES (970, 279, 20, 'Lesson', '2013-01-08 11:29:36.077378', '2013-01-08 11:29:36.077378');
INSERT INTO taggings VALUES (971, 66, 189, 'MediaElement', '2013-01-09 09:25:05.639784', '2013-01-09 09:25:05.639784');
INSERT INTO taggings VALUES (972, 280, 189, 'MediaElement', '2013-01-09 09:25:05.651857', '2013-01-09 09:25:05.651857');
INSERT INTO taggings VALUES (973, 281, 189, 'MediaElement', '2013-01-09 09:25:05.660966', '2013-01-09 09:25:05.660966');
INSERT INTO taggings VALUES (974, 282, 189, 'MediaElement', '2013-01-09 09:25:05.669835', '2013-01-09 09:25:05.669835');
INSERT INTO taggings VALUES (975, 283, 21, 'Lesson', '2013-01-09 09:57:44.957436', '2013-01-09 09:57:44.957436');
INSERT INTO taggings VALUES (976, 284, 21, 'Lesson', '2013-01-09 09:57:44.966478', '2013-01-09 09:57:44.966478');
INSERT INTO taggings VALUES (977, 285, 21, 'Lesson', '2013-01-09 09:57:44.975551', '2013-01-09 09:57:44.975551');
INSERT INTO taggings VALUES (978, 286, 21, 'Lesson', '2013-01-09 09:57:45.033919', '2013-01-09 09:57:45.033919');
INSERT INTO taggings VALUES (979, 287, 190, 'MediaElement', '2013-01-09 10:21:46.846605', '2013-01-09 10:21:46.846605');
INSERT INTO taggings VALUES (980, 288, 190, 'MediaElement', '2013-01-09 10:21:46.856177', '2013-01-09 10:21:46.856177');
INSERT INTO taggings VALUES (981, 289, 190, 'MediaElement', '2013-01-09 10:21:46.865589', '2013-01-09 10:21:46.865589');
INSERT INTO taggings VALUES (982, 290, 190, 'MediaElement', '2013-01-09 10:21:46.874654', '2013-01-09 10:21:46.874654');
INSERT INTO taggings VALUES (983, 291, 191, 'MediaElement', '2013-01-09 10:45:21.874705', '2013-01-09 10:45:21.874705');
INSERT INTO taggings VALUES (984, 292, 191, 'MediaElement', '2013-01-09 10:45:21.884294', '2013-01-09 10:45:21.884294');
INSERT INTO taggings VALUES (985, 293, 191, 'MediaElement', '2013-01-09 10:45:21.893745', '2013-01-09 10:45:21.893745');
INSERT INTO taggings VALUES (986, 294, 191, 'MediaElement', '2013-01-09 10:45:21.902907', '2013-01-09 10:45:21.902907');
INSERT INTO taggings VALUES (987, 295, 192, 'MediaElement', '2013-01-09 10:46:47.939024', '2013-01-09 10:46:47.939024');
INSERT INTO taggings VALUES (988, 296, 192, 'MediaElement', '2013-01-09 10:46:47.948398', '2013-01-09 10:46:47.948398');
INSERT INTO taggings VALUES (989, 297, 192, 'MediaElement', '2013-01-09 10:46:47.957554', '2013-01-09 10:46:47.957554');
INSERT INTO taggings VALUES (990, 298, 192, 'MediaElement', '2013-01-09 10:46:47.966406', '2013-01-09 10:46:47.966406');
INSERT INTO taggings VALUES (991, 8, 22, 'Lesson', '2013-01-09 11:20:37.826624', '2013-01-09 11:20:37.826624');
INSERT INTO taggings VALUES (992, 17, 22, 'Lesson', '2013-01-09 11:20:37.832624', '2013-01-09 11:20:37.832624');
INSERT INTO taggings VALUES (993, 44, 22, 'Lesson', '2013-01-09 11:20:37.85419', '2013-01-09 11:20:37.85419');
INSERT INTO taggings VALUES (994, 134, 22, 'Lesson', '2013-01-09 11:20:37.860253', '2013-01-09 11:20:37.860253');
INSERT INTO taggings VALUES (995, 138, 22, 'Lesson', '2013-01-09 11:20:37.866213', '2013-01-09 11:20:37.866213');
INSERT INTO taggings VALUES (996, 299, 23, 'Lesson', '2013-01-09 13:28:41.45468', '2013-01-09 13:28:41.45468');
INSERT INTO taggings VALUES (997, 300, 23, 'Lesson', '2013-01-09 13:28:41.464958', '2013-01-09 13:28:41.464958');
INSERT INTO taggings VALUES (998, 37, 23, 'Lesson', '2013-01-09 13:28:41.471069', '2013-01-09 13:28:41.471069');
INSERT INTO taggings VALUES (999, 137, 23, 'Lesson', '2013-01-09 13:28:41.477344', '2013-01-09 13:28:41.477344');


--
-- Data for Name: users_subjects; Type: TABLE DATA; Schema: public; Owner: desy
--

INSERT INTO users_subjects VALUES (1, 1, 1, '2012-12-20 10:31:31.810094', '2012-12-20 10:31:31.810094');
INSERT INTO users_subjects VALUES (2, 1, 2, '2012-12-20 10:31:31.816026', '2012-12-20 10:31:31.816026');
INSERT INTO users_subjects VALUES (3, 1, 3, '2012-12-20 10:31:31.820367', '2012-12-20 10:31:31.820367');
INSERT INTO users_subjects VALUES (4, 1, 4, '2012-12-20 10:31:31.824725', '2012-12-20 10:31:31.824725');
INSERT INTO users_subjects VALUES (5, 1, 5, '2012-12-20 10:31:31.829199', '2012-12-20 10:31:31.829199');
INSERT INTO users_subjects VALUES (6, 1, 6, '2012-12-20 10:31:31.833508', '2012-12-20 10:31:31.833508');
INSERT INTO users_subjects VALUES (7, 1, 7, '2012-12-20 10:31:31.837853', '2012-12-20 10:31:31.837853');
INSERT INTO users_subjects VALUES (8, 1, 8, '2012-12-20 10:31:31.842059', '2012-12-20 10:31:31.842059');
INSERT INTO users_subjects VALUES (9, 1, 9, '2012-12-20 10:31:31.846278', '2012-12-20 10:31:31.846278');
INSERT INTO users_subjects VALUES (10, 1, 10, '2012-12-20 10:31:31.850535', '2012-12-20 10:31:31.850535');
INSERT INTO users_subjects VALUES (11, 1, 11, '2012-12-20 10:31:31.854766', '2012-12-20 10:31:31.854766');
INSERT INTO users_subjects VALUES (12, 2, 1, '2012-12-20 10:31:31.96858', '2012-12-20 10:31:31.96858');
INSERT INTO users_subjects VALUES (13, 2, 2, '2012-12-20 10:31:31.973008', '2012-12-20 10:31:31.973008');
INSERT INTO users_subjects VALUES (14, 3, 2, '2012-12-20 10:31:31.990827', '2012-12-20 10:31:31.990827');
INSERT INTO users_subjects VALUES (15, 3, 8, '2012-12-20 10:31:31.995046', '2012-12-20 10:31:31.995046');
INSERT INTO users_subjects VALUES (16, 3, 11, '2012-12-20 10:31:31.999299', '2012-12-20 10:31:31.999299');
INSERT INTO users_subjects VALUES (17, 4, 10, '2012-12-20 10:31:32.014756', '2012-12-20 10:31:32.014756');
INSERT INTO users_subjects VALUES (18, 4, 8, '2012-12-20 10:31:32.018991', '2012-12-20 10:31:32.018991');
INSERT INTO users_subjects VALUES (19, 4, 3, '2012-12-20 10:31:32.023201', '2012-12-20 10:31:32.023201');
INSERT INTO users_subjects VALUES (20, 5, 1, '2012-12-20 10:31:32.038896', '2012-12-20 10:31:32.038896');
INSERT INTO users_subjects VALUES (21, 5, 5, '2012-12-20 10:31:32.043122', '2012-12-20 10:31:32.043122');
INSERT INTO users_subjects VALUES (22, 5, 6, '2012-12-20 10:31:32.047323', '2012-12-20 10:31:32.047323');
INSERT INTO users_subjects VALUES (23, 6, 1, '2012-12-20 10:31:32.062667', '2012-12-20 10:31:32.062667');
INSERT INTO users_subjects VALUES (24, 6, 5, '2012-12-20 10:31:32.066893', '2012-12-20 10:31:32.066893');
INSERT INTO users_subjects VALUES (25, 6, 6, '2012-12-20 10:31:32.071098', '2012-12-20 10:31:32.071098');
INSERT INTO users_subjects VALUES (26, 6, 10, '2012-12-20 10:31:32.075326', '2012-12-20 10:31:32.075326');
INSERT INTO users_subjects VALUES (27, 7, 1, '2012-12-20 10:31:32.092575', '2012-12-20 10:31:32.092575');
INSERT INTO users_subjects VALUES (28, 7, 5, '2012-12-20 10:31:32.09695', '2012-12-20 10:31:32.09695');
INSERT INTO users_subjects VALUES (29, 7, 6, '2012-12-20 10:31:32.101135', '2012-12-20 10:31:32.101135');
INSERT INTO users_subjects VALUES (30, 7, 10, '2012-12-20 10:31:32.105324', '2012-12-20 10:31:32.105324');
INSERT INTO users_subjects VALUES (31, 7, 2, '2012-12-20 10:31:32.109529', '2012-12-20 10:31:32.109529');
INSERT INTO users_subjects VALUES (32, 7, 3, '2012-12-20 10:31:32.113735', '2012-12-20 10:31:32.113735');
INSERT INTO users_subjects VALUES (33, 7, 11, '2012-12-20 10:31:32.117945', '2012-12-20 10:31:32.117945');
INSERT INTO users_subjects VALUES (34, 8, 1, '2012-12-21 15:39:53.950728', '2012-12-21 15:39:53.950728');
INSERT INTO users_subjects VALUES (35, 8, 2, '2012-12-21 15:39:53.957525', '2012-12-21 15:39:53.957525');
INSERT INTO users_subjects VALUES (36, 8, 3, '2012-12-21 15:39:53.962008', '2012-12-21 15:39:53.962008');
INSERT INTO users_subjects VALUES (37, 8, 4, '2012-12-21 15:39:53.966358', '2012-12-21 15:39:53.966358');
INSERT INTO users_subjects VALUES (38, 8, 5, '2012-12-21 15:39:53.970542', '2012-12-21 15:39:53.970542');
INSERT INTO users_subjects VALUES (39, 8, 6, '2012-12-21 15:39:53.974882', '2012-12-21 15:39:53.974882');
INSERT INTO users_subjects VALUES (40, 8, 7, '2012-12-21 15:39:53.979083', '2012-12-21 15:39:53.979083');
INSERT INTO users_subjects VALUES (41, 8, 8, '2012-12-21 15:39:53.98337', '2012-12-21 15:39:53.98337');
INSERT INTO users_subjects VALUES (42, 8, 9, '2012-12-21 15:39:53.987476', '2012-12-21 15:39:53.987476');
INSERT INTO users_subjects VALUES (43, 8, 10, '2012-12-21 15:39:53.991649', '2012-12-21 15:39:53.991649');
INSERT INTO users_subjects VALUES (44, 8, 11, '2012-12-21 15:39:53.995918', '2012-12-21 15:39:53.995918');
INSERT INTO users_subjects VALUES (45, 9, 1, '2012-12-21 15:39:54.031438', '2012-12-21 15:39:54.031438');
INSERT INTO users_subjects VALUES (46, 9, 2, '2012-12-21 15:39:54.035659', '2012-12-21 15:39:54.035659');
INSERT INTO users_subjects VALUES (47, 9, 3, '2012-12-21 15:39:54.039799', '2012-12-21 15:39:54.039799');
INSERT INTO users_subjects VALUES (48, 9, 4, '2012-12-21 15:39:54.043968', '2012-12-21 15:39:54.043968');
INSERT INTO users_subjects VALUES (49, 9, 5, '2012-12-21 15:39:54.04809', '2012-12-21 15:39:54.04809');
INSERT INTO users_subjects VALUES (50, 9, 6, '2012-12-21 15:39:54.052256', '2012-12-21 15:39:54.052256');
INSERT INTO users_subjects VALUES (51, 9, 7, '2012-12-21 15:39:54.056401', '2012-12-21 15:39:54.056401');
INSERT INTO users_subjects VALUES (52, 9, 8, '2012-12-21 15:39:54.060626', '2012-12-21 15:39:54.060626');
INSERT INTO users_subjects VALUES (53, 9, 9, '2012-12-21 15:39:54.064785', '2012-12-21 15:39:54.064785');
INSERT INTO users_subjects VALUES (54, 9, 10, '2012-12-21 15:39:54.069117', '2012-12-21 15:39:54.069117');
INSERT INTO users_subjects VALUES (55, 9, 11, '2012-12-21 15:39:54.073383', '2012-12-21 15:39:54.073383');
INSERT INTO users_subjects VALUES (56, 10, 1, '2012-12-21 15:39:54.089645', '2012-12-21 15:39:54.089645');
INSERT INTO users_subjects VALUES (57, 10, 2, '2012-12-21 15:39:54.093856', '2012-12-21 15:39:54.093856');
INSERT INTO users_subjects VALUES (58, 10, 3, '2012-12-21 15:39:54.098007', '2012-12-21 15:39:54.098007');
INSERT INTO users_subjects VALUES (59, 10, 4, '2012-12-21 15:39:54.102176', '2012-12-21 15:39:54.102176');
INSERT INTO users_subjects VALUES (60, 10, 5, '2012-12-21 15:39:54.106325', '2012-12-21 15:39:54.106325');
INSERT INTO users_subjects VALUES (61, 10, 6, '2012-12-21 15:39:54.110458', '2012-12-21 15:39:54.110458');
INSERT INTO users_subjects VALUES (62, 10, 7, '2012-12-21 15:39:54.11461', '2012-12-21 15:39:54.11461');
INSERT INTO users_subjects VALUES (63, 10, 8, '2012-12-21 15:39:54.118756', '2012-12-21 15:39:54.118756');
INSERT INTO users_subjects VALUES (64, 10, 9, '2012-12-21 15:39:54.12299', '2012-12-21 15:39:54.12299');
INSERT INTO users_subjects VALUES (65, 10, 10, '2012-12-21 15:39:54.12714', '2012-12-21 15:39:54.12714');
INSERT INTO users_subjects VALUES (66, 10, 11, '2012-12-21 15:39:54.131458', '2012-12-21 15:39:54.131458');
INSERT INTO users_subjects VALUES (67, 11, 1, '2012-12-21 15:39:54.149626', '2012-12-21 15:39:54.149626');
INSERT INTO users_subjects VALUES (68, 11, 2, '2012-12-21 15:39:54.153794', '2012-12-21 15:39:54.153794');
INSERT INTO users_subjects VALUES (69, 11, 3, '2012-12-21 15:39:54.157955', '2012-12-21 15:39:54.157955');
INSERT INTO users_subjects VALUES (70, 11, 4, '2012-12-21 15:39:54.16219', '2012-12-21 15:39:54.16219');
INSERT INTO users_subjects VALUES (71, 11, 5, '2012-12-21 15:39:54.166392', '2012-12-21 15:39:54.166392');
INSERT INTO users_subjects VALUES (72, 11, 6, '2012-12-21 15:39:54.170612', '2012-12-21 15:39:54.170612');
INSERT INTO users_subjects VALUES (73, 11, 7, '2012-12-21 15:39:54.174891', '2012-12-21 15:39:54.174891');
INSERT INTO users_subjects VALUES (74, 11, 8, '2012-12-21 15:39:54.179091', '2012-12-21 15:39:54.179091');
INSERT INTO users_subjects VALUES (75, 11, 9, '2012-12-21 15:39:54.183327', '2012-12-21 15:39:54.183327');
INSERT INTO users_subjects VALUES (76, 11, 10, '2012-12-21 15:39:54.187581', '2012-12-21 15:39:54.187581');
INSERT INTO users_subjects VALUES (77, 11, 11, '2012-12-21 15:39:54.191734', '2012-12-21 15:39:54.191734');
INSERT INTO users_subjects VALUES (78, 12, 1, '2012-12-21 15:39:54.20984', '2012-12-21 15:39:54.20984');
INSERT INTO users_subjects VALUES (79, 12, 2, '2012-12-21 15:39:54.214082', '2012-12-21 15:39:54.214082');
INSERT INTO users_subjects VALUES (80, 12, 3, '2012-12-21 15:39:54.218283', '2012-12-21 15:39:54.218283');
INSERT INTO users_subjects VALUES (81, 12, 4, '2012-12-21 15:39:54.222486', '2012-12-21 15:39:54.222486');
INSERT INTO users_subjects VALUES (82, 12, 5, '2012-12-21 15:39:54.22672', '2012-12-21 15:39:54.22672');
INSERT INTO users_subjects VALUES (83, 12, 6, '2012-12-21 15:39:54.230968', '2012-12-21 15:39:54.230968');
INSERT INTO users_subjects VALUES (84, 12, 7, '2012-12-21 15:39:54.23516', '2012-12-21 15:39:54.23516');
INSERT INTO users_subjects VALUES (85, 12, 8, '2012-12-21 15:39:54.23929', '2012-12-21 15:39:54.23929');
INSERT INTO users_subjects VALUES (86, 12, 9, '2012-12-21 15:39:54.243441', '2012-12-21 15:39:54.243441');
INSERT INTO users_subjects VALUES (87, 12, 10, '2012-12-21 15:39:54.247601', '2012-12-21 15:39:54.247601');
INSERT INTO users_subjects VALUES (88, 12, 11, '2012-12-21 15:39:54.251771', '2012-12-21 15:39:54.251771');
INSERT INTO users_subjects VALUES (89, 13, 1, '2012-12-21 15:39:54.269789', '2012-12-21 15:39:54.269789');
INSERT INTO users_subjects VALUES (90, 13, 2, '2012-12-21 15:39:54.273976', '2012-12-21 15:39:54.273976');
INSERT INTO users_subjects VALUES (91, 13, 3, '2012-12-21 15:39:54.278135', '2012-12-21 15:39:54.278135');
INSERT INTO users_subjects VALUES (92, 13, 4, '2012-12-21 15:39:54.282315', '2012-12-21 15:39:54.282315');
INSERT INTO users_subjects VALUES (93, 13, 5, '2012-12-21 15:39:54.286446', '2012-12-21 15:39:54.286446');
INSERT INTO users_subjects VALUES (94, 13, 6, '2012-12-21 15:39:54.290603', '2012-12-21 15:39:54.290603');
INSERT INTO users_subjects VALUES (95, 13, 7, '2012-12-21 15:39:54.294815', '2012-12-21 15:39:54.294815');
INSERT INTO users_subjects VALUES (96, 13, 8, '2012-12-21 15:39:54.299051', '2012-12-21 15:39:54.299051');
INSERT INTO users_subjects VALUES (97, 13, 9, '2012-12-21 15:39:54.303254', '2012-12-21 15:39:54.303254');
INSERT INTO users_subjects VALUES (98, 13, 10, '2012-12-21 15:39:54.307432', '2012-12-21 15:39:54.307432');
INSERT INTO users_subjects VALUES (99, 13, 11, '2012-12-21 15:39:54.311606', '2012-12-21 15:39:54.311606');


--
-- PostgreSQL database dump complete
--

