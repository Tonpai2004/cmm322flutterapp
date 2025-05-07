import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
  ));
}

class ProfileImageSelector extends StatelessWidget {
  final void Function(String) onImageSelected;
  final String selectedImage;

  const ProfileImageSelector({
    super.key,
    required this.onImageSelected,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    final imageList = [
      'assets/images/default_profile.jpg',
      'assets/images/avatar1.png',
      'assets/images/avatar2.png',
      'assets/images/avatar3.png',
      'assets/images/avatar4.png',
      'assets/images/avatar5.png',
    ];

    return AlertDialog(
      title: Row(
        children: [
          const Expanded(
            child: Text(
              'Choose Profile Image',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      content: SizedBox(
        width: 300, // กำหนดขนาดคงที่สำหรับ Width
        height: 250, // กำหนดขนาดคงที่สำหรับ Height
        child: GridView.builder(
          itemCount: imageList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onImageSelected(imageList[index]);
                Navigator.pop(context);
              },
              child: ClipOval(
                child: Image.asset(imageList[index], fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}
