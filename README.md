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
