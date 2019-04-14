import 'package:flutter/material.dart';
import './trainslist.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String _station;
  var _stations = [
    "Kalyan",
    "Thakurli",
    "Dombivli",
    "Kopar",
    "Diva",
    "Mumbra",
    "Kalwa",
    "Thane",
    "Mulund",
    "Nahur",
    "Bhandup",
    "Kanjurmarg",
    "Vikhroli",
    "Ghatkopar",
    "Vidyavihar",
    "Kurla",
    "Sion",
    "Matunga",
    "Dadar"
  ];
  String _towardsDirection;
  var _towardsDirections = ["Towards CSMT", "Towards Kalyan"];
  bool _permission = false;
  Location _locationService = new Location();
  String error;
  LocationData location;
 @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sub Rbun",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration().copyWith(
                      icon: Icon(Icons.train),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: _stations.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        this._station = newValueSelected;
                      });
                    },
                    hint: Text(
                      "Select your Location",
                    ),
                    value: _station,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration().copyWith(
                      icon: Icon(Icons.transfer_within_a_station),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: _towardsDirections.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String newValueSelected) {
                      setState(() {
                        this._towardsDirection = newValueSelected;
                      });
                    },
                    hint: Text(
                      "Towards",
                    ),
                    value: _towardsDirection,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  OutlineButton(
                    borderSide: BorderSide(width: 1.0),
                    highlightedBorderColor: Colors.brown,
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("  Search"),
                        Icon(
                          Icons.keyboard_arrow_right,
                        )
                      ],
                    ),
                    onPressed: () {
                      if (_station != null && _towardsDirection != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TrainsList(_station, _towardsDirection),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                  top: 15.0,
                                  left: 20.0,
                                  right: 20.0),
                              contentTextStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              content:
                                  Text("Your Location & Journey Direction"),
                              title: Text("Please select:"),
                              titleTextStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
