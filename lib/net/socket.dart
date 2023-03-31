import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polcinematicsgui/cinematic.dart';
import 'package:polcinematicsgui/net/Message.dart';
import 'package:polcinematicsgui/Notifiers.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

enum MessageType {
  CONNECTED,
  DISCONNECT,
  AUTH,
  INVALID_AUTH,
  LOGGED,
  PING,
  PONG,
  GET_CINEMATICS_LIST,
  RESPONSE_CINEMATICS_LIST,
  GET_CINEMATIC,
  RESPONSE_CINEMATIC,
  RESPONSE_INVALID_CINEMATIC,
  UPDATE_COMPOSITION,
  UPDATE_TIMELINE_TIME, // TO UPDATE THE CAMERA ON THE CLIENT
}

enum SocketStatus {
  CONNECTING,
  CONNECTED,
  LOGGED,
  DISCONNECTED,
  FAILED_CONNECTION,
}

extension SocketStatusExtension on SocketStatus {
  String get message {
    switch (this) {
      case SocketStatus.CONNECTING:
        return 'Conectando...';
      case SocketStatus.CONNECTED:
        return 'Conectado';
      case SocketStatus.LOGGED:
        return 'Logeado';
      case SocketStatus.DISCONNECTED:
        return 'Desconectado';
      case SocketStatus.FAILED_CONNECTION:
        return 'Fallo en la conexión';
    }
  }

  Color get color {
    switch (this) {
      case SocketStatus.CONNECTING:
        return Colors.yellow;
      case SocketStatus.CONNECTED:
        return Colors.green;
      case SocketStatus.LOGGED:
        return Colors.green;
      case SocketStatus.DISCONNECTED:
        return Colors.red;
      case SocketStatus.FAILED_CONNECTION:
        return Colors.red;
    }
  }
}

final socketStatusNotifier = SocketStatusNotifier();
final _socketStatusProvider =
    StateNotifierProvider<SocketStatusNotifier, SocketStatus>((ref) {
  return socketStatusNotifier;
});

class ClientSocket {
  WebSocketChannel? channel;
  bool connected = false;
  String password = "";

  static final ClientSocket _instance = ClientSocket._internal();

  factory ClientSocket() {
    return _instance;
  }

  ClientSocket._internal();

  void _handleMessage(dynamic rawmessage) {
    var demsg = json.decode(rawmessage);
    final message = Message.fromJson(demsg);
    print("Message received: ${message.type} ${message.data}");

    switch (message.type) {
      case MessageType.CONNECTED:
        connected = true;
        socketStatusNotifier.setStatus(SocketStatus.CONNECTED);
        break;
      case MessageType.LOGGED:
        socketStatusNotifier.setStatus(SocketStatus.LOGGED);
        break;
      case MessageType.PING:
        sendPong();
        break;
      case MessageType.DISCONNECT:
        disconnect(true);
        break;
      case MessageType.RESPONSE_CINEMATICS_LIST:
        List<SimpleCinematic> cinematics = [];
        for (var cinematic in message.data['cinematics']) {
          cinematics.add(SimpleCinematic.fromJson(cinematic));
        }
        break;
    }
  }

  void connect(String url, String password) {
    this.password = password;
    if (channel != null) {
      channel!.sink.close(status.normalClosure);
    }

    socketStatusNotifier.setStatus(SocketStatus.CONNECTING);

    channel = WebSocketChannel.connect(Uri.parse(url));
    channel!.stream.listen(_handleMessage,
        cancelOnError: true,
        onDone: () => disconnect(true),
        onError: (e) {
          socketStatusNotifier.setStatus(SocketStatus.FAILED_CONNECTION);
          // Future.delayed(const Duration(seconds: 5), connect);
          // exit
        });
  }

  void disconnect([bool force = false]) {
    if (channel == null) {
      return;
    }

    if (!force) {
      sendMessage(MessageType.DISCONNECT);
    }
    channel!.sink.close(status.normalClosure);
    channel = null;
    connected = false;
    socketStatusNotifier.setStatus(SocketStatus.DISCONNECTED);
    // Future.delayed(const Duration(seconds: 5), connect);
    // exit
  }

  void sendPong() async {
    sendMessage(
        MessageType.PONG, {"timestamp": DateTime.now().millisecondsSinceEpoch});
  }

  Future<void> sendAuth(String password) async {
    sendMessage(MessageType.AUTH, {'password': password});
  }

  Future<void> sendMessage(MessageType type,
      [Map<String, dynamic> data = const {}]) async {
    if (!connected) {
      // TE JODES
      return;
    }

    var message = {
      'type': type.index,
      'data': data,
    };

    channel!.sink.add(json.encode(message));
  }

  Future<void> refreshCinematics() async {
    await sendMessage(MessageType.GET_CINEMATICS_LIST);
  }

  StateNotifierProvider<SocketStatusNotifier, SocketStatus>
      get socketStatusProvider => _socketStatusProvider;
}
