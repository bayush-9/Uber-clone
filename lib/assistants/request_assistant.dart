import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> recieveRequest(String url) async {
    print(url);
    http.Response httpResponse = await http.get(Uri.parse(url));
    try {
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body;
        var decodedResponseData = jsonDecode(responseData);
        return decodedResponseData;
      } else {
        return "Failed";
      }
    } on Exception catch (e) {
      return "Failed";
    }
  }
}
