-- Zadanie 1

WITH gatunki AS(
SELECT
		a2."name" ,
	count(DISTINCT g."name") AS "liczba"
FROM
		track t
JOIN genre g ON
		g.genreid = t.genreid
JOIN album a ON 
		t.albumid = a.albumid
JOIN artist a2 ON 
		a.artistid = a2.artistid
GROUP BY
	a2."name"
ORDER BY
	"liczba" DESC 
)
SELECT
	"name" AS "wykonawca_name",
	"liczba" AS "liczba_gatunków_muzycznych",
	DENSE_RANK() OVER(
	ORDER BY "liczba" DESC) AS "Ranking"
FROM
	gatunki
	
-- Zadanie 2
	
WITH srednie_miesiace AS (
SELECT
		EXTRACT ('Year'
FROM
	invoicedate) AS "Rok",
		EXTRACT ('Month'
FROM
	invoicedate) AS "Miesiac",
		avg(total) AS "Srednia"
FROM
		invoice i
GROUP BY
	"Rok",
	"Miesiac"
ORDER BY 
	"Rok",
	"Miesiac"
)
SELECT
	"Rok",
	"Miesiac",
	"Srednia", 
	LAG("Srednia") OVER(PARTITION BY "Rok")
FROM
	srednie_miesiace

-- Zadanie 3
	
WITH customers_total AS(
	SELECT
		DISTINCT c.firstname,
		c.lastname ,
		SUM(total) OVER(PARTITION BY i.customerid) "total"
	FROM
		invoice i
	JOIN customer c ON
		i.customerid = c.customerid
	ORDER BY
		"total" DESC
)
SELECT DISTINCT * FROM customers_total
ORDER BY "total" DESC LIMIT 10

-- Zadanie 4

WITH kraje_wydatki AS(
SELECT
	i.billingcountry,
	SUM(total) AS "total"
FROM
	invoice i
GROUP BY
	i.billingcountry 
)
SELECT
	billingcountry,
	ROUND(kraje_wydatki."total"  /(
	SELECT
		SUM("total")
	FROM
		kraje_wydatki) * 100, 1) AS "%"
FROM
	kraje_wydatki
ORDER BY
	"%" DESC
	
-- Zadanie 5
WITH ilosci AS(
SELECT
	DISTINCT  
		g."name" AS "gatunek",
		m."name" AS "typ_pliku",
		count(m."name") OVER(PARTITION BY m.name) "ilosc_utworow",
		COUNT(*) OVER() "total",
		count(m."name") OVER(PARTITION BY m.name) / COUNT(*) OVER()::NUMERIC AS "percent",
		COUNT(g."name") OVER(PARTITION BY g.name,m."name" ORDER BY g."name") "ilosc_gatunek",
		COUNT(g."name") OVER(PARTITION BY g.name,m."name" ORDER BY g."name")/ COUNT(*) OVER()::NUMERIC AS "format_gatunek"
FROM
		invoiceline i
JOIN track t ON
		i.trackid = t.trackid
JOIN genre g ON
		t.genreid = g.genreid
JOIN mediatype m ON
		t.mediatypeid = m.mediatypeid
ORDER BY
	count(m."name") OVER(PARTITION BY m.name) DESC
)
SELECT
	"gatunek" AS "nazwa_gatunek",
	"typ_pliku" AS "nazwa_format",
	"ilosc_utworow" AS "ilosc_utworow_format",
	round(100 * "percent",
	2) AS "%_format",
	"ilosc_gatunek" AS "ilosc_utworow_format_gatunek",
	ROUND(100*"format_gatunek",2) AS "%_format_gatunek"
FROM
	ilosci
ORDER BY "ilosc_gatunek" DESC 

-- Zadanie 6

WITH numerki AS(
SELECT
		DISTINCT
		m."name" AS "typ_pliku",
		AVG((bytes::decimal / 1024)/(milliseconds::decimal / 1000)) OVER(PARTITION BY m."name") "n1",
		g.name AS "gatunek",
		AVG((bytes::numeric / 1024)/(milliseconds::numeric / 1000)) OVER(PARTITION BY g."name") "n2",
		AVG((bytes::numeric / 1024)/(milliseconds::numeric / 1000)) OVER(PARTITION BY m.name,
	g."name") "n3"
FROM
		invoiceline i
JOIN track t ON
		t.trackid = i.trackid
JOIN genre g ON
		t.genreid = g.genreid
JOIN mediatype m ON
		t.mediatypeid = m.mediatypeid
)
SELECT
	"typ_pliku",
	round("n1",
	2) AS "sredni_bitrate_format",
	"gatunek",
	round("n2",
	2) AS "sredni_bitrate_gatunek",
	ROUND("n3",
	2) AS "sredni_bitrate_format_gatunek"
FROM
	numerki
ORDER BY
	"typ_pliku"

	
-- Zadanie 8

WITH customers AS (
SELECT DISTINCT customer.customerid AS "customer"
FROM
	customer
JOIN invoice ON
	customer.customerid = invoice.customerid
JOIN invoiceline ON
	invoice.invoiceid = invoiceline.invoiceid
JOIN track ON
	invoiceline.trackid = track.trackid
JOIN album ON
	track.albumid = album.albumid
JOIN artist ON
	album.artistid = artist.artistid
WHERE
	artist.name::TEXT = 'Miles Davis'::TEXT
 )
SELECT DISTINCT 
	a."name",
	COUNT(*) OVER(PARTITION BY a."name") "ile_utworow"
FROM
	customers c
JOIN invoice i ON
	c."customer" = i.customerid
JOIN invoiceline inv ON
	inv.invoiceid = i.invoiceid
JOIN track t ON
	t.trackid = inv.trackid
JOIN album al ON
	t.albumid = al.albumid
JOIN artist a ON
	a.artistid = al.artistid
WHERE
	a.name != 'Miles Davis'
ORDER BY
	"ile_utworow" DESC
LIMIT 1
 
 -- Zadanie 9

WITH sprzedaz AS(
SELECT
	DISTINCT
		EXTRACT('Year'
FROM
		i.invoicedate) AS "rok",
		EXTRACT('Month'
FROM
		i.invoicedate) AS "miesiac",
		c.supportrepid "id_sprzedawca",
		e.firstname AS "imie",
		e.lastname AS "nazwisko",
		SUM(total) OVER(PARTITION BY c.supportrepid ,
		EXTRACT('Year'
FROM
		i.invoicedate),
		EXTRACT('Month'
FROM
		i.invoicedate)) "suma"
FROM
		invoice i
JOIN customer c ON
		i.customerid = c.customerid
JOIN employee e ON
		c.supportrepid = e.employeeid
ORDER BY
		"rok",
	"miesiac",
	"suma" DESC
),
najlepsza_sprzedaz as(
	SELECT *,
		RANK() OVER(PARTITION BY "rok","miesiac" ORDER BY "suma" DESC) "najlepszy"
	FROM
		sprzedaz
	ORDER BY "rok", "miesiac"
)
SELECT 	"rok",
		"miesiac",
		"id_sprzedawca",
		"imie",
		"nazwisko",
		"suma" FROM najlepsza_sprzedaz WHERE "najlepszy" = 1