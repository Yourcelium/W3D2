DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;



PRAGMA foreign_keys = ON;


CREATE TABLE user (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES user(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  questions_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES user(id)

);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES user(id));


INSERT INTO 
  user (fname, lname)
VALUES
  ('bob', 'hope'),
  ('sand', 'man'),
  ('jane', 'doe'),
  ('bruce', 'willis'),
  ('whoopie', 'goldberg');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('sleeping?', 'who is asleep?', 2),
  ('how''s life?', 'New here, looking for new diggs', 3),
  ('q3', 'q3 body', 2),
  ('q4', 'q4 body', 2),
  ('q5', 'q5 body', 3),
  ('q6', 'q6 body', 1);

INSERT INTO 
  question_follows (questions_id, user_id)
VALUES
  (2, 2),
  (1, 3),
  (1, 3),
  (2, 3),
  (1, 2),
  (1, 3),
  (3, 2);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (2, null, 1, 'I might have a bungalow near my pool'),
  (4, null, 2, 'Me too'),
  (2, null, 1, 'Sounds like a deal'),
  (2, 2, 2, 'Sorry i don''t take in does'),
  (5, null, 1, 'ok sure thing'),
  (2, null, 3, 'Nope');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2, 1),
  (3, 1),
  (4, 1),
  (5, 1),
  (4, 2),
  (5, 3),
  (5, 2);












