# Meu Transporte — Saldo do Cartão de Transporte Estudantil

Flutter · Monorepo (`core` + `design_system`) · MVVM + Factory + Coordinator (5 papéis por cena).

## Como rodar

```bash
cd meu_transporte_app
flutter create . --platforms=android,ios,web   # gera as pastas de plataforma (não sobrescreve lib/)
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

- Android Emulator: `10.0.2.2` = localhost do computador. iOS Simulator: `http://localhost:3000`.
- HTTP sem TLS no Android: adicione `android:usesCleartextTraffic="true"` na tag `<application>`
  do `android/app/src/main/AndroidManifest.xml` (apenas para desenvolvimento).

## Endpoints usados (`carteira_server`)

| Cena    | Endpoint                          |
|---------|-----------------------------------|
| Login   | `POST /auth/login` `{email,password}` · `POST /auth/register` `{name,email,password}` |
| Home    | `GET /summary` · `GET /transactions` |
| Perfil  | `GET /me` · `POST /auth/logout`   |

CPF → e-mail (`server_login.dart`): `123.456.789-09` → `ana@carteira.dev`; demais → `<cpf>@transporte.dev`.

## Estrutura

```
lib/app/            app_dependencies, app_navigator (navigatorKey global), shared_prefs_session_storage
lib/scenes/<cena>/  *_factory · *_view · *_view_model · server_* · *_coordinator
packages/core/      models (User, Summary, Balance, Transaction, Result) · api (ApiClient + Bearer) · repositories
packages/design_system/  tokens · components · theme (claro/escuro)
```
