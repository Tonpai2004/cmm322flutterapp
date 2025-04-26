import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: EnrolledPage(),
  ));
}

class EnrolledPage extends StatelessWidget {
  const EnrolledPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFB2F1E6),
          appBar: AppBar(
            backgroundColor: const Color(0xFF54EDDC),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const SizedBox(width:10),
                Image.asset(
                  'assets/images/cmmlogo.png',
                  height: 150,  // ปรับความสูง
                  width: 150,   // ปรับความกว้าง
                  fit: BoxFit.contain, // ให้รูปคงอัตราส่วน// สมมุติว่าโลโก้ใส่รูปได้ ถ้าไม่มีรูปใช้ Text ตามเดิม
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Courses',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212d61),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white38,
                ),
                child: const TabBar(
                  labelColor: Color(0xFF212d61),
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: Color(0xFF2865a4),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  indicator: BoxDecoration(
                    color: Color(0xFF4cd1c2),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'In progress'),
                    Tab(text: 'Completed studying.'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    _InProgressList(),
                    _CompletedList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InProgressList extends StatelessWidget {
  const _InProgressList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _CourseCard(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _CourseCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedList extends StatelessWidget {
  const _CompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No completed courses yet.',
        style: TextStyle(fontSize: 24, color: Colors.grey[700],fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4cd1c2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Photo',
              style: TextStyle(fontSize: 24, color: Colors.grey,fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CMM214 Animation Fundamenta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212d61),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Learning progress: 0%',
                  style: TextStyle(color: Color(0xFF2865a4)),
                ),
                const Text(
                  'Started learning on: 01/04/2025',
                  style: TextStyle(color: Color(0xFF2865a4)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF349c94),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'About the course',
                          style: TextStyle(fontSize: 12,color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF349c94),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Cancel registration',
                          style: TextStyle(fontSize: 12,color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}