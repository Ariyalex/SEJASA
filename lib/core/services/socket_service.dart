import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/core/utils/log_utils.dart';

class SocketService with WidgetsBindingObserver {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _socketStreamController =
      StreamController<dynamic>.broadcast();

  bool _isConnected = false;
  String? _url;

  SocketService() {
    WidgetsBinding.instance.addObserver(this);
  }

  Stream<dynamic> get stream => _socketStreamController.stream;
  bool get isConnected => _isConnected;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      LogUtils.i('App lifecycle resumed. _url: $_url, _isConnected: $_isConnected');
      if (_url != null && !_isConnected) {
        LogUtils.i('App resumed with active session. Reconnecting...');
        connect(_url!);
      }
    }
  }

  void connect(String url) {
    final cleanUrl = url.replaceAll('#', '');
    _url = cleanUrl;
    _connectAsync(cleanUrl);
  }

  Future<void> _connectAsync(String cleanUrl) async {
    try {
      final token = await getIt<StorageService>().read('access_token');
      final headers = {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      _channel = IOWebSocketChannel.connect(
        Uri.parse(cleanUrl),
        headers: headers,
        pingInterval: const Duration(seconds: 50),
      );
      _isConnected = true;
      LogUtils.i('Connected to WebSocket: $cleanUrl');

      _channel?.stream.listen(
        (data) {
          _socketStreamController.add(data);
        },
        onDone: () {
          _isConnected = false;
          LogUtils.w('WebSocket connection closed.');
        },
        onError: (error) {
          _isConnected = false;
          LogUtils.e('WebSocket error: $error');
          _reconnect();
        },
      );
    } catch (e) {
      _isConnected = false;
      LogUtils.e('Could not connect to WebSocket: $e');
      _reconnect();
    }
  }

  void _reconnect() {
    if (_url == null) return;
    LogUtils.i('Attempting to reconnect in 5 seconds...');
    Timer(const Duration(seconds: 5), () {
      if (!_isConnected && _url != null) {
        connect(_url!);
      }
    });
  }

  void send(dynamic data) {
    if (_isConnected && _channel != null) {
      _channel?.sink.add(data);
    } else {
      LogUtils.e('Cannot send data. WebSocket is not connected.');
    }
  }

  void disconnect() {
    _url = null;
    _channel?.sink.close();
    _isConnected = false;
    LogUtils.i('WebSocket disconnected.');
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _socketStreamController.close();
    disconnect();
  }
}
