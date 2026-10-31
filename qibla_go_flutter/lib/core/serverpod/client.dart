import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_go_client/qibla_go_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// The generated Serverpod client, created on first use.
///
/// Nothing on the qibla screen needs the server, so the app never waits for
/// this at start-up and works fully offline. Prayer-time sync will read it.
///
/// On a physical device the server URL must point at your computer's IP;
/// pass `--dart-define=SERVER_URL=http://192.168.x.x:8080/`. Otherwise the
/// URL comes from `assets/config.json` or defaults to localhost.
final serverpodClientProvider = FutureProvider<Client>((ref) async {
  final client = Client(await getServerUrl())
    ..connectivityMonitor = FlutterConnectivityMonitor();
  ref.onDispose(client.close);
  return client;
});
