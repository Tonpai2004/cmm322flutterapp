import 'package:cloud_firestore/cloud_firestore.dart';

import '../enroll mobile.dart';

class WorkshopController {

  // ฟังก์ชันสำหรับดึงข้อมูล workshop จาก Firestore
  Stream<List<WorkshopData>> getWorkshops() {
    return FirebaseFirestore.instance
        .collection('workshops')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return WorkshopData(
          subject: doc['subject'],
          code: doc['code'],
          startDate: doc['startDate'],
          endDate: doc['endDate'],
          imageUrl: doc['imageUrl'], // รับ URL ของภาพจาก Firestore
        );
      }).toList();
    });
  }
}

