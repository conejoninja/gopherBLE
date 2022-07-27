import 'dart:async';
import 'dart:io' show Platform;
import 'dart:developer' as developer;

import 'package:location_permissions/location_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import './pickers/material_picker.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'main.dart';

class DashboardScreen extends StatelessWidget {
  late var scope;

  DashboardScreen(this.scope);

  void changeColor(int position, String str, Color color) {
    developer.log("CHANGE COLOR "+"MSG" + position.toString()+color.toHex()+str);
    this.scope.sendBLE("MSG" + position.toString()+color.toHex()+str);
  }

  void changeColor1(Color color) {
    changeColor(1, msg1.text, color);
  }

  void changeColor2(Color color) {
    changeColor(2, msg2.text, color);
  }

  void changeColor3(Color color) {
    changeColor(3, msg3.text, color);
  }

  void changeColor4(Color color) {
    changeColor(4, msg4.text, color);
  }

  void changeColor5(Color color) {
    changeColor(5, msg5.text, color);
  }

  void onChangeEar(int ear, int position) {
    this.scope.sendBLE("EAR" + ear.toString()+position.toString());
  }

  final msg1 = TextEditingController();
  final msg2 = TextEditingController();
  final msg3 = TextEditingController();
  final msg4 = TextEditingController();
  final msg5 = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 6,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Gopher BLE'),
                bottom: TabBar(
                  tabs: const <Widget>[
                    Tab(text: 'General'),
                    Tab(text: 'Msg 1'),
                    Tab(text: 'Msg 2'),
                    Tab(text: 'Msg 3'),
                    Tab(text: 'Msg 4'),
                    Tab(text: 'Msg 5'),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new Text("Mode")),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: ModeDropdown(this.scope),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new Text("Eyes")),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: EyesDropdown(this.scope),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new ElevatedButton(
                                onPressed: () {
                                  onChangeEar(1, 0);
                                },
                                child: new Text("Front L"))),
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new ElevatedButton(
                                onPressed: () {
                                  onChangeEar(2, 0);
                                },
                                child: new Text("Front R"))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new ElevatedButton(
                                onPressed: () {
                                  onChangeEar(1, 90);
                                },
                                child: new Text("Center L"))),
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new ElevatedButton(
                                onPressed: () {
                                  onChangeEar(2, 90);
                                },
                                child: new Text("Center R"))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new ElevatedButton(
                                onPressed: () {
                                  onChangeEar(1, 180);
                                },
                                child: new Text("Back L"))),
                        Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new ElevatedButton(
                                onPressed: () {
                                  onChangeEar(2, 180);
                                },
                                child: new Text("Back R"))),
                      ],
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                            controller: msg1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Message to display',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: MaterialPicker(
                            pickerColor: Colors.red,
                            onColorChanged: changeColor1,
                            enableLabel: true,
                            portraitOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                            controller: msg2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Message to display',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: MaterialPicker(
                            pickerColor: Colors.red,
                            onColorChanged: changeColor2,
                            enableLabel: true,
                            portraitOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                            controller: msg3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Message to display',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: MaterialPicker(
                            pickerColor: Colors.red,
                            onColorChanged: changeColor3,
                            enableLabel: true,
                            portraitOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                            controller: msg4,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Message to display',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: MaterialPicker(
                            pickerColor: Colors.red,
                            onColorChanged: changeColor4,
                            enableLabel: true,
                            portraitOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                            controller: msg5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Message to display',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: MaterialPicker(
                            pickerColor: Colors.red,
                            onColorChanged: changeColor5,
                            enableLabel: true,
                            portraitOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}

class ModeDropdown extends StatefulWidget {
  late var scope;

  ModeDropdown(this.scope, {Key? key}) : super(key: key);

  @override
  State<ModeDropdown> createState() => _ModeDropdownState(this.scope);
}

class _ModeDropdownState extends State<ModeDropdown> {
  late var scope;
  String dropdownValue = 'demo';

  _ModeDropdownState(this.scope);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        this.scope.sendBLE("MOD"+newValue.toString());
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['demo', 'eyes', 'co2', 'axis', 'message']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class EyesDropdown extends StatefulWidget {
  late var scope;
  EyesDropdown(this.scope, {Key? key}) : super(key: key);

  @override
  State<EyesDropdown> createState() => _EyesDropdownState(this.scope);
}

class _EyesDropdownState extends State<EyesDropdown> {
  late var scope;
  String dropdownValue = 'normal';

  _EyesDropdownState(this.scope);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        this.scope.sendBLE("EYE"+newValue.toString());
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['normal', 'wink', 'U U', '^ ^']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

extension HexColor on Color {
  String toHex() =>
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}