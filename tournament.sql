--The housecleaning is necessary to ensure that we start with clean database
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;
--Creating table for registered players
create table players (
                      id        serial primary key,
                      name      text);
--Creating table for tracking who is winners and losers, unfortunately...
create table match (
                    match_id   serial primary key,
                    winner     int references players(id),
                    loser      int references players(id)
                  );
create view standings as
--http://stackoverflow.com/questions/29936536/how-to-count-two-separate-columns-in-the-same-table-and-sum-them-into-a-new-colu
                  SELECT    id, name,
                            COUNT(CASE id WHEN winner THEN 1 ELSE NULL END) AS wins,
                            COUNT(match_id) AS matches
                  FROM      players
                  LEFT JOIN match ON id IN (winner, loser)
                  GROUP BY  id, name;