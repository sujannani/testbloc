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
  final controller = ScrollController();
  bool hasMore = true;
  bool isLoading = false;
  int page = 0;
  @override
  void initState() {
    super.initState();
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;
    const limit = 8;
    // final url = Uri.parse(
    //     'http://flutter.dev.emotorad.com/get_routes?_limit=$limit&_page=$page');
    final url = Uri.parse('http://flutter.dev.emotorad.com/get_routes');
    final authToken = 'test@abc.in';
    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> newItems =
            jsonResponse.map((json) => Data.fromJson(json)).toList();
        setState(() {
          isLoading = false;
          if (newItems.length < 8) {
            hasMore = false;
          } else {
            page++;
            items.addAll(newItems);
          }
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during API request: $error');
    }
  }

  void changeBookmark(item) async {
    final authToken = 'test@abc.in';
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

  List<dynamic> items = [];

  Future<void> refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      page = 0;
      items.clear();
    });
    fetch();
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
                    controller: controller,
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index < items.length) {
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
                                                      fontFamily:
                                                          'MaterialIcons'),
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
                                                      fontFamily:
                                                          'MaterialIcons'),
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
                                        InkWell(
                                          onTap: () async {
                                            changeBookmark(item);
                                          },
                                          child: Icon(
                                            (item.bookMarked)
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: Colors.red,
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: (hasMore)
                              ? CircularProgressIndicator()
                              : Text("NO more data"),
                        );
                      }
                    }),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateTo(
            0.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
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
