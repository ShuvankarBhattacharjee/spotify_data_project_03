-- creating the TABLE spotify 
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
-- see 100 ROWS
select * 
	from spotify
	limit 100;
	
-- checking total number of ROWS
select count(*) from spotify;

-- number of unique artists
select count(distinct artist) from spotify;

-- types of albums
select distinct album_type from spotify;

-- maximum duration & minimum duration 

select max(duration_min) as Max_Duration from spotify;
select min(duration_min) as Min_Duration from spotify;

-- have to check for zero duration song i.e. songs are not available

select * from spotify where duration_min = 0

-- delete zero duration song i.e. songs that are not available

delete from spotify where duration_min = 0

-- number of unique channels
select count(distinct channel) from spotify;

-- unique channels are
select distinct channel from spotify;

-- type of most played on
select distinct most_playedon from spotify;

--------------------------------------------------------------------------------------------------------------------
--                                        INDUSTRY LEVEL QUESTIONS                                                --
--------------------------------------------------------------------------------------------------------------------

--1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT track as Track_Name, stream as Stream_Duration
	FROM spotify
	where stream > '1000000000'
	order by stream desc;

--2. List all albums along with their respective artists.

SELECT distinct album, artist
	from spotify
	order by 1;

--3. Get the total number of comments for tracks where licensed = TRUE.

SELECT 
	sum(cast(Comments as INT)) --as used comments data type as varchar so had to change it into int using cast clause
	FROM spotify
	where Licensed = 'TRUE';

--4. Find all tracks that belong to the album type single.

SELECT distinct track,album_type
	from spotify
	where album_type='single';

--5. Count the total number of tracks by each artist.

select artist, count(track)
	from spotify
	group by 1
	order by 2 desc;

--6. Calculate the average danceability of tracks in each album.

SELECT album, avg(Danceability) as Average_Danceability 
	FROM spotify
	group by 1
	order by 2 desc;

--7. Find the top 5 tracks with the highest energy values.

SELECT track, Energy
	FROM spotify
	order by 2 desc
	limit 5;

--8. List all tracks along with their views and likes where official_video = TRUE.

SELECT track,sum(Views) as Total_Views,sum(Likes) as Total_Likes
	FROM spotify
	where official_video = 'true'
	group by 1
	order by 2 desc;


--9. For each album, calculate the total views of all associated tracks.

SELECT album, sum(views) 
	FROM spotify
	group by 1
	order by 2 desc;

--10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT track, most_playedon 
	FROM spotify
	where
	(select count(most_playedon) from spotify where most_playedon = 'Spotify' ) >  
	(select count(most_playedon) from spotify where most_playedon = 'Youtube' )

--11. Find the top 3 most-viewed tracks for each artist using window functions.
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
--12. Write a query to find tracks where the liveness score is above the average.

select track, Liveness 
from SPOTIFY
where Liveness > (select avg(Liveness) from spotify)


--13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
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

--14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

select track,energy / liveness as Ratio
	from spotify
	where energy / liveness > 1.2
	order by 2 desc

--15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT 
	track, 
	album, 
	views, 
	likes, 
	SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes 
	FROM spotify;
