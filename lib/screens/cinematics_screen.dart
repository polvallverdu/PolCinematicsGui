import 'package:flutter/material.dart';
import 'package:polcinematicsgui/cinematic.dart';
import 'package:polcinematicsgui/net/socket.dart';

class CinematicsScreen extends StatelessWidget {
  final List<SimpleCinematic> cinematics;

  const CinematicsScreen({super.key, this.cinematics = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinematics (${cinematics.length})"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: () async {
              ClientSocket().refreshCinematics();
            },
          )
        ],
      ),
      body: ListView.separated(
        itemBuilder: (ctx, num) {
          return ListTile(
            title: Text(cinematics[num].name),
            subtitle: Text(cinematics[num].UUID),
          );
        },
        separatorBuilder: (ctx, num) {
          return Divider();
        },
        itemCount: cinematics.length,
      ),
    );
  }
}
