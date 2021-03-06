import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:screen/screen.dart';

class TrackingSwitch extends StatefulWidget {
  final String _trainId;
  TrackingSwitch(this._trainId);
  @override
  _TrackingSwitchState createState() => _TrackingSwitchState(_trainId);
}

class _TrackingSwitchState extends State<TrackingSwitch> {
  final String trainId;

  bool hasConnection;
  _TrackingSwitchState(this.trainId);
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = new Location();
  bool _switchTracking = true;
  String error = "error";
  Timer t;
  double _latitude = 0.0;
  double _longitude = 0.0;
  double _accuracy = 0.0;
  LocationData location;
  bool _permission = false;

  List deviceId = [];
  List data = [];
  var response;
  int j;
  var firebasedata;

  @override
  void initState() {
    super.initState();
    _currentLocation = null;
    trackingSwitchOn();
  }

  radarPost() {
    if (_currentLocation != null) {
      setState(() {
        _longitude = _currentLocation.longitude;
        _latitude = _currentLocation.latitude;
        _accuracy = _currentLocation.accuracy;
      });
      var jsonMap = {
        "deviceId": "$trainId",
        "userId": "$trainId",
        "latitude": "$_latitude",
        "longitude": "$_longitude",
        "accuracy": "$_accuracy",
        "foreground": "$_permission"
      };
      String jsonStr = jsonEncode(jsonMap);
      http
          .post('https://api.radar.io/v1/track',
              headers: {
                "Authorization":
                    "prj_live_sk_7279b56b1a6d8fad9634093f5a5da32437e106c7",
                "content-type": "application/json"
              },
              body: jsonStr)
          .then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
      });
    }
  }

  trackingSwitchOff() async {
    await _locationSubscription.cancel();
    Screen.keepOn(false);
    _currentLocation = null;
    t.cancel();
  }

  trackingSwitchOn() {
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      if (mounted) {
        setState(() {
          _currentLocation = result;
        });
      }
    });
    Screen.keepOn(true);
    Timer(Duration(seconds: 5), () async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasConnection = true;
          radarPost();
        } else {
          hasConnection = false;
        }
      } on SocketException catch (_) {
        hasConnection = false;
      }
    });

    t = Timer.periodic(Duration(minutes: 1), (t) async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasConnection = true;
          radarPost();
        } else {
          hasConnection = false;
        }
      } on SocketException catch (_) {
        hasConnection = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 26.0,
            color: Colors.white,
          ),
          onTap: () => Navigator.pop(context),
        ),
        title: Text("Tracking"),
      ),
      body: Column(
        children: <Widget>[
          Text(_currentLocation != null
              ? ' Latitude: $_latitude\n Longitude: $_longitude\n Accuracy: $_accuracy\n Train ID: $trainId'
              : 'Error: Please enable Tracking\n'),
          SwitchListTile(
            value: _switchTracking,
            title: Text("Switch Tracking"),
            onChanged: (bool value) {
              if (value == true) {
                setState(() {
                  _switchTracking = value;
                  print(_switchTracking.toString());
                  trackingSwitchOn();
                });
              } else {
                if (value == false) {
                  setState(() {
                    _switchTracking = value;
                    print(_switchTracking.toString());
                    trackingSwitchOff();
                  });
                }
              }
            },
          )
        ],
      ),
    );
  }
}
