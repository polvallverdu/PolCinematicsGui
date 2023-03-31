import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polcinematicsgui/cinematic.dart';
import 'package:polcinematicsgui/main.dart';
import 'package:polcinematicsgui/net/socket.dart';
import 'package:polcinematicsgui/screens/cinematics_screen.dart';

class SocketStatusNotifier extends StateNotifier<SocketStatus> {
  SocketStatusNotifier() : super(SocketStatus.DISCONNECTED);

  void setStatus(SocketStatus status) {
    state = status;
  }
}

class ScreenNotifier extends StateNotifier<Widget> {
  ScreenNotifier() : super(LoadingScreen());

  void loading() {
    state = LoadingScreen();
  }

  void cinematics(List<SimpleCinematic> cinematics) {
    state = CinematicsScreen(cinematics: cinematics);
  }
}

class CinematicNotifier extends StateNotifier<Cinematic> {
  CinematicNotifier() : super(DummyCinematic());

  void setCinematic(Cinematic cinematic) {
    state = cinematic;
  }
}
