-- Zad 1 A)

SELECT
K.id AS "Kurs ID", 
K.nazwa AS "Kurs nazwa",
K.wykladowca AS "Kurs id wykladowcy",
W.id AS "Wykladowca id",
W.nazwisko AS "Wykladowca nazwa"
FROM Kursy K
CROSS JOIN wykladowcy W

-- Zad 1 B)

SELECT
K.id AS "Kurs ID", 
K.nazwa AS "Kurs nazwa",
K.wykladowca AS "Kurs id wykladowcy",
W.id AS "Wykladowca id",
W.nazwisko AS "Wykladowca nazwa"
FROM Kursy K
CROSS JOIN wykladowcy W
WHERE K.nazwa LIKE '%Access%'

-- Zad 2

SELECT
K.id AS "Kurs ID", 
K.nazwa AS "Kurs nazwa",
K.wykladowca AS "Kurs id wykladowcy",
W.id AS "Wykladowca id",
W.nazwisko AS "Wykladowca nazwa"
FROM Kursy K
    INNER JOIN wykladowcy W


-- Zad 3
    
SELECT 
UD.kurs,
UD.data_udzial 
FROM uczestnicy UC
    INNER JOIN udzialy UD
        ON UC.pesel = UD.uczestnik 
WHERE UC.pesel = '78020806063'

-- Zad 4

SELECT 
KU.id,
KU.nazwa,
KA.nazwa
FROM kursy KU
    INNER JOIN kursykategorie KK
        ON KU.id = KK.kurs
    INNER JOIN kategorie KA
        ON KK.kategoria  = KA.id

-- Zad 5

SELECT 
o.id,
o.kwota,
uc.imie,
uc.nazwisko,
k.nazwa 
FROM oplaty O
    INNER JOIN uczestnicy UC
        ON o.uczestnik = uc.pesel 
    INNER JOIN kursy K
        ON o.kurs = k.id
ORDER BY uc.imie, uc.nazwisko 

-- Zad 6

SELECT 
uc.imie,
uc.nazwisko
FROM udzialy UD
    INNER JOIN uczestnicy UC
        ON ud.uczestnik = uc.pesel 
    INNER JOIN kursy K
        ON ud.kurs = k.id 
WHERE ud.status = 'ukonczony' AND k.nazwa = 'Analiza danych'

-- Zad 7

SELECT 
       poprzednicy.id,
       poprzednicy.nazwa AS "kurs",
       kursy.id AS "Jest kontunuacja",
       kursy.id AS "id poprzednika",
       kursy.nazwa AS "poprzednik"
FROM   Kursy Kursy
       INNER JOIN Kursy Poprzednicy
               ON kursy.id = poprzednicy.kontynuacja 

-- Zad 8
               
SELECT 
u1.imie AS "imie1",
u1.nazwisko AS "nazwisko1",
u2.imie AS "imie2",
u2.nazwisko AS "nazwisko2",
u2.adres 
FROM uczestnicy U1
    INNER JOIN uczestnicy U2
        ON u1.adres = u2.adres 
            AND u1.pesel > u2.pesel 
            
-- Zad 9

SELECT
u2.imie,
u2.nazwisko 
FROM udzialy ud
    JOIN uczestnicy uc
        ON uc.pesel = ud.uczestnik
            AND uc.nazwisko = 'Malińska'
    JOIN udzialy ud2
        ON ud2.kurs = ud.kurs  
    JOIN uczestnicy u2
        ON u2.pesel = ud2.uczestnik 
            AND u2.nazwisko != 'Malińska'
-- Zad 10
            
SELECT 
u.nazwisko,
u.pesel, 
u2.nazwisko,
u2.pesel 
FROM uczestnicy u
    JOIN uczestnicy U2
        ON u.pesel > u2.pesel
            AND u.nazwisko = u2.nazwisko 

-- Zad 11
            
SELECT 
k.id ,
k.nazwa,
k.liczba_dni 
FROM kursy K
    JOIN kursy K2
        ON k2.nazwa LIKE 'MS Access dla %'
            AND k2.liczba_dni > k.liczba_dni
            
-- Zad 12

SELECT DISTINCT 
o.id,
o.numer_raty,
o.kwota,
o.uczestnik,
o.kurs 
FROM oplaty O
    JOIN oplaty O2
        ON o2.numer_raty > o.numer_raty 
            AND o.uczestnik = o2.uczestnik 
            AND o.kurs  = o2.kurs 
        
-- Zad 13
            
SELECT DISTINCT 
k.id,
k.nazwa 
FROM kursy k
    JOIN udzialy u
        ON  k.id = u.kurs 
           
-- Zad 14
        
SELECT 
*
FROM oplaty NATURAL JOIN  udzialy

--

SELECT
*
FROM oplaty JOIN udzialy USING (uczestnik,kurs)

--

SELECT
*
FROM oplaty o
    JOIN udzialy u 
        ON o.uczestnik = u.uczestnik AND o.kurs = u.kurs 
        
-- Zad 15
        
SELECT 
k.nazwa 
FROM kursy k
    JOIN wykladowcy w
        ON k.wykladowca = w.id
            AND w.nazwisko = 'Stachowiak'
            
-- Zad 16
            
SELECT 
o.id,
o.kwota,
k.nazwa,
k.cena 
FROM oplaty o
    JOIN kursy k 
        ON o.kwota = k.cena 
            AND o.kurs = k.id
            
-- Zad 17

SELECT
k.id,
k.nazwa 
FROM udzialy u
    JOIN uczestnicy uc
        ON u.uczestnik = uc.pesel 
            AND uc.pesel = '78020806063'
    JOIN kursy k 
        ON u.kurs = k.id
    
-- Zad 18

SELECT
k2.id,
k2.nazwa,
k2.cena,
k1.cena AS "Cena VBA"
FROM kursy k1
    JOIN kursy k2
        ON k2.cena > k1.cena 
            AND k1.nazwa LIKE 'Programowanie VBA%'
                    
-- Zad 20
             
SELECT 
uc.imie ,
uc.nazwisko 
FROM udzialy ud
    JOIN uczestnicy uc
        ON ud.uczestnik  = uc.pesel 
    JOIN udzialy ud2
        ON ud.kurs = '303' AND ud2.kurs = '707'
            
            