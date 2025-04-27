import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/progress_model.dart';

class ProgressController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save progress to Firestore
  Future<void> saveProgress(String studentId, String lessonId, double progress) async {
    try {
      final progressRef = _db
          .collection('students')  // collection หลัก
          .doc(studentId)  // ใช้ studentId เป็น documentId
          .collection('progress')  // สร้าง sub-collection ชื่อ progress
          .doc(lessonId);  // ใช้ lessonId เป็น documentId

      // บันทึกข้อมูล progress ลงใน sub-collection
      await progressRef.set({
        'progress': progress,
        'lessonId': lessonId,
        'updatedAt': FieldValue.serverTimestamp(), // Timestamp ของการอัพเดต
      });

      print('Progress saved successfully');
    } catch (e) {
      print("Error saving progress: $e");
    }
  }

  Future<ProgressModel?> loadProgress(String studentId, String lessonId) async {
    try {
      print("Loading progress for studentId: $studentId, lessonId: $lessonId");

      // ค้นหาข้อมูลนักเรียนจาก collection 'students' โดยใช้ studentId
      final studentQuerySnapshot = await _db
          .collection('students')
          .where('studentId', isEqualTo: studentId)  // กรองตาม studentId
          .get();  // ดึงข้อมูลทั้งหมดที่ตรงกับเงื่อนไข

      print("Found ${studentQuerySnapshot.docs.length} student(s)");

      if (studentQuerySnapshot.docs.isNotEmpty) {
        // หากพบเอกสารของนักเรียน (student)
        final studentDoc = studentQuerySnapshot.docs.first;  // เลือกเอกสารแรก (ถ้ามีหลายเอกสารให้เลือก)

        print("Student found: ${studentDoc.id}");

        // ใช้ studentDoc.reference ในการเข้าถึง sub-collection progress
        final progressQuerySnapshot = await studentDoc.reference
            .collection('progress')
            .where('lessonId', isEqualTo: lessonId)  // กรองตาม lessonId
            .get();  // ดึงข้อมูล progress ที่ตรงกับ lessonId

        print("Found ${progressQuerySnapshot.docs.length} progress record(s) for lessonId: $lessonId");

        if (progressQuerySnapshot.docs.isNotEmpty) {
          // ถ้ามีข้อมูลความคืบหน้าของบทเรียน (progress) ที่ตรงกับ lessonId
          final progressData = progressQuerySnapshot.docs.first.data();
          print("Progress data: $progressData");
          return ProgressModel.fromMap(progressData);
        } else {
          print("No progress data found for this lesson.");
          return null;  // ถ้าไม่พบข้อมูล progress ของบทเรียนนั้นๆ
        }
      } else {
        print("No student found with the given studentId.");
        return null;  // ถ้าไม่พบข้อมูลนักเรียน
      }
    } catch (e) {
      print("Error loading progress: $e");
      return null;  // หากเกิดข้อผิดพลาด
    }
  }


  // Fetch progress - can be used as getProgress
  Future<ProgressModel?> getProgress(String studentId, String lessonId) async {
    return await loadProgress(studentId, lessonId);
  }

  // Fetch lesson details
  Future<void> getLessonDetails(String lessonId) async {
    try {
      final lessonSnapshot = await _db
          .collection('workshops')  // collection workshops
          .doc(lessonId)  // ใช้ lessonId เป็น documentId
          .get();  // ดึงข้อมูลจาก Firestore

      if (lessonSnapshot.exists) {
        final lessonData = lessonSnapshot.data();
        String subject = lessonData?['subject'] ?? 'Unknown';
        String startDate = lessonData?['startDate'] ?? 'Unknown';
        String endDate = lessonData?['endDate'] ?? 'Unknown';
        String imageUrl = lessonData?['imageUrl'] ?? '';

        print("Subject: $subject, Start Date: $startDate, End Date: $endDate, Image: $imageUrl");
      } else {
        print("Lesson not found");
      }
    } catch (e) {
      print("Error loading lesson details: $e");
    }
  }
}
