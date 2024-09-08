import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:tasks/model.dart';

class TasksPage extends StatefulWidget {
  final User user;
  const TasksPage({super.key, required this.user});

  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  // Mock function to fetch tasks from an API or database
  void fetchTasks() {}

  void navigateToTaskDetail(Task task, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(
            task: task, index: index, total: widget.user.tasks.length),
      ),
    );
  }

  Widget _buildTaskStatus(String status, int count, Color color) {
    return Column(
      children: [
        Text(
          status,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 5),
        Text(
          "$count",
          style: TextStyle(fontSize: 18, color: color),
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return GestureDetector(
      onTap: () => navigateToTaskDetail(task, index),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.new_releases,
                size: 40,
                color: Colors.orange.shade400,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${task.amount} ${task.title}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.orange)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Task Summary",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTaskStatus(
                    "Inreview", widget.user.status.pendingTasks, Colors.grey),
                _buildTaskStatus(
                    "Passed", widget.user.status.passedTasks, Colors.green),
                _buildTaskStatus(
                    "Failed", widget.user.status.failedTasks, Colors.redAccent),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.user.tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(widget.user.tasks[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final int index;
  final int total;

  const TaskDetailPage(
      {super.key,
      required this.task,
      required this.index,
      required this.total});

  @override
  TaskDetailPageState createState() => TaskDetailPageState();
}

class TaskDetailPageState extends State<TaskDetailPage> {
  html.File? selectedImage;

  void _uploadImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Only accept images
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          selectedImage = files.first;
        });
      }
    });
  }

  void _submitTask() {
    if (selectedImage != null) {
      // Mock function for API submission
      // Implement actual API submission here

      // Navigate back after submission
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please upload an image before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Task ${widget.index + 1} of ${widget.total}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.task.title} (${widget.task.amount})",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.task.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: GestureDetector(
                onTap: _uploadImage,
                child: selectedImage != null
                    ? Image.network(html.Url.createObjectUrl(selectedImage!))
                    : const Center(
                        child: Text("No image selected, Click to Upload Image"),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitTask,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                "Submit Task",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
