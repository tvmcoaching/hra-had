-- =====================================================================
--  Žebříček TOP 10 pro hru Had
--  Spusť celé jednou v Supabase: SQL Editor → New query → vložit → Run
--
--  Zabezpečení:
--   • kdokoli (i nepřihlášený hráč) smí skóre ČÍST a PŘIDAT,
--   • nikdo z webu nesmí skóre MĚNIT ani MAZAT
--     (chybí oprávnění UPDATE / DELETE i odpovídající pravidla RLS),
--   • hráč smí poslat jen jméno a skóre – id ani datum si nevymyslí.
-- =====================================================================

create table if not exists public.scores (
  id         bigint generated always as identity primary key,
  name       text        not null
             check (char_length(name) between 1 and 15 and name = btrim(name)),
  score      integer     not null
             check (score between 1 and 10000),
  created_at timestamptz not null default now()
);

create index if not exists scores_top_idx on public.scores (score desc, id asc);

-- Zapnout Row Level Security (bez pravidel by nešlo nic)
alter table public.scores enable row level security;

-- Nejdřív webu sebrat úplně všechna práva…
revoke all on table public.scores from anon, authenticated;

-- …a vrátit jen čtení a vložení jména + skóre
grant select                on table public.scores to anon, authenticated;
grant insert (name, score)  on table public.scores to anon, authenticated;
grant usage on sequence public.scores_id_seq to anon, authenticated;

drop policy if exists "Kdokoli muze cist"   on public.scores;
drop policy if exists "Kdokoli muze pridat" on public.scores;

create policy "Kdokoli muze cist"
  on public.scores for select
  to anon, authenticated
  using (true);

create policy "Kdokoli muze pridat"
  on public.scores for insert
  to anon, authenticated
  with check (true);

-- Pro UPDATE a DELETE záměrně žádné pravidlo ani oprávnění neexistuje
-- => přepsat ani smazat skóre přes veřejný klíč nejde.
