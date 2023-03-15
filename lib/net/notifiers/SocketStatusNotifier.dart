import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polcinematicsgui/net/socket.dart';

class SocketStatusNotifier extends StateNotifier<SocketStatus> {
  SocketStatusNotifier() : super(SocketStatus.DISCONNECTED);

  void setStatus(SocketStatus status) {
    state = status;
  }
}
