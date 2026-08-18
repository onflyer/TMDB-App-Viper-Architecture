# TMDB VIPER — one architecture, two UI frameworks

A movie-browsing app (TMDB API) built to demonstrate one thing concretely:
**a properly decoupled architecture can drive SwiftUI and UIKit with the same
code.** This repo has two branches that prove it:

| Branch | UI | What's identical |
|---|---|---|
| `main` | SwiftUI (`@Observable`, `.task`, NavigationStack-based router, MapKit content builders) | every Model, Service, Manager, Interactor protocol, Router protocol, and **all tests** |
| `UIKit-branch` | UIKit (programmatic, compositional layout with orthogonal scrolling, iOS 18 zoom transition) | same presenters — the branch diff adds only a delegate protocol per screen |

The presenters (`HomePresenter`, `DetailPresenter`, `FavoritesPresenter`) are
shared byte-for-byte apart from a `weak var delegate`. SwiftUI observes them;
UIKit receives delegate callbacks from them. Same interactors, same routers,
same passing tests.

## Architecture

VIPER with a single composition root:

```
AppDelegate → Dependencies → CoreBuilder(CoreInteractor) → Router → screens
```

- **Per-screen protocol surfaces** (`HomeInteractor`, `HomeRouter`, …) are
  satisfied by empty conformances on shared implementations — each screen
  sees only the API it needs, checked by the compiler.
- **Builder creates, Router navigates.** On the UIKit branch the router
  spawns child routers bound to presented navigation controllers, so pushes
  from a sheet stay inside the sheet.
- **Persistence behind a protocol seam** — `FavoriteMoviesService` with a
  SwiftData production implementation and an in-memory mock; entity ↔ domain
  mapping keeps `@Model` types out of the app.
- **Networking**: URLSession + async/await, typed endpoint enums, zero
  third-party HTTP dependencies. No `DispatchQueue` and no completion
  handlers anywhere in the repo.

## Tests

Swift Testing (`@Test` / `#expect`) presenter tests using closure-injected,
type-erased fakes — no mocking library. They cover happy paths, failure
paths, and emitted analytics events.

## Setup

Clone and build the `TMDB VIPER` scheme (iOS 18+) — a free-tier TMDB demo key
is included so it runs out of the box. To use your own, replace
`Utilities/Constants.swift` → `tmdbAPIKey`.
