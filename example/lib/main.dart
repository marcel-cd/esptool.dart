import 'package:flutter/material.dart';
import 'package:esptool/esptool.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<UsbDeviceDescription> _deviceList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Transport.init();
    _scan();
  }

  void _scan() async {
    _deviceList.clear();
    var descriptions = await Transport.getDevicesWithDescription(
      requestPermission: false,
    );
    // print(descriptions);
    _deviceList = descriptions;
    setState(() {});
  }

  Future<bool> connectDevice(UsbDeviceDescription device) async {
    var isConnect = await Transport.connectDevice(device.device);
    print(isConnect);
    return isConnect;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Esp Tool example app')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _scan();
          },
          child: const Icon(Icons.refresh),
        ),
        body: Center(
          child: Container(
            height: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Column(
                    children:
                        _deviceList
                            .map(
                              (device) => ListTile(
                                title: Text('${device.product}'),
                                subtitle: Text("${device.device.vendorId}"),
                                onTap: () {
                                  // do something
                                },
                                trailing: OutlinedButton(
                                  onPressed: () async {
                                    connectDevice(device);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      "Print test ticket",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void log(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(info)));
  }
}
