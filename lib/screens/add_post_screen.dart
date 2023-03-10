import 'package:flutter/material.dart';
import 'package:rest_api/network/dio_client.dart';

import '../utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool _isLoading = false;

  void createPost() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await DioClient().createPost(
        title: titleController.text,
        body: bodyController.text,
      );
      if (!mounted) return;
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Posted');
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
        title: const Text('Add new post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                createPost();
              },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create Data'),
            ),
          ],
        ),
      ),
    );
  }
}
