import 'package:flutter/material.dart';

void main() {
  runApp(const EnrollApp());
}

class EnrollApp extends StatelessWidget {
  const EnrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Enroll(),
    );
  }
}

class WorkshopData {
  final String subject;
  final String by;
  final String startDate;
  final String endDate;

  WorkshopData({
    required this.subject,
    required this.by,
    required this.startDate,
    required this.endDate,
  });
}

class Enroll extends StatelessWidget {
  const Enroll({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WorkshopData> workshops = [
      WorkshopData(
        subject: 'CMM214 Animation \nFundamental',
        by: 'P.Jirut',
        startDate: '01/04/2025',
        endDate: '30/06/2025',
      ),
      WorkshopData(
        subject: 'CMM443 Cloud \nComputing',
        by: 'P.Suriyong',
        startDate: '10/05/2025',
        endDate: '10/08/2025',
      ),
      WorkshopData(
        subject: 'CMM311 Digital \nLearning Media',
        by: 'P.Chanin',
        startDate: '15/07/2025',
        endDate: '15/10/2025',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFCFFFFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF54EDDC),
        elevation: 0,
        toolbarHeight: 100,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/cmmlogo.png',
                height: 60,
              ),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 45),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView( // ย้าย SingleChildScrollView มาครอบทั้ง Column
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _imageButton(),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Get ready! 3 events launching soon',
                    style: TextStyle(
                      color: Color(0xFF212D61),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFF2C67A5), thickness: 4),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Color(0xFF3FA099).withAlpha(100),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 34,
                        runSpacing: 34,
                        children: workshops.map((workshop) {
                          return SizedBox(
                            width: 250,
                            child: _buildWorkshopCard(context, workshop),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _imageButton() {
    return SizedBox(
      width: 50,
      height: 50,
      child: Image.asset(
        'assets/images/filter.png',
        fit: BoxFit.contain,
      ),
    );
  }

  static Widget _buildWorkshopCard(BuildContext context, WorkshopData data) {
    return Container(
      width: 250, // <-- กำหนดขนาดพอดีกับเนื้อหา
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF50E3C2),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text('By : ${data.by}'),
                Text('Course Start Date : ${data.startDate}'),
                Text('Course End Date : ${data.endDate}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF46B69C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('activity hours',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
