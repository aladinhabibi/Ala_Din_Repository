import 'dart:async';
import 'dart:math';

class Server {
  /// [StreamController] simulating an ongoing websocket endpoint.
  StreamController<int>? _controller;

  /// [Timer] periodically adding data to the [_controller].
  Timer? _timer;

  /// Initializes this [Server].
  Future<void> init() async {
    final Random random = Random();

    while (true) {
      _controller = StreamController();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _controller?.add(timer.tick);
      });

      // Oops, a crash happened...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );

      // Kill the [StreamController], simulating a network loss.
      _controller?.addError(DisconnectedException());
      _controller?.close();
      _controller = null;

      _timer?.cancel();
      _timer = null;

      // Waiting for server to recover...
      await Future.delayed(
        Duration(milliseconds: (1000 + (5000 * random.nextDouble())).round()),
      );
    }
  }

  /// Returns a [Stream] of data, if this [Server] is up and reachable, or
  /// throws [DisconnectedException] otherwise.
  Future<Stream<int>> connect() async {
    if (_controller != null) {
      return _controller!.stream;
    } else {
      throw DisconnectedException();
    }
  }
}

class DisconnectedException implements Exception {}

class Client {
  Future<void> connect(Server server) async {
    int backoffSeconds = 1;
    const int maxBackoffSeconds = 32;

    while (true) {
      try {
        print('Attempting to connect to server...');
        final stream = await server.connect();
        print('Connected successfully!');

        // Reset backoff on successful connection
        backoffSeconds = 1;

        await for (final data in stream) {
          print('Received data: $data');
        }
      } on DisconnectedException {
        print(
          'Disconnected from server. Retrying in $backoffSeconds seconds...',
        );
        await Future.delayed(Duration(seconds: backoffSeconds));

        // Exponential backoff with cap
        backoffSeconds = (backoffSeconds * 2).clamp(1, maxBackoffSeconds);
      } catch (e) {
        print('Unexpected error: $e');
        await Future.delayed(Duration(seconds: backoffSeconds));
      }
    }
  }
}

Future<void> main() async {
  Client()..connect(Server()..init());
}
