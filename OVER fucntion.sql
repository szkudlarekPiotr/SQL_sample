SELECT
	pracownik,
	pensja,
	MAX(pensja) OVER() "total max"
FROM
	Wyplaty;
	
-- Zadanie 1

SELECT
	adres,
	COUNT(adres) OVER() "liczba"
FROM
	uczestnicy
GROUP BY
	adres ;

-- Zadanie 2

SELECT
	id,
	nazwa,
	ROUND(cena / AVG(cena) OVER() * 100,
	2) AS "% średniej"
FROM
	Kursy;

SELECT
	id,
	nazwa,
	ROUND(cena / (
	SELECT
		AVG(cena)
	FROM
		Kursy) * 100,
	2) AS "% średniej"
FROM
	Kursy;

-- Zadanie 3

SELECT
	o.numer_raty,
	u.nazwisko,
	k.nazwa,
	o.kwota,
	SUM(o.kwota) OVER(PARTITION BY ud.uczestnik,
	o.kurs) "Suma uczestnik",
	SUM(o.kwota) OVER(PARTITION BY ud.uczestnik),
	SUM(o.kwota) OVER()
FROM
	uczestnicy u
JOIN udzialy ud ON
	u.pesel = ud.uczestnik
JOIN oplaty o ON
	ud.uczestnik = o.uczestnik
JOIN kursy k ON
	ud.kurs = k.id;

-- Zadanie 4

WITH kurs_cena
AS 
		(
	SELECT
		nazwa,
		cena,
		MAX(cena) OVER() "najdroższy"
	FROM
		kursy)
SELECT
	nazwa,
	cena
FROM
	kurs_cena
WHERE
	cena = "najdroższy";

-- Zadanie 5

SELECT
	o.numer_raty,
	u.nazwisko,
	k.nazwa,
	o.kwota,
	SUM (o.kwota) OVER (
	ORDER BY o.numer_raty) "Suma"
FROM
	uczestnicy u
JOIN oplaty o ON
	u.pesel = o.uczestnik
JOIN kursy k ON 
	o.kurs = k.id
WHERE
	u.nazwisko LIKE 'Malińska'
	AND k.nazwa LIKE 'Analiza danych';

-- Zadanie 6
	
WITH oszczednosci_stef
AS
	(
	SELECT
		"data",
		SUM(pensja * 0.1) OVER (
	ORDER BY
		rok,
		miesiac) "oszczednosci"
	FROM
		wyplaty w
	WHERE
		pracownik LIKE 'Stefan'
		AND "data" >= '2017-01-01')
SELECT
	*
FROM
	oszczednosci_stef
WHERE
	"oszczednosci" >= 3000
LIMIT 1;

-- Zadanie 7

SELECT
	rok,
	temp_f,
	ROUND(AVG(temp_f) OVER (
ORDER BY
	rok ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)::NUMERIC,
	3)
FROM
	nowyjork
ORDER BY
	rok
LIMIT 20

-- Zadanie 8

WITH ceny_kursy 
AS 
	(SELECT 
	cena,
	ROW_NUMBER() OVER(PARTITION BY cena) "nr_wierszy"
	FROM kursy)
SELECT cena FROM ceny_kursy WHERE "nr_wierszy" >1;

-- Zadanie 9

?????????????????

-- Zadanie 10

WITH ukonczone_kursy
AS
	(
SELECT
	u.imie,
	u.nazwisko,
	ud.punkty
FROM
	uczestnicy u
JOIN udzialy ud ON
	u.pesel = ud.uczestnik
WHERE
	ud.status LIKE 'ukonczony'
ORDER BY
	punkty)
SELECT
	*,
	RANK() OVER(
ORDER BY
	punkty DESC),
	DENSE_RANK() OVER(
ORDER BY
	punkty DESC)
FROM
	ukonczone_kursy
	
-- Zadanie 11
	
WITH wyplty_pracownik
AS
	(
SELECT
	pracownik,
	pensja,
	DENSE_RANK() OVER(PARTITION BY pracownik
ORDER BY
	pensja DESC) "top_wyplaty"
FROM
	wyplaty)
SELECT
	DISTINCT pracownik,
	pensja
FROM
	wyplty_pracownik
WHERE
	"top_wyplaty" <= 2
ORDER BY
	pracownik,
	pensja DESC
	
-- Zadanie 12

WITH mediana
AS 
	(SELECT punkty, NTILE(2) OVER(PARTITION BY punkty) "mediana" FROM udzialy WHERE status LIKE 'ukonczony')
SELECT punkty FROM mediana WHERE "mediana" = 2

-- Zadanie 13

WITH numbered_rows AS (
  SELECT *, ROW_NUMBER() OVER (ORDER BY rok) AS row_number
  FROM NowyJork
),
islands AS (
  SELECT rok, row_number - ROW_NUMBER() OVER (ORDER BY rok) AS group_number
  FROM numbered_rows
)
SELECT MIN(rok) AS początek, MAX(rok) AS koniec
FROM (
  SELECT rok, group_number, 
         ROW_NUMBER() OVER (PARTITION BY group_number ORDER BY rok) AS island_number
  FROM islands
) subquery
GROUP BY group_number, rok - island_number
ORDER BY MIN(rok);

-- Zadanie 14

WITH ile_zmian
AS
	(SELECT  pracownik, pensja,
	DENSE_RANK() OVER(PARTITION BY pracownik ORDER BY pensja)"zmiany"
	FROM wyplaty )
SELECT pracownik, MAX("zmiany") -1 AS "ile zmian" FROM ile_zmian GROUP BY pracownik

-- Zadanie 15

WITH lata
AS
(
SELECT
	rok,
	LEAD(rok) OVER() "nastepny"
FROM
	nowyjork)
SELECT
	"nastepny"+(rok-"nastepny"+1) AS "początek",
	rok+("nastepny" - rok -1) AS "koniec"
FROM
	lata
WHERE
	"nastepny" - rok > 1
	
-- Zadanie 16
	
SELECT DISTINCT pracownik,
       LAST_VALUE (pensja) OVER (PARTITION BY pracownik ORDER BY data ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "wartosc ostatniej wyplaty",
       LAST_VALUE (data)   OVER (PARTITION BY pracownik ORDER BY data ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "data ostatniej wyplaty"
FROM Wyplaty;

-- Zadanie 17

WITH ukonczone_kursy
AS
	(
SELECT
	u.imie,
	u.nazwisko,
	ud.punkty
FROM
	uczestnicy u
JOIN udzialy ud ON
	u.pesel = ud.uczestnik
ORDER BY
	punkty)
SELECT imie, nazwisko, punkty, PERCENT_RANK() OVER(ORDER BY punkty DESC) "perc",
CUME_DIST() OVER(ORDER BY punkty DESC) "cume"
FROM ukonczone_kursy
WHERE punkty IS NOT NULL 


SELECT
  punkty,
  PERCENT_RANK() OVER(ORDER BY punkty DESC) "PercentRank",
  ((RANK() OVER(ORDER BY punkty DESC)) - 1) / (COUNT(*) OVER()) "rk-1)/(nr-1",
  CUME_DIST() OVER(ORDER BY punkty DESC) "CumeDistr",
  COUNT(*) OVER(ORDER BY punkty DESC) / COUNT(*) OVER() "np/nr"
FROM Udzialy;
