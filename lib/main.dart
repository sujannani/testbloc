import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({Key? key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  List<dynamic> items = [];

  Future<void> refresh() async {
    final url = Uri.parse('http://flutter.dev.emotorad.com/get_routes');
    final authToken = 'test@abc.in';
    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $authToken',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        print("hello");
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> newItems =
            jsonResponse.map((json) => Data.fromJson(json)).toList();
        setState(() {
          print("in set");
          items = newItems;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during API request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: items.isEmpty
          ? CircularProgressIndicator()
          : RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(item.image),
                                // fit: BoxFit.cover,
                              )),
                            ),
                            Card(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              IconData(0xe3ab,
                                                  fontFamily: 'MaterialIcons'),
                                              size: 24.0,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              item.startLoc,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              IconData(0xe3ab,
                                                  fontFamily: 'MaterialIcons'),
                                              size: 24.0,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              item.endLoc,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Icon(Icons.favorite)
                                  ]),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    ));
  }
}

class Data {
  late int id;
  late String startLoc;
  late String endLoc;
  late String image;
  late bool? bookMarked;
  Data(
      {required this.id,
      required this.startLoc,
      required this.endLoc,
      required this.image,
      required this.bookMarked});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as int,
      startLoc: json['start_loc'].toString(),
      endLoc: json['end_loc'].toString(),
      image: json['image'].toString(),
      bookMarked: json['bookmarked'] as bool?,
    );
  }
}
