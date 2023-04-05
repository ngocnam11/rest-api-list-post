import 'package:dio/dio.dart';

import '../models/comment.dart';
import '../models/post.dart';
import 'custom_intercepter.dart';

class DioClient {
  static const apiUrl = 'https://jsonplaceholder.typicode.com';

  final dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(CustomIntercepter());

  Future<List<Post>> getPosts([int startIndex = 0]) async {
    final responses = await dio.get(
      '/posts',
      queryParameters: {'_start': startIndex, '_limit': 20},
    );

    if (responses.statusCode == 200) {
      final posts = responses.data as List<dynamic>;
      return posts.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Comment>> getCommentOfPost({required String postId}) async {
    final responses = await dio.get('/posts/$postId/comments');

    if (responses.statusCode == 200) {
      final comments = responses.data as List<dynamic>;
      return comments.map((comment) => Comment.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<String> createPost({
    required String title,
    required String body,
  }) async {
    String res = 'some error occurred';
    try {
      final post = {
        'userId': 1,
        'title': title,
        'body': body,
      };

      await dio.post('/posts', data: post);

      res = 'success';
    } catch (e) {
      return e.toString();
    }

    return res;
  }

  Future<String> updatePost({
    required int postId,
    required String title,
    required String body,
  }) async {
    String res = 'some error occurred';
    try {
      Post post = Post(
        userId: 1,
        id: postId,
        title: title,
        body: body,
      );

      await dio.put('/posts/$postId', data: post.toJson());
      res = 'success';
    } catch (e) {
      return e.toString();
    }

    return res;
  }

  Future<void> deletePost({required int postId}) async {
    try {
      await dio.delete('/posts/$postId');
      print('Post deleted!');
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
}
