import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

List data = [];
Timer t;
var response;
var firebasedata;
int j;
main(List<String> args) {
  firebaseRequest().whenComplete(() {
    makeHttp().whenComplete(() {
      t = Timer.periodic(Duration(seconds: 30), (t) async {
        makeHttp();
      });
    });
  });
}

Future<void> makeHttp() async {
  response = await http.get(Uri.encodeFull('https://api.radar.io/v1/events'),
      headers: {
        "Authorization": "prj_live_sk_7279b56b1a6d8fad9634093f5a5da32437e106c7"
      });
  var extractdata = jsonDecode(response.body);
  print(extractdata);
  data = extractdata['events'];
  j = data.length;
  for (var i = 0; i < firebasedata["trackingIds"].length; i++) {
    var trackingId = firebasedata["trackingIds"][i];
    List tIdstopSns = firebasedata[trackingId]["stoppingStations"];
    for (var k = 0; k < j; k++) {
      String m = data[k]['user']['deviceId'];
      String lastL = data[k]['geofence']['description'];
      if (m == trackingId && tIdstopSns.contains(lastL)) {
        DateTime actualCreatedAt =
            DateTime.parse(data[k]['actualCreatedAt']).toLocal();
        var jsonMap = {
          "updateLocation": "${data[k]['geofence']['description']}",
          "actualCreatedAt": "$actualCreatedAt",
          "type": "${data[k]['type']}",
          "live": true
        };
        String jsonStr = jsonEncode(jsonMap);
        String url =
            'https://suburbantransporttracker.firebaseio.com/trainId/trainsList/${trackingId}/update.json';

        await http.put(url, body: jsonStr).then((response) {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.body}");
        });
        break;
      }
    }
  }
}

Future<void> firebaseRequest() async {
  final String url =
      'https://suburbantransporttracker.firebaseio.com/trainId/trainsList.json';
  var firebaseresponse = await http.get(
    Uri.encodeFull(url),
  );
  firebasedata = jsonDecode(firebaseresponse.body);
}
