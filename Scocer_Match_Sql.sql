--------------------------------------Scoccer Match--------------------------------------------
--https://stackoverflow.com/questions/58228944/how-do-i-crack-this-sql-soccer-matches-assignment-----
--https://app.datacamp.com/workspace/w/21c61079-0787-42ae-b21d-ae7ff127d556--------------------------


------------------Import table-------------------------
CREATE TABLE teams(
team_id int PRIMARY KEY,
team_name varchar(30) Not Null
);

INSERT INTO teams(team_id, team_name)
VALUES (10, 'Give'),
		(20, 'Never'),
		(30, 'You'),
		(40, 'up'),
		(50, 'Gonna');

CREATE TABLE matches(
match_id int PRIMARY KEY,
host_team int NOT NULL,
guest_team int NOT NULL,
host_goals int NOT NULL,
guest_goals int NOT NULL,
);

INSERT INTO matches(match_id, host_team, guest_team, host_goals, guest_goals)
VALUES (1, 30, 20, 1, 0),
		(2, 10, 20, 1, 2),
		(3, 20, 50, 2, 2),
		(4, 10, 30, 1, 0),
		(5, 30, 50, 0, 1);

SELECT *
FROM matches;

--------------Solution---------------------------------
WITH cteHostPoint AS(SELECT host_team AS Team,
							CASE
								WHEN host_goals > guest_goals THEN 3
								WHEN host_goals < guest_goals THEN 1
								ELSE 0
							END AS Point
					 FROM matches),
	cteGuestPoint AS(SELECT guest_team AS Team,
							CASE
								WHEN guest_goals > host_goals THEN 3
								WHEN guest_goals < host_goals THEN 1
								ELSE 0
							END AS Point
					FROM matches),
	cteAllPoint AS(SELECT Team, Point 
				   FROM cteHostPoint
				   UNION ALL
				   SELECT Team, Point
				   FROM cteGuestPoint)
SELECT t.team_id, t.team_name, COALESCE(SUM(ap.Point), 0) AS Total_Point
FROM teams t
LEFT JOIN cteAllPoint ap ON ap.Team = t.team_id
GROUP BY t.team_id, t.team_name
ORDER BY COALESCE(SUM(ap.Point), 0) DESC, t.team_id
