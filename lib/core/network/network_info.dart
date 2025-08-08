import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => connectivity.onConnectivityChanged;
}
