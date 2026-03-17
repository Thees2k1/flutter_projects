## Plan: PokeRepo with Caching, Result Pattern & Infinite Scroll

A `PokeRepo` that centralizes all PokeAPI calls, caches data in Drift (local DB), uses a `Result` sealed class for error handling, and manages paginated infinite scroll internally.

**Why**: The PokeAPI is normalized — the list endpoint (`/pokemon`) only returns `{name, url}`. To show images, types, stats, or abilities, each Pokémon requires a separate `/pokemon/{id}` call. A repository with DB caching prevents redundant network calls and keeps data logic out of the ViewModel.

---

### Phase 1: Foundation — Result pattern + Drift setup

**Step 1** — Add Drift dependencies
- `flutter pub add drift drift_flutter` (runtime)
- `flutter pub add --dev drift_dev` (codegen)
- Drift uses `build_runner` (already installed)

**Step 2** — Create `Result<T>` sealed class → `lib/core/result.dart`
```
sealed class Result<T>
├── Success<T> { final T data; }
└── Failure<T> { final String message; final int? statusCode; }
```
- Simple, no external packages needed
- Every `PokeRepo` public method returns `Future<Result<T>>`

**Step 3** — Create Drift database → `lib/core/database/`
- `lib/core/database/pokemon_table.dart` — Drift table definition:
  - `id` (integer, primary key) — Pokémon ID
  - `name` (text)
  - `imageUrl` (text)
  - `types` (text) — JSON-encoded list of type strings
  - `stats` (text) — JSON-encoded list of `{name, value}` objects
  - `abilities` (text) — JSON-encoded list of ability name strings
- `lib/core/database/app_database.dart` — `@DriftDatabase(tables: [PokemonEntries])` class
  - CRUD methods: `upsertPokemon`, `getPokemonById`, `getAllPokemon`, `getPokemonByIds`
- Run `dart run build_runner build` to generate `.g.dart`

---

### Phase 2: DTOs & Domain Models

**Step 4** — Create `PokeDetailDTO` → `lib/core/models/poke_detail_dto.dart`
- `@JsonSerializable()` with fields mapped from `/pokemon/{id}` response:
  - `id` (int)
  - `name` (String)
  - `sprites` → nested, extract `sprites.other.official-artwork.front_default` (with fallback to `sprites.front_default`)
  - `types` → `List<PokeTypeSlotDTO>` → each has `type.name`
  - `stats` → `List<PokeStatDTO>` → each has `baseStat` + `stat.name`
  - `abilities` → `List<PokeAbilityDTO>` → each has `ability.name`
- Nested DTOs: `PokeTypeSlotDTO`, `PokeStatDTO`, `PokeAbilityDTO` (all `@JsonSerializable`)
- Run codegen after creating

**Step 5** — Refactor domain model `Pokemon` → `lib/core/models/pokemon.dart`
- Replace manual `fromJson`/`toJson` with a clean domain model (NOT json_serializable — this is a UI model, not a DTO)
- Fields: `id`, `name`, `imageUrl`, `types` (List<PokeType>), `stats` (List<PokeStat>), `abilities` (List<String>)
- Add `PokeStat` class: `{ final String name; final int value; }`
- Keep existing `PokeType` enum
- Factory: `Pokemon.fromDetailDTO(PokeDetailDTO dto)` — maps DTO → domain
- Factory: `Pokemon.fromDbEntry(PokemonEntry entry)` — maps DB row → domain
- Method: `PokemonEntry toDbEntry()` — maps domain → DB row

---

### Phase 3: PokeRepo Implementation

**Step 6** — Implement `PokeRepo` → `lib/core/poke_repo.dart`

**Internal state:**
- `ApiClient _api`
- `AppDatabase _db`
- `String? _nextPageUrl` — tracks next pagination URL (from `PokeGetListDTO.next`)
- `bool _hasMore = true`
- `List<int> _loadedIds = []` — ordered list of Pokémon IDs loaded so far (preserves list order)

**Public API:**
```
Future<Result<List<Pokemon>>> fetchInitialPage()
Future<Result<List<Pokemon>>> fetchNextPage()
Future<Result<Pokemon>> getDetail(int id)
bool get hasMore
```

**`fetchInitialPage()` flow:**
1. Reset `_loadedIds`, set `_nextPageUrl = null`, `_hasMore = true`
2. Call `_api.get<PokeGetListDTO>('/pokemon', fromJson: ...)`
3. Store `_nextPageUrl = dto.next`, `_hasMore = dto.next != null`
4. Extract Pokémon IDs from each result URL (parse `/pokemon/{id}/`)
5. For each ID: check DB cache via `_db.getPokemonById(id)`
   - Cache hit → use cached `Pokemon`
   - Cache miss → call `_api.get<PokeDetailDTO>('/pokemon/$id', fromJson: ...)` → convert to `Pokemon` → save to DB
6. Fetch cache-misses in parallel (`Future.wait`, batch of ~10 concurrent)
7. Append new IDs to `_loadedIds`
8. Return `Success(allPokemonInOrder)`
9. On any `ApiException` → return `Failure(message, statusCode)`

**`fetchNextPage()` flow:**
1. If `!_hasMore` → return `Success([])` (empty, nothing more)
2. Call API with `_nextPageUrl` (or offset/limit derived from it)
3. Same caching logic as above
4. Append to `_loadedIds`
5. Return `Success(newlyLoadedPokemon)` — only the new page's data

**`getDetail(int id)` flow:**
1. Check DB → if found, return `Success(pokemon)`
2. If not, fetch from API → save to DB → return `Success(pokemon)`
3. On error → `Failure`

**Decision: Repo accumulates, VM reads.** The repo owns `_loadedIds` and the DB cache. The VM calls `fetchNextPage()` and gets back only the new items, but can also reconstruct the full list via repo. This keeps pagination state (next URL, hasMore) co-located with the data source. The VM stays thin — just UI state + triggering fetches.

---

### Phase 4: ViewModel & Infinite Scroll

**Step 7** — Refactor `PokeListViewModal` → `lib/pokelist/view_model.dart`
- Remove `ApiClient` — use `PokeRepo` instead (injected via constructor)
- State fields: `status`, `List<Pokemon> pokemons`, `String? error`, `bool isLoadingMore`
- `fetchData()` → calls `repo.fetchInitialPage()` → pattern match `Result`:
  - `Success` → set `pokemons = data`, `status = success`
  - `Failure` → set `error = message`, `status = failure`
- `fetchMore()` → for infinite scroll:
  - Guard: if `isLoadingMore || !repo.hasMore` → return
  - Set `isLoadingMore = true`, `notifyListeners()`
  - Call `repo.fetchNextPage()` → on success, append to `pokemons`
  - Set `isLoadingMore = false`, `notifyListeners()`

**Step 8** — Update `main.dart` — wire up dependencies
- Create `Dio`, `ApiClient`, `AppDatabase`, `PokeRepo` at app startup
- Provide `PokeRepo` to `PokeListViewModal` via its constructor
- Use `Provider` / `MultiProvider`

**Step 9** — Update UI for infinite scroll → `lib/main.dart` (or extract to `lib/pokelist/page.dart`)
- In `_DataList`, use `ListView.builder` with `itemCount: data.length + (hasMore ? 1 : 0)`
- Last item = loading indicator widget
- Detect scroll-near-bottom: either `ScrollController` listener or check `index == data.length - 3` to trigger `pokeVM.fetchMore()`
- Show inline error at bottom if `fetchMore` fails (don't replace entire list)

---

### Phase 5: Codegen & Verification

**Step 10** — Run `dart run build_runner build --delete-conflicting-outputs`
- Generates: `poke_detail_dto.g.dart`, `app_database.g.dart`
- Verify no build errors

---

### Relevant Files

- `lib/core/result.dart` — **new** — `Result<T>` sealed class
- `lib/core/poke_repo.dart` — **rewrite** — full repo implementation (currently a stub referencing `apiService` + `dbService`)
- `lib/core/api_client.dart` — **minor edit** — may need to support full URL fetching (for `next` pagination URLs which are absolute)
- `lib/core/database/app_database.dart` — **new** — Drift database class
- `lib/core/database/pokemon_table.dart` — **new** — Drift table definition
- `lib/core/models/poke_detail_dto.dart` — **new** — DTO for `/pokemon/{id}` response with nested types/stats/abilities DTOs
- `lib/core/models/pokemon.dart` — **rewrite** — clean domain model with `fromDetailDTO`, `fromDbEntry`, `toDbEntry` factories; add `PokeStat`; keep `PokeType` enum
- `lib/pokelist/view_model.dart` — **rewrite** — use `PokeRepo`, add `fetchMore()`, Result pattern matching
- `lib/pokelist/models/poke_list_dto.dart` — **keep as-is** — already works
- `lib/main.dart` — **edit** — dependency wiring + infinite scroll UI

### Verification
1. `dart run build_runner build --delete-conflicting-outputs` — zero errors
2. `flutter analyze` — no lint warnings
3. Launch app → first page loads with Pokémon names + images + types
4. Scroll to bottom → next page auto-loads, loading spinner visible
5. Kill network (airplane mode) → scroll more → see error message inline, previous data still shown
6. Restart app → cached data loads instantly from Drift DB before any network call
7. Navigate to detail → data loads from cache (no extra API call if already fetched)

### Decisions
- **Drift** for persistent cache (user chose this over in-memory)
- **Repo accumulates** pagination data — ViewModel stays thin, only manages UI state. Repo owns `_loadedIds` + `_nextPageUrl` + `hasMore`. VM gets back new items per page and appends locally.
- **Parallel detail fetching** — batch `Future.wait` for cache misses within a page (~10 concurrent max) to avoid hammering the API
- **All detail fields included** — types, stats (hp, attack, defense, etc.), abilities per user request
- **`PokeGetListDTO`** stays in `lib/pokelist/models/` (it's already working) — `PokeDetailDTO` goes in `lib/core/models/` since it's used by the repo layer

### Further Considerations
1. **Offline-first**: Should the app show cached DB data immediately on launch, then refresh from network in background? Recommend yes — show stale data fast, refresh silently.
2. **Cache expiration**: Currently no TTL on cached data. Pokémon data is static so this is fine, but if you add evolving data later, consider a `lastFetchedAt` column.
