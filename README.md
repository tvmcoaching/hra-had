# 🐍 Had

Jednoduchá, ale zábavná hra Had v jednom souboru `index.html` – hraje se přímo v prohlížeči.

- Ovládání: šipky / WASD, na mobilu přejetí prstem
- Režim pro 1 nebo 2 hráče (hráč 2 hraje WASD)
- Bonusy, myš, portály, ovocná horečka, šatník se vzhledy a doplňky

Stačí otevřít `index.html` v prohlížeči.

## Online žebříček (Supabase)

1. Vytvoř bezplatný projekt na [supabase.com](https://supabase.com).
2. V *SQL Editoru* spusť soubor `supabase/zebricek.sql` (tabulka + zabezpečení: jen číst a přidávat).
3. Do `index.html` doplň `SUPABASE_URL` a **veřejný** klíč (*Publishable key*). Tajný klíč (*Secret key*) do hry nikdy nepatří.

## Mobil a aplikace
- Ovládání přejetím prstu kdekoli na obrazovce, volitelně šipky na obrazovce (⚙️ Nastavení).
- Hra pro dva na jednom telefonu: hráč 1 levá půlka, hráč 2 pravá.
- Přidej na plochu (iPhone: Sdílet → Přidat na plochu) – spustí se přes celou obrazovku a funguje i bez internetu.
- Při změně hry zvyš `VERSION` v `sw.js`, ať si telefony stáhnou novou verzi.

## Výsměch po prohře
Po nárazu se přehrají poslední 2 vteřiny zpomaleně s přiblížením, pak se had zarazí, vyprskne smíchy,
válí se, buší ocasem v rytmu smíchu a ukazuje na hráče. Smích je nahrávka CC0 (viz `CREDITS.md`).
