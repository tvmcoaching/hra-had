-- =====================================================================
--  Databáze pro hru Had: hráči, historie her, žebříčky
--  Spusť celé jednou v Supabase: SQL Editor → New query → vložit → Run
--  (Spustit znovu nevadí – nic se nesmaže.)
--
--  Jak to funguje:
--   • hráč se přihlásí jménem → dostane tajný „token“,
--     který si hra pamatuje v telefonu/počítači,
--   • s tokenem hra po každé hře zapíše skóre do historie,
--   • VŠICHNI vidí jména, rekordy a historii všech hráčů,
--   • z webu se k tabulkám nedá dostat přímo, jen přes funkce níže
--     (tokeny ostatních hráčů nikdo neuvidí),
--   • skóre nejde z webu měnit ani mazat.
-- =====================================================================

create extension if not exists pgcrypto;

create table if not exists public.players (
  id         bigint generated always as identity primary key,
  name       text        not null check (char_length(name) between 1 and 15 and name = btrim(name)),
  token      uuid        not null default gen_random_uuid(),
  created_at timestamptz not null default now()
);
create unique index if not exists players_name_idx on public.players (lower(name));
create unique index if not exists players_token_idx on public.players (token);

create table if not exists public.games (
  id         bigint generated always as identity primary key,
  player_id  bigint      not null references public.players(id),
  score      integer     not null check (score between 0 and 100000),
  level      integer     not null default 1 check (level between 1 and 999),
  diff       text        not null default 'normal' check (diff in ('easy', 'normal', 'hard')),
  created_at timestamptz not null default now()
);
create index if not exists games_player_idx on public.games (player_id, created_at desc);
create index if not exists games_top_idx    on public.games (diff, score desc);

-- Tabulky jsou z webu úplně zavřené, všechno jde jen přes funkce.
alter table public.players enable row level security;
alter table public.games   enable row level security;
revoke all on table public.players from anon, authenticated;
revoke all on table public.games   from anon, authenticated;

-- ---------------------------------------------------------------------
-- Přihlášení jménem. Nové jméno = nový hráč, známé jméno (velikost písmen
-- nehraje roli) = stejný hráč. Vrací token a dosavadní rekordy.
-- ---------------------------------------------------------------------
create or replace function public.had_login(p_name text)
returns table (token uuid, player_id bigint, name text, best_easy int, best_normal int, best_hard int)
language plpgsql security definer set search_path = public as $$
#variable_conflict use_column
declare v public.players;
begin
  p_name  := btrim(regexp_replace(coalesce(p_name, ''), '\s+', ' ', 'g'));
  if char_length(p_name) not between 1 and 15 then raise exception 'Špatné jméno'; end if;

  insert into public.players as pl (name) values (p_name)
  on conflict ((lower(name))) do update set name = excluded.name
  returning * into v;

  return query
    select v.token, v.id, v.name,
      (select max(g.score) from public.games g where g.player_id = v.id and g.diff = 'easy')::int,
      (select max(g.score) from public.games g where g.player_id = v.id and g.diff = 'normal')::int,
      (select max(g.score) from public.games g where g.player_id = v.id and g.diff = 'hard')::int;
end $$;

-- ---------------------------------------------------------------------
-- Uložení hry (jen s platným tokenem, nejvýš 20 her za minutu)
-- ---------------------------------------------------------------------
create or replace function public.had_save(p_token uuid, p_score int, p_level int, p_diff text)
returns bigint
language plpgsql security definer set search_path = public as $$
declare pid bigint; gid bigint;
begin
  select id into pid from public.players where token = p_token;
  if pid is null then raise exception 'Neznámý hráč'; end if;
  if (select count(*) from public.games where player_id = pid and created_at > now() - interval '1 minute') >= 20 then
    raise exception 'Moc her za minutu';
  end if;
  insert into public.games (player_id, score, level, diff)
  values (pid, p_score, greatest(1, coalesce(p_level, 1)), coalesce(p_diff, 'normal'))
  returning id into gid;
  return gid;
end $$;

-- ---------------------------------------------------------------------
-- TOP 10: nejlepší výsledek každého hráče v dané obtížnosti
-- ---------------------------------------------------------------------
create or replace function public.had_top(p_diff text default 'normal')
returns table (player_id bigint, name text, score int, level int, created_at timestamptz)
language sql stable security definer set search_path = public as $$
  select b.player_id, p.name, b.score, b.level, b.created_at
  from (
    select distinct on (g.player_id) g.player_id, g.score, g.level, g.created_at, g.id
    from public.games g
    where g.diff = p_diff and g.score > 0
    order by g.player_id, g.score desc, g.id asc
  ) b
  join public.players p on p.id = b.player_id
  order by b.score desc, b.id asc
  limit 10;
$$;

-- ---------------------------------------------------------------------
-- Všichni hráči s rekordy
-- ---------------------------------------------------------------------
create or replace function public.had_players()
returns table (player_id bigint, name text, games bigint, best_easy int, best_normal int, best_hard int, last_at timestamptz)
language sql stable security definer set search_path = public as $$
  select p.id, p.name, count(g.id),
    max(g.score) filter (where g.diff = 'easy')::int,
    max(g.score) filter (where g.diff = 'normal')::int,
    max(g.score) filter (where g.diff = 'hard')::int,
    max(g.created_at)
  from public.players p
  left join public.games g on g.player_id = p.id
  group by p.id
  order by max(g.created_at) desc nulls last, p.id desc
  limit 200;
$$;

-- ---------------------------------------------------------------------
-- Historie her jednoho hráče (posledních 50)
-- ---------------------------------------------------------------------
create or replace function public.had_history(p_player bigint)
returns table (score int, level int, diff text, created_at timestamptz)
language sql stable security definer set search_path = public as $$
  select g.score, g.level, g.diff, g.created_at
  from public.games g
  where g.player_id = p_player
  order by g.created_at desc
  limit 50;
$$;

revoke all on function public.had_login(text)            from public;
revoke all on function public.had_save(uuid, int, int, text)    from public;
revoke all on function public.had_top(text)                     from public;
revoke all on function public.had_players()                     from public;
revoke all on function public.had_history(bigint)               from public;
grant execute on function public.had_login(text)          to anon, authenticated;
grant execute on function public.had_save(uuid, int, int, text) to anon, authenticated;
grant execute on function public.had_top(text)                  to anon, authenticated;
grant execute on function public.had_players()                  to anon, authenticated;
grant execute on function public.had_history(bigint)            to anon, authenticated;
