import 'dart:convert';
import 'dart:io';
import '../model/dataModel.dart';
import 'package:http/http.dart' as http;

class LocationsRepo {

  static String authToken = 'test@abc.in';
  static Future<List<Data>> fetchLocations() async {
    final url = Uri.parse('http://flutter.dev.emotorad.com/get_routes');
    List<Data> items = [];
    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        items = jsonResponse.map((json) => Data.fromJson(json)).toList();
      }
      return items;
    } catch (e) {
      return [];
    }
  }

  static Future<void> changeBookmark(item) async{
    Map<String, dynamic> requestBody = {
      "route_id": item.id,
      "bookmark": !item.bookMarked,
    };
    String requestBodyJson = json.encode(requestBody);
    final urlMark = Uri.parse('http://flutter.dev.emotorad.com/bookmark_route');
    final response = await http.post(
      urlMark,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
      },
      body: requestBodyJson,
    );
    if (response.statusCode == 200) {
      print('Success: ${response.body}');
    } else {
      print('Failed: ${response.statusCode}, ${response.body}');
    }
  }
}