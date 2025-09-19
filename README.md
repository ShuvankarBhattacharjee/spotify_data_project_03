# **PROJECT SPOTIFY LISTEN MUSIC BEFIKAR**
![Spotify Logo](https://github.com/ShuvankarBhattacharjee/spotify_data_project_03/blob/main/ogp7i0fc_spotify-erhht-im-sommer-2025-erneut-die-preise-jhrlich-wird-das-zur-regel_625x300_30_April_25.jpg)


**Project data source - https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset**

**Overview**<br>
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using SQL. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

**Project Steps**<br>
**1. Data Exploration**
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:<br>
Artist: The performer of the track.<br>
Track: The name of the song.<br>
Album: The album to which the track belongs.<br>
Album_type: The type of album (e.g., single or album).<br>
Various metrics such as danceability, energy, loudness, tempo, and more.<br>

**4. Querying the Data**<br>
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into easy, medium, and advanced levels to help progressively develop SQL proficiency.
Easy Queries
Simple data retrieval, filtering, and basic aggregations.
Medium Queries
More complex queries involving grouping, aggregation functions, and joins.
Advanced Queries
Nested subqueries, window functions, CTEs, and performance optimization.<br>
**5. Query Optimization**<br>
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
Indexing: Adding indexes on frequently queried columns.
Query Execution Plan: Using EXPLAIN ANALYZE to review and refine query performance.


**Query Optimization Technique**<br>
To improve query performance, we carried out the following optimization process:
Initial Query Performance Analysis Using EXPLAIN<br>
We began by analyzing the performance of a query using the EXPLAIN function.<br>
The query retrieved tracks based on the artist column, and the performance metrics were as follows:<br>
Execution time (E.T.): 7 ms
Planning time (P.T.): 0.17 ms

**SQL command for creating the index:**
```
CREATE INDEX idx_artist ON spotify_tracks(artist);
```
Performance Analysis After Index Creation
After creating the index, we ran the same query again and observed significant improvements in performance:
Execution time (E.T.): 0.153 ms
Planning time (P.T.): 0.152 ms<br><br><br>


This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
Technology Stack<br>
Database: PostgreSQL<br>
SQL Queries: DDL, DML, Aggregations, Joins, Subqueries, Window Functions<br>
Tools: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)<br>

**How to Run the Project**<br>
Install PostgreSQL and pgAdmin (if not already installed).<br>
Set up the database schema and tables using the provided normalization structure.<br>
Insert the sample data into the respective tables.<br>
Execute SQL queries to solve the listed problems.<br>
Explore query optimization techniques for large datasets.<br>

**Next Steps**<br>
Visualize the Data: Use a data visualization tool like Tableau or Power BI to create dashboards based on the query results.
Expand Dataset: Add more rows to the dataset for broader analysis and scalability testing.
Advanced Querying: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.


**-- creating the TABLE spotify**
```
DROP TABLE if exists spotify;
CREATE table spotify
(


Artist	varchar(255),
Track	varchar(255),
Album	varchar(255),
Album_type	varchar(255),
Danceability	float,
Energy	float,
Loudness	float,	
Speechiness	float,
Acousticness	float,
Instrumentalness	float,
Liveness	float,
Valence	float,
Tempo	float,
Duration_min	float,
Title	varchar(255),
Channel	varchar(255),
Views	BIGINT,	
Likes	BIGINT,
Comments	varchar(255),
Licensed	boolean,
official_video	boolean,
Stream BIGINT,
EnergyLiveness	float,
most_playedon varchar(255)


);
```
**see 100 ROWS**
```
select * 
	from spotify
	limit 100;
```
**checking total number of ROWS**
```
select count(*) from spotify;
```

**number of unique artists**
```
select count(distinct artist) from spotify;
```

**types of albums**
```
select distinct album_type from spotify;
```

**maximum duration & minimum duration**<br>

```
select max(duration_min) as Max_Duration from spotify;
select min(duration_min) as Min_Duration from spotify;
```

**have to check for zero duration song i.e. songs are not available**
```
select * from spotify where duration_min = 0
```

**delete zero duration song i.e. songs that are not available**
```
delete from spotify where duration_min = 0
```

**number of unique channels**
```
select count(distinct channel) from spotify;
```

**unique channels are**
```
select distinct channel from spotify;
```

**type of most played on**
```
select distinct most_playedon from spotify;
```

**--------------------------------------------------------------------------------------------------------------------
--                                        INDUSTRY LEVEL QUESTIONS                                                --
--------------------------------------------------------------------------------------------------------------------**


**1. Retrieve the names of all tracks that have more than 1 billion streams.**
```
SELECT track as Track_Name, stream as Stream_Duration
	FROM spotify
	where stream > '1000000000'
	order by stream desc;
```

**2. List all albums along with their respective artists.**
```
SELECT distinct album, artist
	from spotify
	order by 1;
```

**3. Get the total number of comments for tracks where licensed = TRUE.**
```
SELECT 
	sum(cast(Comments as INT)) --as used comments data type as varchar so had to change it into int using cast clause
	FROM spotify
	where Licensed = 'TRUE';
```

**4. Find all tracks that belong to the album type single.**
```
SELECT distinct track,album_type
	from spotify
	where album_type='single';
```

**5. Count the total number of tracks by each artist.**
```
select artist, count(track)
	from spotify
	group by 1
	order by 2 desc;
```

**6. Calculate the average danceability of tracks in each album.**
```
SELECT album, avg(Danceability) as Average_Danceability 
	FROM spotify
	group by 1
	order by 2 desc;
```

**7. Find the top 5 tracks with the highest energy values.**
```
SELECT track, Energy
	FROM spotify
	order by 2 desc
	limit 5;
```

**8. List all tracks along with their views and likes where official_video = TRUE.**
```
SELECT track,sum(Views) as Total_Views,sum(Likes) as Total_Likes
	FROM spotify
	where official_video = 'true'
	group by 1
	order by 2 desc;
```
**9. For each album, calculate the total views of all associated tracks.**
```
SELECT album, sum(views) 
	FROM spotify
	group by 1
	order by 2 desc;
```
**10. Retrieve the track names that have been streamed on Spotify more than YouTube.**
```
SELECT track, most_playedon 
	FROM spotify
	where
	(select count(most_playedon) from spotify where most_playedon = 'Spotify' ) >  
	(select count(most_playedon) from spotify where most_playedon = 'Youtube' )
```

**11. Find the top 3 most-viewed tracks for each artist using window functions.**
```
with ranking_artist
as
(select 
	artist, 
	track, 
	sum(views),
	DENSE_RANK() OVER(partition by artist order by sum(views) desc) as rank
	from spotify
	group by 1,2
	order by 1,3 desc
)
select * from ranking_artist
where rank <= 3
```
**12. Write a query to find tracks where the liveness score is above the average.**
```
select track, Liveness 
from SPOTIFY
where Liveness > (select avg(Liveness) from spotify)
```
**13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```
with cte
as
(select 
	album,
	max(Energy) as Maximum_Energy,
	min(Energy) as Lowest_Energy
	from spotify
	group by 1
)
select 
	album, 
	Maximum_Energy - Lowest_Energy as Energy_Difference
from cte
order by 2 desc
```

**14. Find tracks where the energy-to-liveness ratio is greater than 1.2.**
```
select track,energy / liveness as Ratio
	from spotify
	where energy / liveness > 1.2
	order by 2 desc
```
**15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.**
```
SELECT 
	track, 
	album, 
	views, 
	likes, 
	SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes 
	FROM spotify;
```





