-- Zad 1

SELECT ROUND(AVG(kwota), 2) AS "średnia oplata", COUNT(*) AS "liczba opłat"
FROM oplaty
WHERE kurs IN (SELECT id
FROM kursy
WHERE nazwa LIKE 'Analiza danych')

-- Zad 2
            
SELECT id, nazwa, cena
FROM kursy
WHERE cena = (SELECT MAX(cena)
FROM Kursy)

-- Zad 3

SELECT imie, nazwisko
FROM uczestnicy
WHERE pesel = (SELECT uczestnik
FROM oplaty
WHERE kwota = (SELECT MAX(kwota)
FROM oplaty))

-- Zad 4
                
SELECT u.uczestnik, u.kurs, u.punkty
FROM udzialy u
WHERE u.punkty = (SELECT max(u2.punkty)
FROM udzialy u2
WHERE u2.uczestnik = u.uczestnik)

-- Zad 5
                        
SELECT COUNT(DISTINCT status)
FROM udzialy

-- Zad 6

SELECT uczestnik , MIN(kwota), MAX(kwota)
FROM oplaty
GROUP BY uczestnik

-- Zad 7


SELECT u.pesel, u.imie, u.nazwisko, k.nazwa, "SUMA"
FROM(SELECT uczestnik, kurs, SUM(kwota) AS "SUMA"
FROM oplaty
GROUP BY uczestnik, kurs) AS a
JOIN uczestnicy u ON
u.pesel = a.uczestnik
JOIN kursy k ON
k.id = a.kurs

-- Zad 8

SELECT uczestnicy.pesel, uczestnicy.imie, uczestnicy.nazwisko, COUNT(oplaty.kwota)
FROM oplaty
RIGHT JOIN uczestnicy ON
pesel = uczestnik
GROUP BY uczestnicy.pesel, uczestnicy.nazwisko, uczestnicy.imie

-- Zad 9

SELECT pesel, imie, nazwisko, COUNT(DISTINCT oplaty.kurs)
FROM uczestnicy
RIGHT JOIN oplaty ON
pesel = oplaty.uczestnik
WHERE adres LIKE 'Poznań'
GROUP BY pesel, imie, nazwisko
HAVING COUNT(DISTINCT oplaty.kurs) > 1

-- Zad 10

SELECT nazwisko, COUNT(*)
FROM uczestnicy
WHERE nazwisko = nazwisko
GROUP BY nazwisko
HAVING COUNT(*)>1

-- Zad 11

SELECT uczestnik, kurs, punkty, 'naliczone' AS "stan punktów"
FROM udzialy
WHERE punkty IS NOT NULL
UNION 

SELECT uczestnik, kurs, punkty, 'brak informacji'
FROM udzialy
WHERE punkty IS NULL
ORDER BY punkty, kurs

-- Zad 12

SELECT id, nazwa
FROM kursy
EXCEPT

SELECT kurs, kursy.nazwa
FROM udzialy
JOIN kursy ON
kurs = kursy.id

