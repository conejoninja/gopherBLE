import 'dart:async';
import 'dart:io' show Platform;
import 'dart:developer' as developer;
import 'dart:convert';

import 'package:location_permissions/location_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gopher BLE',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Gopher BLE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var items = <ListItem>[];

// Some state management stuff
  bool _foundDeviceWaitingToConnect = false;
  bool _scanStarted = false;
  bool _connected = false;

// Bluetooth related variables
  late DiscoveredDevice _ubiqueDevice;
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanStream;
  late StreamSubscription<ConnectionStateUpdate> _updateSubscription;
  static late QualifiedCharacteristic _rxCharacteristic;

// These are the UUIDs of your device
  final Uuid serviceUuid = Uuid.parse("2875983c-f450-11ec-a9d4-3f33b01340ee");
  final Uuid characteristicUuid =
      Uuid.parse("28759936-f450-11ec-a9d5-9ff78e4bf611");
  final Uuid serviceUuid2 = Uuid.parse("28759968-f450-11ec-a964-eb6f988b5b69");
  final Uuid characteristicUuid2 =
      Uuid.parse("28759990-f450-11ec-a9d7-8773ad8e8962");

  void _startScan() async {
// Platform permissions handling stuff
    bool permGranted = false;
    setState(() {
      _scanStarted = true;
      if (_connected) {
        _updateSubscription.cancel();
      }
    });
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }
    items.clear();
    developer.log('permGRANTED', error: permGranted);

    if (permGranted) {
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        bool found = false;
        for (var i = 0; i < items.length; i++) {
          if (items[i].id() == device.id) {
            found = true;
            break;
          }
        }
        if (!found) {
          items.add(ListItem(device));
        }
        setState(() {
          _ubiqueDevice = device;
          _foundDeviceWaitingToConnect = true;
        });
      });
    }
  }

  void connectToHelmet(item_index) {
    // We're done scanning, we can cancel it
    _scanStream.cancel();
    // Let's listen to our connection so we can make updates on a state change
    Stream<ConnectionStateUpdate> _currentConnectionStream = flutterReactiveBle
        .connectToAdvertisingDevice(
            id: items[item_index].id(),
            prescanDuration: const Duration(seconds: 1),
            withServices: [serviceUuid2, characteristicUuid2]);
    _updateSubscription = _currentConnectionStream.listen((event) {
      switch (event.connectionState) {
        // We're connected and good to go!
        case DeviceConnectionState.connected:
          {
            _rxCharacteristic = QualifiedCharacteristic(
                serviceId: serviceUuid2,
                characteristicId: characteristicUuid2,
                deviceId: event.deviceId);
            setState(() {
              _foundDeviceWaitingToConnect = false;
              _connected = true;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen(this)),
            );
            break;
          }
        // Can add various state state updates on disconnect
        case DeviceConnectionState.disconnected:
          {
            break;
          }
        default:
      }
    });
  }

  void sendBLE(String str) {
    List<int> bytes = utf8.encode("T1NYG0"+str);
    developer.log("sendBLE "+str);
    if (_connected) {
      var res = flutterReactiveBle.writeCharacteristicWithoutResponse(
          _rxCharacteristic,
          value: bytes);
    }
  }

  void backpack() {
    developer.log("BACK PACK", error: _connected);
    developer.log("BACK PACK [CHAR]", error: _rxCharacteristic);
    if (_connected) {
      var res = flutterReactiveBle.writeCharacteristicWithoutResponse(
          _rxCharacteristic,
          value: [0xff, 0, 0xff, 0xde, 0xad, 0xbe, 0xaf]);
      developer.log("BACK PACK = ", error: res);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: items.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
              child: ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                connectToHelmet(index);
              },
              child: const Icon(Icons.bluetooth),
            ),
          ));
        },
      ),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: _startScan,
          child: const Icon(Icons.search),
        ),
      ],
    );
  }
}

/// A ListItem that contains data to display a message.
class ListItem {
  late DiscoveredDevice device;

  ListItem(this.device);

  @override
  Widget buildTitle(BuildContext context) => Text(this.device.name);

  @override
  Widget buildSubtitle(BuildContext context) => Text(this.device.id);

  String name() {
    return this.device.name;
  }

  String id() {
    return this.device.id;
  }

  DiscoveredDevice getDevice() {
    return this.device;
  }
}
