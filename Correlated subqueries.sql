-- Zad 1

SELECT 
uczestnik, 
punkty 
FROM udzialy
WHERE punkty > (SELECT punkty 
                FROM udzialy 
                WHERE uczestnik LIKE '75010106222')
                
-- Zad 2
                
SELECT 
id,
nazwa
FROM kursy 
WHERE id NOT IN (SELECT kurs FROM udzialy)

-- Zad 3

SELECT
pesel,
imie,
nazwisko
FROM uczestnicy  
WHERE pesel NOT IN (SELECT uczestnik FROM oplaty)

-- Zad 4

SELECT
pesel,
imie,
nazwisko
FROM uczestnicy 
WHERE pesel IN (SELECT uczestnik FROM udzialy
                WHERE kurs = 
                (SELECT id FROM kursy
                WHERE nazwa LIKE 'Analiza danych'))

                
-- Zad 5
                    
SELECT
id,
nazwa,
cena
FROM kursy
WHERE cena >= ALL(SELECT cena FROM kursy)

-- Zad 6 <- DOKONCZYC

SELECT
COALESCE (ROUND(cena/liczba_dni, 2), cena) AS "Cena za dzień"
FROM kursy 

SELECT
o.kwota,
COALESCE (ROUND(k.cena/k.liczba_dni, 2), k.cena) AS "Cena za dzień"
FROM oplaty o 
WHERE kwota < SOME  (SELECT
                    COALESCE (ROUND(cena/liczba_dni, 2), cena) AS "Cena za dzień"
                    FROM kursy k )
                    
                    
                    
-- Zad 8
                    
                    
SELECT DISTINCT uczestnik
FROM udzialy U1
    INNER JOIN kursy k 
            ON u1.kurs = k.id 
WHERE K.kontynuacja IN (SELECT u2.kurs
                        FROM udzialy u2 
                        WHERE u2.uczestnik = u1.uczestnik)
                        
-- Zad 9 
                        
SELECT DISTINCT u1.uczestnik
FROM udzialy U1
    INNER JOIN kursy k 
            ON u1.kurs = k.id 
    INNER JOIN udzialy u2 
            ON u2.uczestnik  = u1.uczestnik AND k.kontynuacja = u2.kurs 
            
-- Zad 10
            
SELECT
id,
nazwa
FROM kursy k
WHERE NOT EXISTS (SELECT 1 FROM udzialy u1
                WHERE k.id = u1.kurs)
                
                
-- Zad 12 (skip 11)
                
SELECT nazwisko
FROM wykladowcy
JOIN kursy ON
wykladowcy.id = wykladowca
WHERE kursy.nazwa LIKE 'Aspekty prawne przetwarzania danych'

-- Zad 13

SELECT kursy.nazwa
FROM wykladowcy
JOIN kursy ON
wykladowcy.id = wykladowca
WHERE nazwisko LIKE 'Stachowiak'

-- Zad 14

SELECT id, nazwa
FROM kursy
WHERE kontynuacja IS NULL

-- Zad 15

SELECT w.id, w.nazwisko, MAX(k.cena) FROM wykladowcy w JOIN kursy k ON w.id = k.wykladowca
GROUP BY w.id