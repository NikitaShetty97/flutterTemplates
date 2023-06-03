import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  var items;
  var responseData;
  Future<void> fetchData() async {
    final url = Uri.parse('https://hoblist.com/api/movieList');

    final headers = {
      'Content-Type': 'application/json',
      // Add any other headers required by the API
    };

    final body = jsonEncode({
      'category': 'movies',
      'language': 'kannada',
      'genre': 'all',
      'sort': 'voting',
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body.toString());
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Example'),
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error occurred'));
            } else {
              return ListView.builder(
                itemCount: responseData['result'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(7, 4, 7, 5),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(7, 5, 7, 0),
                          child: Card(
                            child: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                          responseData['result'][index]
                                              ['poster']),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          responseData['result'][index]
                                              ['title'],
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          "Director:  " +
                                              responseData['result'][index]
                                                      ['director'][0]
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        Text(
                                          "Starring:  " +
                                              responseData['result'][index]
                                                      ['stars'][0]
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        Text(
                                          "Genre:  " +
                                              responseData['result'][index]
                                                  ['genre'],
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
