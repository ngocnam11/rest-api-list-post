import 'package:flutter/material.dart';
import 'package:rest_api/network/dio_client.dart';

import '../utils.dart';
import 'posts_screen.dart';

class UpdatePostScreen extends StatefulWidget {
  const UpdatePostScreen({super.key});

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final postIdController = TextEditingController();
  final deleteController = TextEditingController();

  bool _isLoading = false;

  void updatePost() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await DioClient().updatePost(
        postId: int.parse(postIdController.text),
        title: titleController.text,
        body: bodyController.text,
      );
      if (!mounted) return;
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Updated Post');
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Update',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: postIdController,
              decoration: const InputDecoration(hintText: 'Enter PostId'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Enter Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(hintText: 'Enter Body'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                updatePost();
              },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update Post'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Delete',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: deleteController,
              decoration: const InputDecoration(hintText: 'Enter PostId'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await DioClient()
                    .deletePost(postId: int.parse(deleteController.text));
                if (context.mounted) {
                  showSnackBar(context, 'Deleted Post');
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Delete Post'),
            ),
          ],
        ),
      ),
    );
  }
}
