--
-- PostgreSQL database cluster dump
--

-- Started on 2020-05-18 14:03:36 UTC

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE pawan;
ALTER ROLE pawan WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5b778a4f5be66a3fc901ffd524bdeac2e';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md532e12f215ba27cb750c9e093ce4b5127';






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-18 14:03:36 UTC

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

-- Completed on 2020-05-18 14:03:36 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "QnAForum" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-18 14:03:36 UTC

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

--
-- TOC entry 3035 (class 1262 OID 16385)
-- Name: QnAForum; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "QnAForum" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE "QnAForum" OWNER TO postgres;

\connect "QnAForum"

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

--
-- TOC entry 230 (class 1255 OID 49161)
-- Name: add_user_seen_answers(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_user_seen_answers(user_id bigint, seen_answer_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO user_seen_answers(user_id , seen_answer_id)
		VALUES(user_id , seen_answer_id);
	 COMMIT;
END;$$;


ALTER PROCEDURE public.add_user_seen_answers(user_id bigint, seen_answer_id bigint) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 40962)
-- Name: sp_add_follow_question(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_add_follow_question(followed_question_id bigint, follower_user_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO follow_question(followed_question_id , follower_user_id )
		VALUES(followed_question_id , follower_user_id);
	 COMMIT;
END;$$;


ALTER PROCEDURE public.sp_add_follow_question(followed_question_id bigint, follower_user_id bigint) OWNER TO postgres;

--
-- TOC entry 3036 (class 0 OID 0)
-- Dependencies: 223
-- Name: PROCEDURE sp_add_follow_question(followed_question_id bigint, follower_user_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_add_follow_question(followed_question_id bigint, follower_user_id bigint) IS 'Stored procedure to add question followed by a user.';


--
-- TOC entry 225 (class 1255 OID 49155)
-- Name: sp_add_follow_topic(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_add_follow_topic(followed_topic_id bigint, follower_user_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
   INSERT INTO follow_topic (followed_topic_id , follower_user_id)	
            VALUES(followed_topic_id , follower_user_id);	
    COMMIT;
END;
$$;


ALTER PROCEDURE public.sp_add_follow_topic(followed_topic_id bigint, follower_user_id bigint) OWNER TO postgres;

--
-- TOC entry 3037 (class 0 OID 0)
-- Dependencies: 225
-- Name: PROCEDURE sp_add_follow_topic(followed_topic_id bigint, follower_user_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_add_follow_topic(followed_topic_id bigint, follower_user_id bigint) IS 'Stored procedure to add topics followed by a user.';


--
-- TOC entry 224 (class 1255 OID 49154)
-- Name: sp_add_follow_user(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_add_follow_user(follower_user_id bigint, followed_user_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
   INSERT INTO follow_user (follower_user_id , followed_user_id)	
            VALUES(follower_user_id , followed_user_id);	
    COMMIT;
END;
$$;


ALTER PROCEDURE public.sp_add_follow_user(follower_user_id bigint, followed_user_id bigint) OWNER TO postgres;

--
-- TOC entry 3038 (class 0 OID 0)
-- Dependencies: 224
-- Name: PROCEDURE sp_add_follow_user(follower_user_id bigint, followed_user_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_add_follow_user(follower_user_id bigint, followed_user_id bigint) IS 'Stored procedure to store the data of a user following another user.';


--
-- TOC entry 231 (class 1255 OID 57351)
-- Name: sp_add_kudos(bigint, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_add_kudos(_answer_id bigint, kudos_to_add integer)
    LANGUAGE plpgsql
    AS $$BEGIN
	UPDATE answers SET kudos = kudos + kudos_to_add
	    WHERE answer_id = _answer_id ;
	 COMMIT;
END;$$;


ALTER PROCEDURE public.sp_add_kudos(_answer_id bigint, kudos_to_add integer) OWNER TO postgres;

--
-- TOC entry 3039 (class 0 OID 0)
-- Dependencies: 231
-- Name: PROCEDURE sp_add_kudos(_answer_id bigint, kudos_to_add integer); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_add_kudos(_answer_id bigint, kudos_to_add integer) IS 'Stored procedure to add kudos to answer.';


--
-- TOC entry 229 (class 1255 OID 49160)
-- Name: sp_add_user_seen_question(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_add_user_seen_question(user_id bigint, seen_question_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO user_seen_question(user_id , seen_question_id)
		VALUES(user_id , seen_question_id);
	 COMMIT;
END;$$;


ALTER PROCEDURE public.sp_add_user_seen_question(user_id bigint, seen_question_id bigint) OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 32770)
-- Name: sp_insert_answer(character varying, bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_insert_answer(answer_text character varying, answer_poster_id bigint, question_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO answers(answer_text, answer_poster_id, question_id)
		VALUES(answer_text, answer_poster_id, question_id);
	 COMMIT;
END;
	$$;


ALTER PROCEDURE public.sp_insert_answer(answer_text character varying, answer_poster_id bigint, question_id bigint) OWNER TO postgres;

--
-- TOC entry 3040 (class 0 OID 0)
-- Dependencies: 221
-- Name: PROCEDURE sp_insert_answer(answer_text character varying, answer_poster_id bigint, question_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_insert_answer(answer_text character varying, answer_poster_id bigint, question_id bigint) IS 'Stored procedure for inserting answer in the db';


--
-- TOC entry 222 (class 1255 OID 32773)
-- Name: sp_insert_comment(character varying, bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_insert_comment(comment_text character varying, comment_poster_id bigint, answer_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO comments(comment_text, comment_poster_id, answer_id)
		VALUES(comment_text, comment_poster_id, answer_id);
	 COMMIT;
END;$$;


ALTER PROCEDURE public.sp_insert_comment(comment_text character varying, comment_poster_id bigint, answer_id bigint) OWNER TO postgres;

--
-- TOC entry 3041 (class 0 OID 0)
-- Dependencies: 222
-- Name: PROCEDURE sp_insert_comment(comment_text character varying, comment_poster_id bigint, answer_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_insert_comment(comment_text character varying, comment_poster_id bigint, answer_id bigint) IS 'Stored procedure to insert comments.';


--
-- TOC entry 220 (class 1255 OID 32771)
-- Name: sp_insert_question(character varying, character varying, bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_insert_question(question_title character varying, question_details character varying, question_poster_id bigint, question_topic_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO questions(question_title, question_details, question_poster_id, question_topic_id)
		VALUES(question_title, question_details, question_poster_id, question_topic_id);
	 COMMIT;
END;$$;


ALTER PROCEDURE public.sp_insert_question(question_title character varying, question_details character varying, question_poster_id bigint, question_topic_id bigint) OWNER TO postgres;

--
-- TOC entry 3042 (class 0 OID 0)
-- Dependencies: 220
-- Name: PROCEDURE sp_insert_question(question_title character varying, question_details character varying, question_poster_id bigint, question_topic_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_insert_question(question_title character varying, question_details character varying, question_poster_id bigint, question_topic_id bigint) IS 'Stored procedure to insert questions in the database.';


--
-- TOC entry 219 (class 1255 OID 32772)
-- Name: sp_insert_topic(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_insert_topic(topic_name character varying)
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO topics(topic_name)
		VALUES(topic_name);
	 COMMIT;
END;
	$$;


ALTER PROCEDURE public.sp_insert_topic(topic_name character varying) OWNER TO postgres;

--
-- TOC entry 3043 (class 0 OID 0)
-- Dependencies: 219
-- Name: PROCEDURE sp_insert_topic(topic_name character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_insert_topic(topic_name character varying) IS 'Stored procedure to insert topics in the database.';


--
-- TOC entry 218 (class 1255 OID 16579)
-- Name: sp_insert_user_details(character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_insert_user_details(first_name character varying, last_name character varying, email character varying, bio character varying DEFAULT NULL::character varying, profile_picture character varying DEFAULT NULL::character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
   INSERT INTO users (first_name, last_name, email, bio, profile_picture)	
            VALUES(first_name,last_name, email, bio, profile_picture);	
    COMMIT;
END;
$$;


ALTER PROCEDURE public.sp_insert_user_details(first_name character varying, last_name character varying, email character varying, bio character varying, profile_picture character varying) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 49157)
-- Name: sp_unfollow_question(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_unfollow_question(unfollower_user_id bigint, unfollowed_question_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
   DELETE FROM follow_question
       WHERE follow_question.followed_question_id = unfollowed_question_id
	   AND follow_question.followed_user_id = unfollower_user_id ; 
    COMMIT;
END;
$$;


ALTER PROCEDURE public.sp_unfollow_question(unfollower_user_id bigint, unfollowed_question_id bigint) OWNER TO postgres;

--
-- TOC entry 3044 (class 0 OID 0)
-- Dependencies: 227
-- Name: PROCEDURE sp_unfollow_question(unfollower_user_id bigint, unfollowed_question_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_unfollow_question(unfollower_user_id bigint, unfollowed_question_id bigint) IS 'Stored procedure to unfollow a question already followed by the user.';


--
-- TOC entry 228 (class 1255 OID 49158)
-- Name: sp_unfollow_topic(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_unfollow_topic(unfollowed_topic_id bigint, unfollower_user_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
   DELETE FROM follow_topic 	
       WHERE follow_topic.followed_topic_id = unfollowed_topic_id
	   AND follow_topic.follower_user_id = unfollower_user_id ;
    COMMIT;
END;
$$;


ALTER PROCEDURE public.sp_unfollow_topic(unfollowed_topic_id bigint, unfollower_user_id bigint) OWNER TO postgres;

--
-- TOC entry 3045 (class 0 OID 0)
-- Dependencies: 228
-- Name: PROCEDURE sp_unfollow_topic(unfollowed_topic_id bigint, unfollower_user_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_unfollow_topic(unfollowed_topic_id bigint, unfollower_user_id bigint) IS 'Stored procedure to unfollow topic followed by user.';


--
-- TOC entry 226 (class 1255 OID 49156)
-- Name: sp_unfollow_user(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sp_unfollow_user(unfollower_user_id bigint, unfollowed_user_id bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
   DELETE FROM follow_user
       where follow_user.follower_user_id = follower_user_id
	   and follow_user.followed_user_id = followed_user_id;
    COMMIT;
END;
$$;


ALTER PROCEDURE public.sp_unfollow_user(unfollower_user_id bigint, unfollowed_user_id bigint) OWNER TO postgres;

--
-- TOC entry 3046 (class 0 OID 0)
-- Dependencies: 226
-- Name: PROCEDURE sp_unfollow_user(unfollower_user_id bigint, unfollowed_user_id bigint); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON PROCEDURE public.sp_unfollow_user(unfollower_user_id bigint, unfollowed_user_id bigint) IS 'Stored procedure to unfollow a user by another user.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 16387)
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
-- TOC entry 203 (class 1259 OID 16397)
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
-- TOC entry 204 (class 1259 OID 16399)
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
-- TOC entry 205 (class 1259 OID 16407)
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
-- TOC entry 206 (class 1259 OID 16409)
-- Name: follow_question; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.follow_question (
    followed_question_id bigint NOT NULL,
    follower_user_id bigint NOT NULL
);


ALTER TABLE public.follow_question OWNER TO pawan;

--
-- TOC entry 207 (class 1259 OID 16412)
-- Name: follow_topic; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.follow_topic (
    followed_topic_id bigint NOT NULL,
    follower_user_id bigint NOT NULL
);


ALTER TABLE public.follow_topic OWNER TO pawan;

--
-- TOC entry 208 (class 1259 OID 16415)
-- Name: follow_user; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.follow_user (
    follower_user_id bigint NOT NULL,
    followed_user_id bigint NOT NULL
);


ALTER TABLE public.follow_user OWNER TO pawan;

--
-- TOC entry 209 (class 1259 OID 16418)
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
-- TOC entry 210 (class 1259 OID 16426)
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
-- TOC entry 211 (class 1259 OID 16428)
-- Name: topics; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.topics (
    topic_id bigint NOT NULL,
    topic_name character varying(50) NOT NULL
);


ALTER TABLE public.topics OWNER TO pawan;

--
-- TOC entry 212 (class 1259 OID 16431)
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
-- TOC entry 213 (class 1259 OID 16433)
-- Name: user_gave_kudos; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.user_gave_kudos (
    user_id bigint NOT NULL,
    kudos_answer_id bigint NOT NULL,
    kudos_question_id bigint NOT NULL
);


ALTER TABLE public.user_gave_kudos OWNER TO pawan;

--
-- TOC entry 214 (class 1259 OID 16436)
-- Name: user_seen_answers; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.user_seen_answers (
    user_id bigint NOT NULL,
    seen_answer_id bigint NOT NULL
);


ALTER TABLE public.user_seen_answers OWNER TO pawan;

--
-- TOC entry 215 (class 1259 OID 16439)
-- Name: user_seen_question; Type: TABLE; Schema: public; Owner: pawan
--

CREATE TABLE public.user_seen_question (
    user_id bigint NOT NULL,
    seen_question_id bigint NOT NULL
);


ALTER TABLE public.user_seen_question OWNER TO pawan;

--
-- TOC entry 216 (class 1259 OID 16442)
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
-- TOC entry 217 (class 1259 OID 16450)
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
-- TOC entry 2882 (class 2606 OID 16453)
-- Name: users UC_user_email; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UC_user_email" UNIQUE (email);


--
-- TOC entry 2854 (class 2606 OID 16455)
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (answer_id);


--
-- TOC entry 2856 (class 2606 OID 16457)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 2861 (class 2606 OID 16459)
-- Name: follow_question follow_question_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_question
    ADD CONSTRAINT follow_question_pkey PRIMARY KEY (followed_question_id, follower_user_id);


--
-- TOC entry 2864 (class 2606 OID 16461)
-- Name: follow_topic follow_topic_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_topic
    ADD CONSTRAINT follow_topic_pkey PRIMARY KEY (followed_topic_id, follower_user_id);


--
-- TOC entry 2867 (class 2606 OID 16463)
-- Name: follow_user follow_user_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_user
    ADD CONSTRAINT follow_user_pkey PRIMARY KEY (follower_user_id, followed_user_id);


--
-- TOC entry 2869 (class 2606 OID 16465)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- TOC entry 2871 (class 2606 OID 16467)
-- Name: topics topic_name; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topic_name UNIQUE (topic_name);


--
-- TOC entry 2873 (class 2606 OID 16469)
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (topic_id);


--
-- TOC entry 2875 (class 2606 OID 16471)
-- Name: user_gave_kudos user_gave_kudos_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT user_gave_kudos_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2878 (class 2606 OID 16473)
-- Name: user_seen_answers user_seen_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_answers
    ADD CONSTRAINT user_seen_answers_pkey PRIMARY KEY (user_id, seen_answer_id);


--
-- TOC entry 2880 (class 2606 OID 16475)
-- Name: user_seen_question user_seen_question_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_question
    ADD CONSTRAINT user_seen_question_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2884 (class 2606 OID 16477)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2857 (class 1259 OID 16478)
-- Name: fki_answer_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_answer_id ON public.comments USING btree (answer_id);


--
-- TOC entry 2858 (class 1259 OID 16479)
-- Name: fki_follow_question_user_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_follow_question_user_id ON public.follow_question USING btree (follower_user_id);


--
-- TOC entry 2859 (class 1259 OID 16480)
-- Name: fki_question_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_question_id ON public.follow_question USING btree (followed_question_id);


--
-- TOC entry 2862 (class 1259 OID 16481)
-- Name: fki_topic_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_topic_id ON public.follow_topic USING btree (followed_topic_id);


--
-- TOC entry 2876 (class 1259 OID 16482)
-- Name: fki_user_id; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_user_id ON public.user_seen_answers USING btree (user_id);


--
-- TOC entry 2865 (class 1259 OID 16483)
-- Name: fki_user_id1; Type: INDEX; Schema: public; Owner: pawan
--

CREATE INDEX fki_user_id1 ON public.follow_user USING btree (followed_user_id);


--
-- TOC entry 2887 (class 2606 OID 16484)
-- Name: comments answer_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT answer_id FOREIGN KEY (answer_id) REFERENCES public.answers(answer_id);


--
-- TOC entry 2897 (class 2606 OID 16489)
-- Name: user_gave_kudos answer_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT answer_id FOREIGN KEY (kudos_answer_id) REFERENCES public.answers(answer_id);


--
-- TOC entry 2900 (class 2606 OID 16494)
-- Name: user_seen_answers answer_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_answers
    ADD CONSTRAINT answer_id FOREIGN KEY (seen_answer_id) REFERENCES public.answers(answer_id);


--
-- TOC entry 2889 (class 2606 OID 16499)
-- Name: follow_question question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_question
    ADD CONSTRAINT question_id FOREIGN KEY (followed_question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2885 (class 2606 OID 16504)
-- Name: answers question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT question_id FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2898 (class 2606 OID 16509)
-- Name: user_gave_kudos question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT question_id FOREIGN KEY (kudos_question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2902 (class 2606 OID 16514)
-- Name: user_seen_question question_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_question
    ADD CONSTRAINT question_id FOREIGN KEY (seen_question_id) REFERENCES public.questions(question_id);


--
-- TOC entry 2891 (class 2606 OID 16519)
-- Name: follow_topic topic_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_topic
    ADD CONSTRAINT topic_id FOREIGN KEY (followed_topic_id) REFERENCES public.topics(topic_id);


--
-- TOC entry 2895 (class 2606 OID 16524)
-- Name: questions topic_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT topic_id FOREIGN KEY (question_topic_id) REFERENCES public.topics(topic_id);


--
-- TOC entry 2901 (class 2606 OID 16529)
-- Name: user_seen_answers user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_answers
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2903 (class 2606 OID 16534)
-- Name: user_seen_question user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_seen_question
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2890 (class 2606 OID 16539)
-- Name: follow_question user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_question
    ADD CONSTRAINT user_id FOREIGN KEY (follower_user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2893 (class 2606 OID 16544)
-- Name: follow_user user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_user
    ADD CONSTRAINT user_id FOREIGN KEY (follower_user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2899 (class 2606 OID 16549)
-- Name: user_gave_kudos user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.user_gave_kudos
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 2892 (class 2606 OID 16554)
-- Name: follow_topic user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_topic
    ADD CONSTRAINT user_id FOREIGN KEY (follower_user_id) REFERENCES public.users(user_id) NOT VALID;


--
-- TOC entry 2886 (class 2606 OID 16559)
-- Name: answers user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT user_id FOREIGN KEY (answer_poster_id) REFERENCES public.users(user_id);


--
-- TOC entry 2888 (class 2606 OID 16564)
-- Name: comments user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT user_id FOREIGN KEY (comment_poster_id) REFERENCES public.users(user_id);


--
-- TOC entry 2896 (class 2606 OID 16569)
-- Name: questions user_id; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT user_id FOREIGN KEY (question_poster_id) REFERENCES public.users(user_id);


--
-- TOC entry 2894 (class 2606 OID 16574)
-- Name: follow_user user_id1; Type: FK CONSTRAINT; Schema: public; Owner: pawan
--

ALTER TABLE ONLY public.follow_user
    ADD CONSTRAINT user_id1 FOREIGN KEY (followed_user_id) REFERENCES public.users(user_id);


-- Completed on 2020-05-18 14:03:36 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-18 14:03:36 UTC

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

-- Completed on 2020-05-18 14:03:36 UTC

--
-- PostgreSQL database dump complete
--

--
-- Database "test" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-2.pgdg100+1)
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-18 14:03:36 UTC

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

--
-- TOC entry 2902 (class 1262 OID 16384)
-- Name: test; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE test WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';


ALTER DATABASE test OWNER TO postgres;

\connect test

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

-- Completed on 2020-05-18 14:03:37 UTC

--
-- PostgreSQL database dump complete
--

-- Completed on 2020-05-18 14:03:37 UTC

--
-- PostgreSQL database cluster dump complete
--

