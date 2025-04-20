import 'package:flutter/material.dart';
import 'learnmore.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _RenewMainPageState();
}

class _RenewMainPageState extends State<HomePage> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'IOT & Dev',
      'Animation',
      'Production',
      'Graphics',
      'Business',
    ];

    final List<String> events = [
      'CMM322 Smart Device',
      'CMM443 Cloud Computing',
      'CMM311 Digital Learning Media'
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFCFFFFA),
      body: SafeArea(child: Stack(
      children: [
      Column(
      children: [
        Container( // Navigation Bar
        height: 60,
        color: const Color(0xFF54EDDC),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Image.asset('assets/images/cmmlogo.png', height: 40),
            const SizedBox(width: 20),
            if (!isMobile) ...[
              Padding(
                padding: EdgeInsets.only(top: 5.75),
                child: _navButton('Home', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.75),
                child: _navButton('My Courses'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.75),
                child: _navButton('Support'),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: _actionButton('Login'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: _actionButton('Register'),
              ),
            ] else ...[
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.menu, size: 30),
                onPressed: () {
                  setState(() => _isMenuOpen = !_isMenuOpen);
                },
              ),
            ],
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(100),
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Recording_room.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withAlpha(50),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: const [
                    Text(
                      'CMM',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 0),
                    Text(
                      'Access learning resources anytime, anywhere.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 200,
                      color: const Color(0xFFF7F7F7),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withAlpha(30),
                          BlendMode.darken,
                        ),
                        child: Image.asset(
                          'assets/images/library2.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: const Color(0xFFF7F7F7),
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'What is "CMM" ?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Description...',
                            style: TextStyle(fontSize: 15, fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 90),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LearnMorePage()),
                                );
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Text(
                                  'Learn more...',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                width: double.infinity,
                color: const Color(0xFFCFFFFA),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Subject Category',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Inter'),
                          ),
                          Text(
                            'ALL',
                            style: TextStyle(fontSize: 16, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int itemsPerRow = (constraints.maxWidth / 100).floor();
                          itemsPerRow = itemsPerRow > 3 ? 3 : itemsPerRow;
                          double itemWidth = (constraints.maxWidth - (itemsPerRow - 1) * 20) / itemsPerRow;
                          return Wrap(
                            spacing: 20,
                            runSpacing: 40,
                            alignment: WrapAlignment.center,
                            children: List.generate(categories.length, (index) {
                              return SizedBox(
                                width: itemWidth,
                                child: _categoryItem(categories[index]),
                              );
                            }),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              _horizontalSection('Upcoming Events',events),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF54EDDC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('FAQ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Inter')),
                      SizedBox(height: 5.0),
                      Text('- Questions?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('- Yak Ship Hai leoy Esus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      ],
    ),
    if (isMobile)
    AnimatedPositioned(
    duration: const Duration(milliseconds: 300),
    top: _isMenuOpen ? 60 : -MediaQuery.of(context).size.height,
    left: 0,
    right: 0,
    child: Container(
    color: const Color(0xFF54EDDC),
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
    children: [
    _navButton('Home', mobile: true, onTap: () { // HomePage Link Access
    setState(() => _isMenuOpen = false);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
    );
    }),
    _navButton('My Courses', mobile: true),
    _navButton('Support', mobile: true),
    const Divider(color: Colors.white),
    _actionButton('Login', mobile: true),
    _actionButton('Register', mobile: true),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    );
  }

  Widget _categoryItem(String title) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFF54EDDC),
            child: Icon(Icons.book, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  Widget _horizontalSection(String title, List<String> events) {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.only(top: 20),
      color: const Color(0xFFCFFFFA),
      width: double.infinity,
      height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Inter'),
                ),
                const Text('ALL', style: TextStyle(fontSize: 16, fontFamily: 'Inter')),
              ],
            ),
          ),

          // Horizontal list with buttons
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF54EDDC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'ภาพ ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  events[index],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text('By Suriyong'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                        padding: const EdgeInsets.only(left: 7),
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.offset - 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.offset + 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(String text, {bool mobile = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 12, vertical: mobile ? 8 : 0),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text, {bool mobile = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 8, vertical: mobile ? 8 : 0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF4CD1C2)),
          backgroundColor: Color(0xFF4CD1C2),
          foregroundColor: Colors.white,
        ),
        onPressed: () {},
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      ),
    );
  }
}
