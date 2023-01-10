import 'package:flutter/material.dart';
import 'package:wifi_manager/models/wifi_credentials.dart';
import 'package:wifi_manager/wifi_manager.dart';

class RequestWifiPage extends StatefulWidget {
  const RequestWifiPage({super.key});

  @override
  State<RequestWifiPage> createState() => _RequestWifiPageState();
}

class _RequestWifiPageState extends State<RequestWifiPage> {
  final _ssidInputController = TextEditingController();
  final _passInputController = TextEditingController();
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

  void _connectUsingWifiEasyConnect() =>
      _wifiManager.connectUsingWifiEasyConnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connect to a Wifi")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                  labelText: "SSID", controller: _ssidInputController),
              const SizedBox(height: 8.0),
              _buildTextField(
                labelText: "Password",
                controller: _passInputController,
                enebled: hasPassword,
              ),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: !hasPassword,
                onChanged: (value) =>
                    setState(() => hasPassword = !hasPassword),
                title: const Text("Without password"),
              ),
              const SizedBox(height: 16.0),
              const Text("Security type"),
              DropdownButton<WifiSecurityType>(
                isDense: true,
                isExpanded: true,
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
              const SizedBox(height: 8.0),
              Center(
                child: ElevatedButton(
                  onPressed: _requestWifi,
                  child: const Text("Request wifi"),
                ),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const Text("Or", textAlign: TextAlign.center),
              Center(
                child: ElevatedButton(
                  onPressed: _connectUsingWifiEasyConnect,
                  child: const Text("Wi-Fi Easy Connect"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool enebled = true,
  }) {
    return TextFormField(
      enabled: enebled,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: Text(labelText),
      ),
      validator: (value) =>
          (enebled && ((value ?? "").isNotEmpty) ? null : "Obrigatório"),
    );
  }
}
