# 🐍 Had

Jednoduchá, ale zábavná hra Had v jednom souboru `index.html` – hraje se přímo v prohlížeči.

- Ovládání: šipky / WASD, na mobilu přejetí prstem
- Režim pro 1 nebo 2 hráče (hráč 2 hraje WASD)
- Bonusy (🍄 houba hada zmenší), myš, portály, ovocná horečka, šatník se vzhledy a doplňky

Stačí otevřít `index.html` v prohlížeči.

## Úrovně a obtížnost
- Tři obtížnosti (😌 Lehká, 🙂 Normální, 😈 Těžká), každá má vlastní rekord. Online žebříček je jen pro Normální.
- Každá úroveň potřebuje víc ovoce (6, 7, 8 … max 16). S úrovní roste rychlost i body (×1, ×1, ×2, ×2, ×3 …).
- Ovoce stárne: čím déle leží, tím míň bodů (až na třetinu).
- Každé 2 úrovně nový svět. Všechny světy mají pevnou mapu 20×20 (nic se neposouvá):
  - 🌿 **Louka** (úr. 1–2): na 2. úrovni kameny
  - 🌴 **Džungle** (úr. 3–4): stromy a palmy na tmavé hlíně (jasně vidět, co je překážka), liány, řeka s lekníny zpomaluje (přes mosty ne), opice ze stromů hází kokosy, z řeky vyskakují ryby 🐟 (+3, dají se sníst)
  - 🏜️ **Poušť** (úr. 5–6): kaktusy, skály, tekutý písek zpomalí, převalovníky, písečná bouře, divoký had
  - 🏙️ **Město** (úr. 7–8): domy, parky, silnice s jednosměrnými pruhy a auty (přejedou ovoce, na hada troubí)
  - ❄️ **Ledové království** (úr. 9–10): na ledu had klouže (zatáčí o krok později), ledové kry, sněhové koule
  - 🌋 **Sopka** (úr. 11+): lávové řeky, erupce kráterů (lávové bomby), od 12. úrovně se blíží láva od okrajů
- Od džungle jsou v každém světě 3 poklady 💎 (+10 × násobek úrovně, za všechny tři bonus). V HUD je počítadlo.
- Při přechodu do nového světa had vyleze z portálu (zbytek těla se vysouvá postupně).
- Had pluje vlněním, mlsá jazykem, když cítí jídlo, a při 25+ bodech svléká kůži.

## Přihlášení, historie a žebříček (Supabase)

Kdo otevře odkaz, přihlásí se jménem (stejné jméno = stejný hráč na všech zařízeních). Každá hra (1 hráč, skóre > 0) se uloží do historie.
V 🏆 Žebříčku všichni vidí TOP 10 (nejlepší výsledek každého hráče) pro každou obtížnost, seznam hráčů
a po klepnutí na hráče jeho historii her.
Bez internetu se hry uloží později.

1. Vytvoř bezplatný projekt na [supabase.com](https://supabase.com).
2. V *SQL Editoru* spusť soubor `supabase/databaze.sql`.
3. Do `index.html` doplň `SUPABASE_URL` a **veřejný** klíč (*Publishable key*). Tajný klíč (*Secret key*) do hry nikdy nepatří.

## Mobil a aplikace
- Ovládání přejetím prstu kdekoli na obrazovce, volitelně šipky na obrazovce (⚙️ Nastavení).
- Hra pro dva na jednom telefonu: hráč 1 levá půlka, hráč 2 pravá.
- Přidej na plochu (iPhone: Sdílet → Přidat na plochu) – spustí se přes celou obrazovku a funguje i bez internetu.
- Při změně hry zvyš `VERSION` v `sw.js`, ať si telefony stáhnou novou verzi.

## Výsměch po prohře
Po nárazu se přehrají poslední 2 vteřiny zpomaleně s přiblížením, pak se had zarazí, vyprskne smíchy,
válí se, buší ocasem v rytmu smíchu a ukazuje na hráče. Smích je nahrávka CC0 (viz `CREDITS.md`).
