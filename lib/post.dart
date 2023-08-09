import 'package:flutter/material.dart';
import 'package:postapiwithstreambuilder/post_model.dart';
import 'package:postapiwithstreambuilder/post_provider.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostProvider>(context, listen: false).fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>(
      stream: Provider.of<PostProvider>(context).postStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<PostModel> posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return Text('No data available.');
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userId?.toString() ?? ''),
                    Text(post.id?.toString() ?? ''),
                    Text(
                      post.title ?? '',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(post.body ?? ''),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
