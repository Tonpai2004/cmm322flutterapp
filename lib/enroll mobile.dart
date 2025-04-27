import 'package:flutter/material.dart';

class WorkshopData {
  final String subject;
  final String code;
  final String startDate;
  final String endDate;

  WorkshopData({
    required this.subject,
    required this.code,
    required this.startDate,
    required this.endDate,
  });
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: Enroll_mobile(),
  ));
}

class Enroll_mobile extends StatefulWidget {
  const Enroll_mobile({super.key});

  @override
  _EnrollMobileState createState() => _EnrollMobileState();
}

class _EnrollMobileState extends State<Enroll_mobile> {
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
              body: ListView(
                children: [
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 150.0),
                      child: Text(
                        'Get ready! 3 events launching soon',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(color: Color(0xFF2C67A5), thickness: 4),
                  ),
                  const SizedBox(height: 16),
                  _buildWorkshopCard(
                    context,
                    WorkshopData(
                      subject: 'CMM 214 Animation',
                      code: 'FLTR101',
                      startDate: 'April 1, 2025',
                      endDate: 'April 5, 2025',
                    ),
                  ),
                  _buildWorkshopCard(
                    context,
                    WorkshopData(
                      subject: 'CMM443 Cloud Computing',
                      code: 'AI202',
                      startDate: 'May 10, 2025',
                      endDate: 'May 20, 2025',
                    ),
                  ),
                  _buildWorkshopCard(
                    context,
                    WorkshopData(
                      subject: 'CMM311 Digital Learning Media',
                      code: 'UXD303',
                      startDate: 'June 15, 2025',
                      endDate: 'June 18, 2025',
                    ),
                  ),
                ],
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
        Container(
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
                      child: const Center(
                        child: Text(
                          'Image',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      ],
    );
  }
}
