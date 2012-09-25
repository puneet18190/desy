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
    'text1',
    'text2',
    'image1',
    'image2',
    'image3',
    'audio1',
    'audio2',
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
-- Name: lessons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lessons (
    id integer NOT NULL,
    user_id integer NOT NULL,
    school_level_id integer NOT NULL,
    subject_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    public boolean DEFAULT false NOT NULL,
    parent_id integer,
    copied_not_modified boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
-- Name: media_elements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_elements (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    duration integer,
    sti_type character varying(255) NOT NULL,
    public boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    updated_at timestamp without time zone NOT NULL
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
-- Name: slides; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE slides (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    title character varying(255),
    text1 text,
    text2 text,
    "position" integer NOT NULL,
    type slide_type NOT NULL,
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
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    surname character varying(255) NOT NULL,
    school_level_id integer NOT NULL,
    school character varying(255) NOT NULL,
    password_hash character varying(255),
    password_salt character varying(255),
    location_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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

ALTER TABLE ONLY media_elements ALTER COLUMN id SET DEFAULT nextval('media_elements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements_slides ALTER COLUMN id SET DEFAULT nextval('media_elements_slides_id_seq'::regclass);


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

ALTER TABLE ONLY slides ALTER COLUMN id SET DEFAULT nextval('slides_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects ALTER COLUMN id SET DEFAULT nextval('subjects_id_seq'::regclass);


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
-- Name: index_bookmarks_on_bookmarkable_type_and_bookmarkable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_bookmarks_on_bookmarkable_type_and_bookmarkable_id ON bookmarks USING btree (bookmarkable_type, bookmarkable_id);


--
-- Name: index_bookmarks_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bookmarks_on_user_id ON bookmarks USING btree (user_id);


--
-- Name: index_lessons_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_parent_id ON lessons USING btree (parent_id);


--
-- Name: index_lessons_on_school_level_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_school_level_id ON lessons USING btree (school_level_id);


--
-- Name: index_lessons_on_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_subject_id ON lessons USING btree (subject_id);


--
-- Name: index_lessons_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_lessons_on_user_id ON lessons USING btree (user_id);


--
-- Name: index_likes_on_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_likes_on_lesson_id ON likes USING btree (lesson_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_likes_on_user_id ON likes USING btree (user_id);


--
-- Name: index_media_elements_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_elements_on_user_id ON media_elements USING btree (user_id);


--
-- Name: index_media_elements_slides_on_media_element_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_elements_slides_on_media_element_id ON media_elements_slides USING btree (media_element_id);


--
-- Name: index_media_elements_slides_on_slide_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_elements_slides_on_slide_id ON media_elements_slides USING btree (slide_id);


--
-- Name: index_reports_on_reportable_type_and_reportable_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_reports_on_reportable_type_and_reportable_id_and_user_id ON reports USING btree (reportable_type, reportable_id, user_id);


--
-- Name: index_reports_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reports_on_user_id ON reports USING btree (user_id);


--
-- Name: index_slides_on_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slides_on_lesson_id ON slides USING btree (lesson_id);


--
-- Name: index_slides_on_position_and_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_slides_on_position_and_lesson_id ON slides USING btree ("position", lesson_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_location_id ON users USING btree (location_id);


--
-- Name: index_users_on_school_level_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_school_level_id ON users USING btree (school_level_id);


--
-- Name: index_users_subjects_on_subject_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_subjects_on_subject_id ON users_subjects USING btree (subject_id);


--
-- Name: index_users_subjects_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_subjects_on_user_id ON users_subjects USING btree (user_id);


--
-- Name: index_virtual_classroom_lessons_on_lesson_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_virtual_classroom_lessons_on_lesson_id ON virtual_classroom_lessons USING btree (lesson_id);


--
-- Name: index_virtual_classroom_lessons_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_virtual_classroom_lessons_on_user_id ON virtual_classroom_lessons USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: bookmarks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookmarks
    ADD CONSTRAINT bookmarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: lessons_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES lessons(id);


--
-- Name: lessons_school_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_school_level_id_fkey FOREIGN KEY (school_level_id) REFERENCES school_levels(id);


--
-- Name: lessons_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: lessons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: likes_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE;


--
-- Name: likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: media_elements_slides_media_element_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements_slides
    ADD CONSTRAINT media_elements_slides_media_element_id_fkey FOREIGN KEY (media_element_id) REFERENCES media_elements(id) ON DELETE CASCADE;


--
-- Name: media_elements_slides_slide_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements_slides
    ADD CONSTRAINT media_elements_slides_slide_id_fkey FOREIGN KEY (slide_id) REFERENCES slides(id) ON DELETE CASCADE;


--
-- Name: media_elements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_elements
    ADD CONSTRAINT media_elements_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: reports_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: slides_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY slides
    ADD CONSTRAINT slides_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE;


--
-- Name: users_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_location_id_fkey FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: users_school_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_school_level_id_fkey FOREIGN KEY (school_level_id) REFERENCES school_levels(id);


--
-- Name: users_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_subjects
    ADD CONSTRAINT users_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: users_subjects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_subjects
    ADD CONSTRAINT users_subjects_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: virtual_classroom_lessons_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_classroom_lessons
    ADD CONSTRAINT virtual_classroom_lessons_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE;


--
-- Name: virtual_classroom_lessons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY virtual_classroom_lessons
    ADD CONSTRAINT virtual_classroom_lessons_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


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