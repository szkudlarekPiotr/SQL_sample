-- Zad 4
SELECT nazwa,
LENGTH(nazwa) AS "liczba znakow"
FROM kategorie 

-- Zad 5
SELECT id, nazwa,
ROUND(cena / liczba_dni, 2)
FROM kursy 

-- Zad 6
SELECT uczestnik, kurs,
AGE('2020-12-01', data_udzial) AS "roznica"
FROM udzialy 

-- Zad 7
SELECT id, nazwa,
COALESCE(ROUND(cena / liczba_dni, 2), cena) AS "kwota za dzien"
FROM kursy

-- Zad 8
SELECT uczestnik, kurs,
100 - COALESCE(punkty, 0) AS "ile do 100 pkt."
FROM udzialy 

-- Zad 9
SELECT CAST(2.0/4 AS NUMERIC(2,2))

-- Zad 10
SELECT DISTINCT status
FROM   Udzialy;

-- Zad 11
SELECT uczestnik, kurs,
COALESCE (punkty, 0) AS "punkty"
FROM udzialy 
ORDER BY punkty, uczestnik DESC

-- Zad 12
SELECT uczestnik, kurs, data_udzial
FROM udzialy 
ORDER BY data_udzial 
LIMIT 1

-- Zad 13
SELECT id, numer_raty, uczestnik, kurs, kwota
FROM oplaty 
WHERE kurs IN (101,202)
      AND kwota <= 1000
      
-- Zad 14
SELECT nazwa FROM kursy
WHERE nazwa LIKE '%Access%'

-- Zad 15
SELECT uczestnik, kurs, data_udzial, status, punkty
FROM   udzialy
WHERE  punkty IS NULL;

-- Zad 16
SELECT id, nazwa,
COALESCE (ROUND(cena / liczba_dni,2), cena) AS "kwota za dzien"
FROM kursy
WHERE COALESCE (cena / liczba_dni, cena) > 1000

-- Zad 17
SELECT id,
       nazwa,
       liczba_dni,
       CASE WHEN liczba_dni >= 3         THEN 'długi'
            WHEN liczba_dni < 3          THEN 'krótki'
            ELSE                         'nieznana'
       END AS "długość kursu"
FROM   Kursy;








