import 'package:flutter/material.dart';
import 'package:wifi_manager/models/wifi_credentials.dart';
import 'package:wifi_manager/wifi_manager.dart';

class RequestWifiPage extends StatefulWidget {
  const RequestWifiPage({super.key});

  @override
  State<RequestWifiPage> createState() => _RequestWifiPageState();
}

class _RequestWifiPageState extends State<RequestWifiPage> {
  final _ssidInputController = TextEditingController(text: "NN-w5-2_4GHz");
  final _passInputController = TextEditingController(text: "12345678");
  final _formKey = GlobalKey<FormState>();
  final _wifiManager = WifiManager();

  bool hasPassword = true;
  WifiSecurityType _wifiSecurityType = WifiSecurityType.wpa2;

  void _requestWifi() {
    if (_formKey.currentState!.validate()) {
      final wifiCredentials = WifiCredentials(
        ssid: _ssidInputController.text,
        password: _passInputController.text,
        wifiSecurityType: _wifiSecurityType,
      );
      _wifiManager.requestWifi(wifiCredentials: wifiCredentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connect to a Wifi")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
                labelText: "SSID", controller: _ssidInputController),
            _buildTextField(
              labelText: "Password",
              controller: _passInputController,
              enebled: hasPassword,
            ),
            DropdownButton<WifiSecurityType>(
              value: _wifiSecurityType,
              items: WifiSecurityType.values
                  .where((wst) => wst != WifiSecurityType.none)
                  .map((wst) =>
                      DropdownMenuItem(value: wst, child: Text(wst.name)))
                  .toList(),
              onChanged: hasPassword
                  ? (value) => setState(() => _wifiSecurityType = value!)
                  : null,
            ),
            CheckboxListTile(
              value: !hasPassword,
              onChanged: (value) => setState(() => hasPassword = !hasPassword),
              title: const Text("No password"),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _requestWifi,
                  child: const Text("Request wifi"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool enebled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        enabled: enebled,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(labelText),
        ),
      ),
    );
  }
}
