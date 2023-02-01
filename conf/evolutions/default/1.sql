-- users schema
-- !Ups
CREATE TABLE
  users (
    id bigserial NOT NULL,
    email varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    screen_name varchar(255) NOT NULL,
    PRIMARY KEY (id)
  );

-- !Downs
DROP TABLE users;
