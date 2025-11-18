import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusListener {
  static final ConnectionStatusListener _singleton = ConnectionStatusListener._internal();
  final Connectivity _connectivity = Connectivity();

  bool hasConnection = false;
  bool hasShownNoInternet = false;

  final StreamController<bool> connectionChangeController = StreamController<bool>.broadcast();

  ConnectionStatusListener._internal();

  static ConnectionStatusListener getInstance() => _singleton;

  Stream<bool> get connectionChange => connectionChangeController.stream;

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _connectionChange(result);
    });
    await checkConnection();
  }


  void dispose() {
    connectionChangeController.close();
  }
}

void updateConnectivity(
    bool hasConnection,
    ConnectionStatusListener connectionStatus,
    ) {
  if (!hasConnection) {
    connectionStatus.hasShownNoInternet = true;
    // Optional: Show a dialog or snackbar here
  } else {
    if (connectionStatus.hasShownNoInternet) {
      connectionStatus.hasShownNoInternet = false;
    }
  }
}
