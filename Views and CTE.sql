-- Zad 1

CREATE VIEW AktualniUczestnicy(uczestnik, kurs, DATA)
AS
(
    SELECT u1.imie || ' ' || u1.nazwisko, k1.nazwa,
    data_udzial 
    FROM udzialy ud
    JOIN uczestnicy u1 ON ud.uczestnik = u1.pesel 
    JOIN kursy k1 ON ud.kurs = k1.id 
    WHERE status LIKE 'w toku'

)

SELECT * FROM aktualniuczestnicy 

-- Zad 2


CREATE VIEW KursyFrekwencja(kurs, liczba_uczestnikow)
AS
(
    SELECT kursy.nazwa, COUNT(*)
    FROM udzialy
    JOIN kursy ON udzialy.kurs = kursy.id
    GROUP BY kursy.nazwa
    ORDER BY COUNT(*) DESC
)

SELECT * FROM Kursyfrekwencja

SELECT kurs, liczba_uczestnikow
FROM kursyfrekwencja
WHERE liczba_uczestnikow = (SELECT MAX(liczba_uczestnikow)
FROM kursyfrekwencja)

SELECT kurs, liczba_uczestnikow
FROM kursyfrekwencja
WHERE liczba_uczestnikow = (SELECT MIN(liczba_uczestnikow)
FROM kursyfrekwencja)


-- Zad 3

WITH CTE_Kursy_Info(kurs, liczba_uczestnikow)
AS
(
    SELECT kursy.nazwa, COUNT(*)
    FROM udzialy
    JOIN kursy ON udzialy.kurs = kursy.id
    GROUP BY kursy.nazwa
    ORDER BY COUNT(*) DESC
)
SELECT kurs, liczba_uczestnikow FROM Cte_kursy_info
WHERE liczba_uczestnikow = (SELECT MAX(liczba_uczestnikow) FROM CTE_kursy_info)


WITH CTE_Kursy_Info(kurs, liczba_uczestnikow)
AS
(
    SELECT kursy.nazwa, COUNT(*)
    FROM udzialy
    JOIN kursy ON udzialy.kurs = kursy.id
    GROUP BY kursy.nazwa
    ORDER BY COUNT(*) DESC
)
SELECT kurs, liczba_uczestnikow
FROM CTE_kursy_info
WHERE liczba_uczestnikow = (SELECT MIN(liczba_uczestnikow)
FROM CTE_kursy_info)

-- Zad 4
WITH CTE_cena_za_dzien(id, nazwa, cena)
AS
(
    SELECT id, nazwa,
    COALESCE (ROUND(cena/liczba_dni, 2), cena) AS "Cena za dzień"
    FROM kursy 
    WHERE COALESCE (ROUND(cena/liczba_dni, 2), cena) > 1000
)
SELECT * FROM CTE_cena_za_dzien

-- Zad 5

WITH CTE_licz (kurs, ilu_uczestnikow)
AS
(
    SELECT kurs,
           COUNT(*)
    FROM   Udzialy 
    GROUP BY kurs
)
SELECT nazwa, C.ilu_uczestnikow
FROM   Kursy K 
       JOIN CTE_licz C ON kurs = k.id
       
       
-- Zad 6
       
WITH CTE_suma_uczestnik  (uczestnik, suma_uczestnik)
AS
(
    SELECT uczestnicy.imie || ' ' || uczestnicy.nazwisko  , SUM(kwota)
    FROM oplaty
    JOIN uczestnicy ON oplaty.uczestnik = uczestnicy.pesel 
    GROUP BY uczestnicy.imie, uczestnicy.nazwisko 
),
CTE_suma_kurs (uczestnik, kurs, suma_kurs)
AS
(
    SELECT uczestnicy.imie || ' ' || uczestnicy.nazwisko,
    kurs, SUM(kwota)
    FROM oplaty 
    JOIN uczestnicy ON oplaty.uczestnik = uczestnicy.pesel 
    GROUP BY uczestnicy.imie, uczestnicy.nazwisko, kurs
)
SELECT CTE_suma_uczestnik.uczestnik, suma_uczestnik, suma_kurs FROM CTE_suma_uczestnik LEFT JOIN CTE_suma_kurs ON CTE_suma_uczestnik.uczestnik = CTE_suma_kurs.uczestnik
ORDER BY CTE_suma_uczestnik.uczestnik