import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post_model.dart';

class PostProvider extends ChangeNotifier {
  final StreamController<List<PostModel>> _postStreamController = StreamController();

  Stream<List<PostModel>>? get postStream => _postStreamController.stream;

  List<PostModel> posts = [];

  Future<void> fetchPosts() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await http.get(url);
    print(response.body);


    if (response.statusCode == 200) {
      var jsons = json.decode(response.body);
      // Explicitly cast the decoded JSON to List<PostModel>
      posts = (jsons as List<dynamic>).map((json) => PostModel.fromJson(json)).toList();

      // Add data to the stream
      _postStreamController.add(posts);

      notifyListeners();
    } else {
      print('Failed to fetch data');
    }
  }
}
