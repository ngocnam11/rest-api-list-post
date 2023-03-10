import 'package:flutter/material.dart';

import '../models/post.dart';
import '../network/dio_client.dart';
import 'add_post_screen.dart';
import 'post_details_screen.dart';
import 'update_post_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posts'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UpdatePostScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: DioClient().getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostDetailsScreen(
                            post: snapshot.data![index],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      snapshot.data![index].title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data![index].body,
                      // maxLines: 1,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddPostScreen(),
            ),
          );
        },
      ),
    );
  }
}
