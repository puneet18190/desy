--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: slide_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE slide_type AS ENUM (
    'cover',
    'title',
    'text',
    'image1',
    'image2',
    'image3',
    'image4',
    'audio',
    'video1',
    'video2'
);


--
-- Name: teaching_object; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE teaching_object AS ENUM (
    'Lesson',
    'MediaElement'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bookmarks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bookmarks (
    id integer NOT NULL,
    user_id integer NOT NULL,
    bookmarkable_id integer NOT NULL,
    bookmarkable_type teaching_object NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bookmarks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bookmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bookmarks_id_seq OWNED BY bookmarks.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lessons (
    id integer NOT NULL,
    user_id integer NOT NULL,
    school_level_id integer NOT NULL,
    subject_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    parent_id integer,
    copied_not_modified boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    token character varying(20),
    metadata text,
    notified boolean DEFAULT true NOT NULL
);


--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lessons_id_seq OWNED BY lessons.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE likes (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    description character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: mailing_list_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailing_list_addresses (
    id integer NOT NULL,
    group_id integer,
    heading character varying(255),
    email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mailing_list_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailing_list_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailing_list_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailing_list_addresses_id_seq OWNED BY mailing_list_addresses.id;


--
-- Name: mailing_list_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailing_list_groups (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mailing_list_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailing_list_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailing_list_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailing_list_groups_id_seq OWNED BY mailing_list_groups.id;


--
-- Name: media_elements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_elements (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    sti_type character varying(255) NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    publication_date timestamp without time zone,
    media character varying(255),
    metadata text,
    converted boolean
);


--
-- Name: media_elements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_elements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_elements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_elements_id_seq OWNED BY media_elements.id;


--
-- Name: media_elements_slides; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_elements_slides (
    id integer NOT NULL,
    media_element_id integer NOT NULL,
    slide_id integer NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    caption text,
    alignment integer
);


--
-- Name: media_elements_slides_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_elements_slides_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_elements_slides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_elements_slides_id_seq OWNED BY media_elements_slides.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message text NOT NULL,
    seen boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reports (
    id integer NOT NULL,
    reportable_id integer NOT NULL,
    reportable_type teaching_object NOT NULL,
    user_id integer NOT NULL,
    comment text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: school_levels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE school_levels (
    id integer NOT NULL,
    description character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: school_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE school_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: school_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE school_levels_id_seq OWNED BY school_levels.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: slides; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE slides (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    title character varying(255),
    text text,
    "position" integer NOT NULL,
    kind slide_type NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: slides_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE slides_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE slides_id_seq OWNED BY slides.id;


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subjects (
    id integer NOT NULL,
    description character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subjects_id_seq OWNED BY subjects.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    taggable_id integer NOT NULL,
    taggable_type teaching_object NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    word character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    surname character varying(255) NOT NULL,
    school_level_id integer NOT NULL,
    school character varying(255) NOT NULL,
    encrypted_password character varying(255) NOT NULL,
    confirmed boolean NOT NULL,
    location_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    confirmation_token character varying(255),
    video_editor_cache text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_subjects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_subjects (
    id integer NOT NULL,
    user_id integer NOT NULL,
    subject_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_subjects_id_seq OWNED BY users_subjects.id;


--
-- Name: virtual_classroom_lessons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE virtual_classroom_lessons (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    user_id integer NOT NULL,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: virtual_classroom_lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE virtual_classroom_lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virtual_classroom_lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE virtual_classroom_lessons_id_seq OWNED BY virtual_classroom_lessons.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookmarks ALTER COLUMN id SET DEFAULT nextval('bookmarks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons ALTER COLUMN id SET DEFAULT nextval('lessons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailing_list_addresses ALTER COLUMN id SET DEFAULT nextval('mailing_list_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailing_list_groups ALTER COLUMN id SET DEFAULT nextval('mailing_list_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements ALTER COLUMN id SET DEFAULT nextval('media_elements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements_slides ALTER COLUMN id SET DEFAULT nextval('media_elements_slides_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY school_levels ALTER COLUMN id SET DEFAULT nextval('school_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY slides ALTER COLUMN id SET DEFAULT nextval('slides_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects ALTER COLUMN id SET DEFAULT nextval('subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_subjects ALTER COLUMN id SET DEFAULT nextval('users_subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_classroom_lessons ALTER COLUMN id SET DEFAULT nextval('virtual_classroom_lessons_id_seq'::regclass);


--
-- Name: bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: mailing_list_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailing_list_addresses
    ADD CONSTRAINT mailing_list_addresses_pkey PRIMARY KEY (id);


--
-- Name: mailing_list_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailing_list_groups
    ADD CONSTRAINT mailing_list_groups_pkey PRIMARY KEY (id);


--
-- Name: media_elements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_elements
    ADD CONSTRAINT media_elements_pkey PRIMARY KEY (id);


--
-- Name: media_elements_slides_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_elements_slides
    ADD CONSTRAINT media_elements_slides_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: school_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY school_levels
    ADD CONSTRAINT school_levels_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: slides_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY slides
    ADD CONSTRAINT slides_pkey PRIMARY KEY (id);


--
-- Name: subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_subjects
    ADD CONSTRAINT users_subjects_pkey PRIMARY KEY (id);


--
-- Name: virtual_classroom_lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY virtual_classroom_lessons
    ADD CONSTRAINT virtual_classroom_lessons_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: fk__bookmarks_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__bookmarks_user_id ON bookmarks USING btree (user_id);


--
-- Name: fk__lessons_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__lessons_parent_id ON lessons USING btree (parent_id);


--
-- Name: fk__lessons_school_level_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__lessons_school_level_id ON lessons USING btree (school_level_id);


--
-- Name: fk__lessons_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__lessons_subject_id ON lessons USING btree (subject_id);


--
-- Name: fk__lessons_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__lessons_user_id ON lessons USING btree (user_id);


--
-- Name: fk__likes_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__likes_lesson_id ON likes USING btree (lesson_id);


--
-- Name: fk__likes_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__likes_user_id ON likes USING btree (user_id);


--
-- Name: fk__mailing_list_addresses_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__mailing_list_addresses_group_id ON mailing_list_addresses USING btree (group_id);


--
-- Name: fk__mailing_list_groups_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__mailing_list_groups_user_id ON mailing_list_groups USING btree (user_id);


--
-- Name: fk__media_elements_slides_media_element_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__media_elements_slides_media_element_id ON media_elements_slides USING btree (media_element_id);


--
-- Name: fk__media_elements_slides_slide_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__media_elements_slides_slide_id ON media_elements_slides USING btree (slide_id);


--
-- Name: fk__media_elements_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__media_elements_user_id ON media_elements USING btree (user_id);


--
-- Name: fk__notifications_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__notifications_user_id ON notifications USING btree (user_id);


--
-- Name: fk__reports_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__reports_user_id ON reports USING btree (user_id);


--
-- Name: fk__slides_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__slides_lesson_id ON slides USING btree (lesson_id);


--
-- Name: fk__taggings_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__taggings_tag_id ON taggings USING btree (tag_id);


--
-- Name: fk__users_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__users_location_id ON users USING btree (location_id);


--
-- Name: fk__users_school_level_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__users_school_level_id ON users USING btree (school_level_id);


--
-- Name: fk__users_subjects_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__users_subjects_subject_id ON users_subjects USING btree (subject_id);


--
-- Name: fk__users_subjects_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__users_subjects_user_id ON users_subjects USING btree (user_id);


--
-- Name: fk__virtual_classroom_lessons_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__virtual_classroom_lessons_lesson_id ON virtual_classroom_lessons USING btree (lesson_id);


--
-- Name: fk__virtual_classroom_lessons_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__virtual_classroom_lessons_user_id ON virtual_classroom_lessons USING btree (user_id);


--
-- Name: index_bookmarks_on_bookmarkable_type_bookmarkable_id_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_bookmarks_on_bookmarkable_type_bookmarkable_id_user_id ON bookmarks USING btree (bookmarkable_type, bookmarkable_id, user_id);


--
-- Name: index_lessons_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_title ON lessons USING btree (title DESC);


--
-- Name: index_lessons_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_updated_at ON lessons USING btree (updated_at DESC);


--
-- Name: index_media_elements_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_elements_on_title ON media_elements USING btree (title DESC);


--
-- Name: index_media_elements_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_elements_on_updated_at ON media_elements USING btree (updated_at DESC);


--
-- Name: index_reports_on_reportable_type_and_reportable_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_reports_on_reportable_type_and_reportable_id_and_user_id ON reports USING btree (reportable_type, reportable_id, user_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_slides_on_position_and_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_slides_on_position_and_lesson_id ON slides USING btree ("position", lesson_id);


--
-- Name: index_taggings_on_taggable_type_and_taggable_id_and_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_taggings_on_taggable_type_and_taggable_id_and_tag_id ON taggings USING btree (taggable_type, taggable_id, tag_id);


--
-- Name: index_tags_on_word; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_word ON tags USING btree (word);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_confirmed; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_confirmed ON users USING btree (confirmed);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_bookmarks_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookmarks
    ADD CONSTRAINT fk_bookmarks_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_lessons_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT fk_lessons_parent_id FOREIGN KEY (parent_id) REFERENCES lessons(id) ON DELETE SET NULL;


--
-- Name: fk_lessons_school_level_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT fk_lessons_school_level_id FOREIGN KEY (school_level_id) REFERENCES school_levels(id);


--
-- Name: fk_lessons_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT fk_lessons_subject_id FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: fk_lessons_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT fk_lessons_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_likes_lesson_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT fk_likes_lesson_id FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE;


--
-- Name: fk_likes_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT fk_likes_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_mailing_list_addresses_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailing_list_addresses
    ADD CONSTRAINT fk_mailing_list_addresses_group_id FOREIGN KEY (group_id) REFERENCES mailing_list_groups(id) ON DELETE CASCADE;


--
-- Name: fk_mailing_list_groups_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailing_list_groups
    ADD CONSTRAINT fk_mailing_list_groups_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_media_elements_slides_media_element_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements_slides
    ADD CONSTRAINT fk_media_elements_slides_media_element_id FOREIGN KEY (media_element_id) REFERENCES media_elements(id) ON DELETE CASCADE;


--
-- Name: fk_media_elements_slides_slide_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements_slides
    ADD CONSTRAINT fk_media_elements_slides_slide_id FOREIGN KEY (slide_id) REFERENCES slides(id) ON DELETE CASCADE;


--
-- Name: fk_media_elements_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements
    ADD CONSTRAINT fk_media_elements_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_notifications_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_notifications_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_reports_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_reports_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_slides_lesson_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY slides
    ADD CONSTRAINT fk_slides_lesson_id FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE;


--
-- Name: fk_taggings_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT fk_taggings_tag_id FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: fk_users_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_users_location_id FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: fk_users_school_level_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_users_school_level_id FOREIGN KEY (school_level_id) REFERENCES school_levels(id);


--
-- Name: fk_users_subjects_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_subjects
    ADD CONSTRAINT fk_users_subjects_subject_id FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: fk_users_subjects_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_subjects
    ADD CONSTRAINT fk_users_subjects_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_virtual_classroom_lessons_lesson_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_classroom_lessons
    ADD CONSTRAINT fk_virtual_classroom_lessons_lesson_id FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE;


--
-- Name: fk_virtual_classroom_lessons_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_classroom_lessons
    ADD CONSTRAINT fk_virtual_classroom_lessons_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120924120617');

INSERT INTO schema_migrations (version) VALUES ('20120924121212');

INSERT INTO schema_migrations (version) VALUES ('20120924121636');

INSERT INTO schema_migrations (version) VALUES ('20120924121714');

INSERT INTO schema_migrations (version) VALUES ('20120924121814');

INSERT INTO schema_migrations (version) VALUES ('20120924121937');

INSERT INTO schema_migrations (version) VALUES ('20120924122254');

INSERT INTO schema_migrations (version) VALUES ('20120924122935');

INSERT INTO schema_migrations (version) VALUES ('20120924123433');

INSERT INTO schema_migrations (version) VALUES ('20120924123913');

INSERT INTO schema_migrations (version) VALUES ('20120924125156');

INSERT INTO schema_migrations (version) VALUES ('20120924125333');

INSERT INTO schema_migrations (version) VALUES ('20120924125729');

INSERT INTO schema_migrations (version) VALUES ('20120924125840');

INSERT INTO schema_migrations (version) VALUES ('20120924130035');

INSERT INTO schema_migrations (version) VALUES ('20120926153638');

INSERT INTO schema_migrations (version) VALUES ('20120926153643');

INSERT INTO schema_migrations (version) VALUES ('20120926160646');

INSERT INTO schema_migrations (version) VALUES ('20120927141837');

INSERT INTO schema_migrations (version) VALUES ('20121024101844');

INSERT INTO schema_migrations (version) VALUES ('20121030094116');

INSERT INTO schema_migrations (version) VALUES ('20121107172441');

INSERT INTO schema_migrations (version) VALUES ('20121126140000');

INSERT INTO schema_migrations (version) VALUES ('20121206140304');

INSERT INTO schema_migrations (version) VALUES ('20121207091234');

INSERT INTO schema_migrations (version) VALUES ('20130115155629');

INSERT INTO schema_migrations (version) VALUES ('20130121130513');

INSERT INTO schema_migrations (version) VALUES ('20130123140753');

INSERT INTO schema_migrations (version) VALUES ('20130128152817');

INSERT INTO schema_migrations (version) VALUES ('20130130090239');

INSERT INTO schema_migrations (version) VALUES ('20130131093624');

INSERT INTO schema_migrations (version) VALUES ('20130131094635');