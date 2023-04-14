-- Zad 1
SELECT 
    UC.pesel, 
    UC.imie,
    UC.nazwisko, 
    UD.kurs 
FROM uczestnicy UC
    LEFT OUTER JOIN udzialy UD
        ON UC.pesel = UD.uczestnik
        
-- Zad 2 A)
SELECT 
       poprzednicy.id,
       poprzednicy.nazwa AS "kurs",
       kursy.id AS "Jest kontunuacja",
       kursy.id AS "id poprzednika",
       kursy.nazwa AS "poprzednik"
FROM   Kursy Kursy
       RIGHT OUTER JOIN Kursy Poprzednicy
               ON kursy.id = poprzednicy.kontynuacja 
               
-- Zad 2 B)
               
SELECT 
       poprzednicy.id,
       poprzednicy.nazwa AS "kurs",
       poprzednicy.kontynuacja AS "kontunuacja",
       kursy.id AS "id poprzednika",
       kursy.nazwa AS "poprzednik"
FROM   Kursy Kursy
       LEFT OUTER JOIN Kursy Poprzednicy
               ON kursy.id = poprzednicy.kontynuacja 
               
-- Zad 3
               
SELECT
        uc.pesel, 
        uc.imie,
        uc.nazwisko 
FROM   uczestnicy UC
       LEFT OUTER JOIN Udzialy UD
            ON uc.pesel = ud.uczestnik 
WHERE ud.uczestnik IS NULL

-- Zad 4

SELECT
        k.id,
        k.nazwa
FROM    kursy K
        LEFT OUTER JOIN kursy K2
            ON K.id = k2.kontynuacja 
WHERE k2.kontynuacja IS NULL

-- Zad 5

SELECT
        ku.id,
        ku.nazwa 
FROM    kursy  KU
        LEFT OUTER JOIN kursykategorie KK
            ON ku.id = kk.kurs
                AND kk.kategoria = '20'
WHERE kk.kategoria  IS NULL

-- Zad 6

SELECT
uc.nazwisko 
FROM kursy K
    JOIN udzialy UD ON k.id = ud.kurs AND k.nazwa LIKE '%Analiza%'
    RIGHT JOIN uczestnicy UC ON uc.pesel = ud.uczestnik 
    WHERE k.nazwa IS NULL
    
-- Zad 7
    
SELECT
o1.id,
o1.numer_raty,
o1.uczestnik,
o1.kwota 
FROM oplaty o1
    LEFT JOIN oplaty o2
        ON o2.kwota > o1.kwota 
WHERE o2.kwota IS NULL

-- Zad 8

SELECT 
       poprzednicy.id,
       poprzednicy.nazwa AS "kurs",
       COALESCE (kursy.nazwa,'kurs bez poprzednika') AS "poprzednik"
FROM   Kursy Kursy
       RIGHT JOIN Kursy Poprzednicy
               ON kursy.id = poprzednicy.kontynuacja 
               
-- Zad 9
               
SELECT
uc.pesel,
uc.imie,
uc.nazwisko,
uc.adres 
FROM oplaty o1
    RIGHT JOIN uczestnicy uc ON o1.uczestnik = uc.pesel
WHERE o1.kwota IS NULL

-- Zad 10

SELECT
uc.nazwisko,
uc.imie,
k.nazwa 
FROM udzialy ud 
          JOIN uczestnicy uc ON ud.uczestnik = uc.pesel
          JOIN kursy K ON ud.kurs = k.id 
    LEFT JOIN oplaty o1 ON ud.uczestnik = o1.uczestnik AND ud.kurs = o1.kurs 
WHERE o1.kwota IS NULL

-- Zad 11

SELECT 
uc.imie,
uc.nazwisko,
kursy.nazwa 
FROM   Kursy Kursy
       RIGHT JOIN Kursy Poprzednicy ON kursy.id = poprzednicy.kontynuacja
       LEFT JOIN udzialy ud ON kursy.id = ud.kurs  
       JOIN uczestnicy uc ON uc.pesel = ud.uczestnik 
WHERE kursy.kontynuacja IS NOT NULL
