# 🐍 Had

Jednoduchá, ale zábavná hra Had v jednom souboru `index.html` – hraje se přímo v prohlížeči.

- Ovládání: šipky / WASD, na mobilu přejetí prstem
- Režim pro 1 nebo 2 hráče (hráč 2 hraje WASD)
- Bonusy, myš, portály, ovocná horečka, šatník se vzhledy a doplňky

Stačí otevřít `index.html` v prohlížeči.

## Úrovně a obtížnost
- Tři obtížnosti (😌 Lehká, 🙂 Normální, 😈 Těžká), každá má vlastní rekord. Online žebříček je jen pro Normální.
- Každá úroveň potřebuje víc ovoce (6, 7, 8 … max 16). S úrovní roste rychlost i body (×1, ×1, ×2, ×2, ×3 …).
- Ovoce stárne: čím déle leží, tím míň bodů (až na třetinu).
- Úroveň 2+: kameny · 5+: divoký had krade ovoce (obklíčíš-li ho, dostaneš bonus) · 6+: koulející se balvany · 8+: zdi se přibližují.
- Had pluje vlněním, mlsá jazykem, když cítí jídlo, a při 25+ bodech svléká kůži.

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
