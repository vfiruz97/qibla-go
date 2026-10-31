# qibla_go_flutter

The Flutter app of Qibla Go. Start with the repository `README.md` for what
the app does and how the direction is computed, then `AGENTS.md` in this
directory for the structure and the rules that apply to this package.

Run everything (server plus app, with hot reload) from the server package:

    cd ../qibla_go_server && serverpod start

Checks: `dart analyze && dart format lib test && flutter test`.
