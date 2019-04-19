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
    Timer(Duration(seconds: 5), () {
      radarPost();
    });

    t = Timer.periodic(Duration(minutes: 1), (t) {
      print("object");
      radarPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracking"),
      ),
      body: Column(
        children: <Widget>[
          Text(_currentLocation != null
              ? 'Continuous location: $_latitude & $_longitude & $_accuracy\n'
              : 'Error: $error\n'),
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
