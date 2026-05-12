import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:sejasa/core/utils/log_utils.dart';

class SocketService {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _socketStreamController =
      StreamController<dynamic>.broadcast();

  bool _isConnected = false;
  String? _url;

  Stream<dynamic> get stream => _socketStreamController.stream;
  bool get isConnected => _isConnected;

  void connect(String url) {
    _url = url;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
      LogUtils.i('Connected to WebSocket: $url');

      _channel?.stream.listen(
        (data) {
          _socketStreamController.add(data);
        },
        onDone: () {
          _isConnected = false;
          LogUtils.w('WebSocket connection closed.');
          _reconnect();
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
    _channel?.sink.close();
    _isConnected = false;
    LogUtils.i('WebSocket disconnected.');
  }

  void dispose() {
    _socketStreamController.close();
    disconnect();
  }
}
