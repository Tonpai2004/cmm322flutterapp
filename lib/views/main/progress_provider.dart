import 'package:flutter/material.dart';

class ProgressProvider with ChangeNotifier {
  // เก็บสถานะของการดูคลิป
  Set<int> completedVideos = {}; // เก็บคลิปที่ดูแล้ว
  double progress = 0.0; // แถบสถานะการเรียน

  // ฟังก์ชันอัปเดตเมื่อมีการดูคลิป
  void markVideoAsCompleted(int videoId) {
    if (!completedVideos.contains(videoId)) {
      completedVideos.add(videoId);
      _updateProgress();
    }
  }

  // ฟังก์ชันคำนวณและอัปเดตสถานะแถบ
  void _updateProgress() {
    progress = completedVideos.length / 5.0; // 5 คลิป
    notifyListeners(); // แจ้งให้ widget ที่ฟังอยู่รับรู้การอัปเดต
  }
}
