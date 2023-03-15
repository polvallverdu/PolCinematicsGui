import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polcinematicsgui/net/socket.dart';
import 'package:polcinematicsgui/screens/timeline_screen.dart';
import 'package:polcinematicsgui/widgets/sidebar/selected.dart';
import 'test.dart';
import 'widgets/timeline/row.dart';

String argsHost = "";
String argsPassword = "";
void main(List<String> args) {
  print("Args: $args");
  for (String arg in args) {
    if (arg.startsWith("--host=")) {
      argsHost = arg.substring(7);
    } else if (arg.startsWith("--password=")) {
      argsPassword = arg.substring(11);
    }
  }
  runApp(ProviderScope(child: MyApp()));
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ServerConnectionScreen extends HookWidget {
  const ServerConnectionScreen({super.key});

  void _connect(String host, String password) {
    ClientSocket().connect(host, password);
  }

  @override
  Widget build(BuildContext context) {
    final hostController = useTextEditingController(
        text: argsHost == "" ? "ws://127.0.0.1:5555" : argsHost);
    final passwordController = useTextEditingController(text: argsPassword);

    if (argsHost != "" && argsPassword != "") {
      _connect(hostController.text, passwordController.text);
    }
    return Scaffold(
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Connect with your client",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  TextField(
                    controller: hostController,
                    decoration: InputDecoration(
                      labelText: "Host",
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _connect(hostController.text, passwordController.text);
              },
              child: Text("Connect"),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socketStatus = ref.watch(ClientSocket().socketStatusProvider);

    Widget screen;
    switch (socketStatus) {
      case SocketStatus.LOGGED:
        screen = TimelineScreen();
        break;
      case SocketStatus.DISCONNECTED:
      case SocketStatus.FAILED_CONNECTION:
        screen = ServerConnectionScreen();
        break;
      default:
        screen = LoadingScreen();
        break;
    }

    return MaterialApp(
      title: 'PolCinematics GUI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
      home: Stack(
        children: [
          screen,
        ],
      ),
    );
  }
}

/*
class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TimelineWidget(totalTime: 69, keyframes: []),
            TimelineRow(totalTime: 69)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
