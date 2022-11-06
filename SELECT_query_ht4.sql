--количество исполнителей в каждом жанре
select g.genre_name, count(ga.artistid) coun from genre g
join genre_artist ga on g.id = ga.genreid
group by g.genre_name
order by coun desc;

--количество треков, вошедших в альбомы 2019-2020 годов
select count(t.id) from track t
join album a on t.albumid = a.id
where a.album_year between '2019-01-01' and '2020-12-31';

--средняя продолжительность треков по каждому альбому
select a.album_name, avg(t.duration)from track t
join album a on t.albumid = a.id
GROUP by a.album_name;

--все исполнители, которые не выпустили альбомы в 2020 году - чувствую, что запрос не самыый оптимальный=)
select a.artist_name from artist a
join artist_album aa on a.id = aa.artist_id 
join album a2 on aa.album_id = a2.id 
where a.artist_name != (select a.artist_name from artist a join artist_album aa on a.id = aa.artist_id join album a2 on aa.album_id = a2.id 
where a2.album_year between '2020-01-01' and '2020-12-31')
GROUP by a.artist_name;

--названия сборников, в которых присутствует конкретный исполнитель (Кино)
select c.collection_name from collection c 
join track t on c.id = t.collectionid 
join artist_album aa2 on t.albumid = aa2.album_id 
join artist a3 on aa2.artist_id = a3.id 
where a3.artist_name = 'Кино'
GROUP by c.collection_name;

--название альбомов, в которых присутствуют исполнители более 1 жанра
select a.album_name, count(ga.artistid) from album a  
join artist_album aa on a.id = aa.album_id  
join genre_artist ga on aa.artist_id = ga.artistid 
group by a.album_name
having count(ga.artistid) > 1
order by count(ga.artistid) desc;

--наименование треков, которые не входят в сборники
select track_name from track t  
where t.collectionid is null;

--исполнителя, написавшего самый короткий по продолжительности трек
select a.artist_name, min(t.duration) mind_d from artist a
join artist_album aa on a.id = aa.artist_id 
join album a2 on aa.album_id = a2.id 
join track t on a2.id = t.albumid
where t.duration <= (select min(duration) from track)
GROUP by a.artist_name
order by mind_d;

--название альбомов, содержащих наименьшее количество треков
select ad.album_name, min(vog) minim from (select a.album_name, count(t.albumid) vog from album a 
join track t on a.id = t.albumid
GROUP by a.album_name
order by vog) as ad
where vog <= (select min(vog) from (select a.album_name, count(t.albumid) vog from album a 
join track t on a.id = t.albumid
GROUP by a.album_name
order by vog) as bb)
GROUP by album_name
order by min(vog)
;