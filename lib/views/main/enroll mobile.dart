import 'package:contentpagecmmapp/views/main/maincontent.dart';
import 'package:flutter/material.dart';

import '../../controllers/workshop_controller.dart';

class WorkshopData {
  final String subject;
  final String code;
  final String startDate;
  final String endDate;
  final String imageUrl;

  WorkshopData({
    required this.subject,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: EnrollMobile(),
  ));
}

class EnrollMobile extends StatefulWidget {
  const EnrollMobile({super.key});

  @override
  _EnrollMobileState createState() => _EnrollMobileState();
}

class _EnrollMobileState extends State<EnrollMobile> {
  final WorkshopController _workshopController = WorkshopController();

  final double sidebarWidth = 250;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  bool _isSidebarOpen = false;
  bool _option1 = true;
  bool _option2 = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFFFA),
      body: Stack(
        children: [
          // Sidebar
          AnimatedPositioned(
            duration: _animationDuration,
            left: _isSidebarOpen ? 0 : -sidebarWidth,
            top: 0,
            bottom: 0,
            width: sidebarWidth,
            child: Material(
              elevation: 16,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter', style: TextStyle(fontSize: 24, color: Colors.white)),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      title: const Text("Status", style: TextStyle(color: Colors.white)),
                      value: _option1,
                      onChanged: (bool? value) {
                        setState(() {
                          _option1 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Ended", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Upcomimg", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Subject categories", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("IOT & DEV", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("ANIMATION", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("PRODUCTION", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("GRAPHICS", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("BUSSINESS", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("FORMAT", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("TALK", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("TALK & WORKSHOP", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("LANGUAGE", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("THAI", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("ENGLISH", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          AnimatedPositioned(
            duration: _animationDuration,
            left: _isSidebarOpen ? sidebarWidth : 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Scaffold(
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
                      Image.asset('assets/images/cmmlogo.png', height: 60),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 45),
                        onPressed: _toggleSidebar,
                      ),
                    ],
                  ),
                ),
              ),


              body: StreamBuilder<List<WorkshopData>>(
                stream: _workshopController.getWorkshops(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  }

                  final workshops = snapshot.data;

                  if (workshops == null || workshops.isEmpty) {
                    return const Center(child: Text('No workshops available'));
                  }

                  return ListView.builder(
                    itemCount: workshops.length,
                    itemBuilder: (context, index) {
                      return _buildWorkshopCard(context, workshops[index]);
                    },
                  );
                },
              ),
            ),
          ),

          // Floating Button to Open/Close Sidebar
          AnimatedPositioned(
            duration: _animationDuration,
            left: _isSidebarOpen ? sidebarWidth - 30 : 10,
            top: 130,
            child: FloatingActionButton(
              onPressed: _toggleSidebar,
              backgroundColor: Color(0xFF54EDDC),
              child: const Icon(Icons.arrow_right, color: Colors.white, size: 55),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildWorkshopCard(BuildContext context, WorkshopData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // Handle onTap here
            // For example, navigate to a detail page:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainContentPage(lessonId: data.code,),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xffbdece7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          data.imageUrl, // ใส่ URL ของภาพที่ได้จาก data.imageUrl
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF54eddc),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.subject,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Course Code: ${data.code}'),
                            Text('Course Start Date: ${data.startDate}'),
                            Text('Course End Date: ${data.endDate}'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF46B69C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('activity hours'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


}