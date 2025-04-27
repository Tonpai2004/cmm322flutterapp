import 'package:contentpagecmmapp/controllers/question_controller.dart';
import 'package:contentpagecmmapp/models/questions_model.dart';
import 'package:contentpagecmmapp/views/quiz/admin/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionController questionController = Get.put(QuestionController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionCategories = 'categories'; // เปลี่ยนชื่อให้ตรงกับคอลเล็กชันใน Firestore

  @override
  void initState() {
    super.initState();
    questionController.loadCategoriesFromFirestore(); // โหลดหมวดหมู่จาก Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(_collectionCategories).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Get the categories from Firestore
          final categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final title = category['title'];
              final subtitle = category['subtitle'];

              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(AdminScreen(quizCategory: title));
                  },
                  leading: const Icon(Icons.question_answer),
                  title: Text(title),
                  subtitle: Text(subtitle),
                  trailing: IconButton(
                    onPressed: () {
                      // Add delete functionality here if needed
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: const Icon(Icons.add),
      ),
    );
  }

  _showDialogBox() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            controller: questionController.categoryTitleController,
            decoration: const InputDecoration(hintText: "Enter the quiz name"),
          ),
          TextFormField(
            controller: questionController.categorySubtitleController,
            decoration: const InputDecoration(hintText: "Enter the description"),
          ),
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      onConfirm: () {
        // ส่งค่าหมวดหมู่และคำอธิบายไปยัง Firestore
        questionController.saveCategoryToFirestore(
          questionController.categoryTitleController.text,
          questionController.categorySubtitleController.text,
        );
        Get.back(); // ปิด Dialog
      },
    );
  }
}
