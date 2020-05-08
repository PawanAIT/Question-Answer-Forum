--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-06 09:57:30 UTC

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 16385)
-- Name: answers; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.answers (
    answer_id bigint NOT NULL,
    answer_text character varying NOT NULL,
    answer_poster_id bigint NOT NULL,
    question_id bigint NOT NULL,
    kudos integer DEFAULT 0,
    downvotes integer DEFAULT 0,
    answer_created_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    answer_updated_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.answers OWNER TO pawan;

--
-- TOC entry 203 (class 1259 OID 16395)
-- Name: answers_answer_id_seq; Type: SEQUENCE; Schema: public; Owner: pawan
--

ALTER TABLE public.answers ALTER COLUMN answer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.answers_answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 204 (class 1259 OID 16397)
-- Name: comments; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.comments (
    comment_id bigint NOT NULL,
    comment_text character varying,
    comment_poster_id bigint,
    answer_id bigint,
    comment_created_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    comment_updated_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.comments OWNER TO pawan;

--
-- TOC entry 205 (class 1259 OID 16405)
-- Name: comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: pawan
--

ALTER TABLE public.comments ALTER COLUMN comment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.comments_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 206 (class 1259 OID 16407)
-- Name: follow_question; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.follow_question (
    followed_question_id bigint NOT NULL,
    follower_user_id bigint NOT NULL
);


ALTER TABLE public.follow_question OWNER TO pawan;

--
-- TOC entry 207 (class 1259 OID 16410)
-- Name: follow_topic; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.follow_topic (
    followed_topic_id bigint NOT NULL,
    follower_user_id bigint NOT NULL
);


ALTER TABLE public.follow_topic OWNER TO pawan;

--
-- TOC entry 208 (class 1259 OID 16413)
-- Name: follow_user; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.follow_user (
    follower_user_id bigint NOT NULL,
    followed_user_id bigint NOT NULL
);


ALTER TABLE public.follow_user OWNER TO pawan;

--
-- TOC entry 209 (class 1259 OID 16416)
-- Name: questions; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.questions (
    question_id bigint NOT NULL,
    question_title character varying(1000) NOT NULL,
    question_details character varying(4000),
    question_poster_id bigint NOT NULL,
    question_topic_id bigint NOT NULL,
    question_created_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    question_updated_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.questions OWNER TO pawan;

--
-- TOC entry 210 (class 1259 OID 16424)
-- Name: questions_question_id_seq; Type: SEQUENCE; Schema: public; Owner: pawan
--

ALTER TABLE public.questions ALTER COLUMN question_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.questions_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 211 (class 1259 OID 16426)
-- Name: topics; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.topics (
    topic_id bigint NOT NULL,
    topic_name character varying(50) NOT NULL
);


ALTER TABLE public.topics OWNER TO pawan;

--
-- TOC entry 212 (class 1259 OID 16429)
-- Name: topics_topic_id_seq; Type: SEQUENCE; Schema: public; Owner: pawan
--

ALTER TABLE public.topics ALTER COLUMN topic_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.topics_topic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 213 (class 1259 OID 16431)
-- Name: user_gave_kudos; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.user_gave_kudos (
    user_id bigint NOT NULL,
    kudos_answer_id bigint NOT NULL,
    kudos_question_id bigint NOT NULL
);


ALTER TABLE public.user_gave_kudos OWNER TO pawan;

--
-- TOC entry 214 (class 1259 OID 16434)
-- Name: user_seen_answers; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.user_seen_answers (
    user_id bigint NOT NULL,
    seen_answer_id bigint NOT NULL
);


ALTER TABLE public.user_seen_answers OWNER TO pawan;

--
-- TOC entry 215 (class 1259 OID 16437)
-- Name: user_seen_question; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.user_seen_question (
    user_id bigint NOT NULL,
    seen_question_id bigint NOT NULL
);


ALTER TABLE public.user_seen_question OWNER TO pawan;

--
-- TOC entry 216 (class 1259 OID 16440)
-- Name: users; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    bio character varying(256),
    profile_picture character varying(500),
    profile_created_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    profile_updated_datetime timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO pawan;

--
-- TOC entry 217 (class 1259 OID 16448)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: pawan
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 2868 (class 2606 OID 16451)
-- Name: users UC_user_email; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UC_user_email" UNIQUE (email);


--
-- TOC entry 2840 (class 2606 OID 16453)
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (answer_id);


--
-- TOC entry 2842 (class 2606 OID 16455)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 2847 (class 2606 OID 16457)
-- Name: follow_question follow_question_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_question
    ADD CONSTRAINT follow_question_pkey PRIMARY KEY (followed_question_id, follower_user_id);


--
-- TOC entry 2850 (class 2606 OID 16459)
-- Name: follow_topic follow_topic_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_topic
    ADD CONSTRAINT follow_topic_pkey PRIMARY KEY (followed_topic_id, follower_user_id);


--
-- TOC entry 2853 (class 2606 OID 16461)
-- Name: follow_user follow_user_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_user
    ADD CONSTRAINT follow_user_pkey PRIMARY KEY (follower_user_id, followed_user_id);


--
-- TOC entry 2855 (class 2606 OID 16463)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- TOC entry 2857 (class 2606 OID 16465)
-- Name: topics topic_name; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topic_name UNIQUE (topic_name);


--
-- TOC entry 2859 (class 2606 OID 16467)
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (topic_id);


--
-- TOC entry 2861 (class 2606 OID 16469)
-- Name: user_gave_kudos user_gave_kudos_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT user_gave_kudos_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2864 (class 2606 OID 16471)
-- Name: user_seen_answers user_seen_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_answers
    ADD CONSTRAINT user_seen_answers_pkey PRIMARY KEY (user_id, seen_answer_id);


--
-- TOC entry 2866 (class 2606 OID 16473)
-- Name: user_seen_question user_seen_question_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_question
    ADD CONSTRAINT user_seen_question_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2870 (class 2606 OID 16475)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2843 (class 1259 OID 16546)
-- Name: fki_answer_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_answer_id ON public.comments USING btree (answer_id);


--
-- TOC entry 2844 (class 1259 OID 16476)
-- Name: fki_follow_question_user_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_follow_question_user_id ON public.follow_question USING btree (follower_user_id);


--
-- TOC entry 2845 (class 1259 OID 16477)
-- Name: fki_question_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_question_id ON public.follow_question USING btree (followed_question_id);


--
-- TOC entry 2848 (class 1259 OID 16478)
-- Name: fki_topic_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_topic_id ON public.follow_topic USING btree (followed_topic_id);


--
-- TOC entry 2862 (class 1259 OID 16479)
-- Name: fki_user_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_user_id ON public.user_seen_answers USING btree (user_id);


--
-- TOC entry 2851 (class 1259 OID 16480)
-- Name: fki_user_id1; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_user_id1 ON public.follow_user USING btree (followed_user_id);


--
-- TOC entry 2874 (class 2606 OID 16541)
-- Name: comments answer_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT answer_id FOREIGN KEY (answer_id) REFERENCES public.answers(answer_id);


--
-- TOC entry 2884 (class 2606 OID 16557)
-- Name: user_gave_kudos answer_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT answer_id FOREIGN KEY (kudos_answer_id) REFERENCES public.answers(answer_id);


--
-- TOC entry 2887 (class 2606 OID 16567)
-- Name: user_seen_answers answer_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_answers
    ADD CONSTRAINT answer_id FOREIGN KEY (seen_answer_id) REFERENCES public.answers(answer_id);


--
-- TOC entry 2875 (class 2606 OID 16481)
-- Name: follow_question question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_question
    ADD CONSTRAINT question_id FOREIGN KEY (followed_question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2872 (class 2606 OID 16531)
-- Name: answers question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT question_id FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2885 (class 2606 OID 16562)
-- Name: user_gave_kudos question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT question_id FOREIGN KEY (kudos_question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2889 (class 2606 OID 16572)
-- Name: user_seen_question question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_question
    ADD CONSTRAINT question_id FOREIGN KEY (seen_question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2877 (class 2606 OID 16486)
-- Name: follow_topic topic_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_topic
    ADD CONSTRAINT topic_id FOREIGN KEY (followed_topic_id) REFERENCES public.topics(topic_id);


--
-- TOC entry 2882 (class 2606 OID 16552)
-- Name: questions topic_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT topic_id FOREIGN KEY (question_topic_id) REFERENCES public.topics(topic_id);


--
-- TOC entry 2886 (class 2606 OID 16491)
-- Name: user_seen_answers user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_answers
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2888 (class 2606 OID 16496)
-- Name: user_seen_question user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_question
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2876 (class 2606 OID 16501)
-- Name: follow_question user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_question
    ADD CONSTRAINT user_id FOREIGN KEY (follower_user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2879 (class 2606 OID 16506)
-- Name: follow_user user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_user
    ADD CONSTRAINT user_id FOREIGN KEY (follower_user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2883 (class 2606 OID 16511)
-- Name: user_gave_kudos user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2878 (class 2606 OID 16516)
-- Name: follow_topic user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_topic
    ADD CONSTRAINT user_id FOREIGN KEY (follower_user_id) REFERENCES public.users(user_id) NOT VALID;


--
-- TOC entry 2871 (class 2606 OID 16526)
-- Name: answers user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT user_id FOREIGN KEY (answer_poster_id) REFERENCES public.users(user_id);


--
-- TOC entry 2873 (class 2606 OID 16536)
-- Name: comments user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT user_id FOREIGN KEY (comment_poster_id) REFERENCES public.users(user_id);


--
-- TOC entry 2881 (class 2606 OID 16547)
-- Name: questions user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT user_id FOREIGN KEY (question_poster_id) REFERENCES public.users(user_id);


--
-- TOC entry 2880 (class 2606 OID 16521)
-- Name: follow_user user_id1; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_user
    ADD CONSTRAINT user_id1 FOREIGN KEY (followed_user_id) REFERENCES public.users(user_id);


-- Completed on 2020-05-06 09:57:30 UTC

--
-- PostgreSQL database dump complete
--

