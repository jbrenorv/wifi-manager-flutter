import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_manager/wifi_manager.dart';
import 'package:wifi_manager_flutter/request_wifi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final wifiManager = WifiManager();
  String? platformVersion;
  String? networkSSID;

  @override
  void initState() {
    super.initState();
    _getPlatformVersion();
    _getConnectionInfo();
  }

  void _getPlatformVersion() {
    try {
      wifiManager
          .getPlatformVersion()
          .then((version) => setState(() => platformVersion = version));
    } on PlatformException catch (e) {
      setState(() => platformVersion = "Error: ${e.message}");
    }
  }

  void _getConnectionInfo() async {
    String result;
    try {
      result = (await wifiManager.getConnectionInfo()) ?? "Deu nulo..";
      // .then((ssid) => setState(() => networkSSID = ssid));
    } on PlatformException catch (e) {
      result = "Error: ${e.message}";
    }
    setState(() => networkSSID = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Platform verion: $platformVersion'),
              Text(networkSSID ?? 'Loading SSID...'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const RequestWifiPage()));
        },
        child: const Icon(Icons.wifi),
      ),
    );
  }
}
