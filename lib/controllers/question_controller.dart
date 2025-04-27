import 'package:contentpagecmmapp/models/questions_model.dart';
import 'package:contentpagecmmapp/views/quiz/score_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionController extends GetxController with GetSingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedCategory = "";

  var seconds = 0.obs;

  late PageController _pageController;
  PageController get pageController => _pageController;
  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _selectedAns = 0;
  int get selectedAns => _selectedAns;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  // Questions
  List<Question> _questions = [];
  List<Question> get questions => _questions;

  RxList<Question> _filteredQuestion = <Question>[].obs; // ทำให้เป็น RxList
  List<Question> get filteredQuestion => _filteredQuestion.toList();

  final TextEditingController questionControllerText = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
        (index) => TextEditingController(),
  );
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController quizCategory = TextEditingController();

  // Categories
  final String _collectionQuestions = "questions";
  final String _collectionCategories = "categories";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  // เพิ่มฟังก์ชันเพื่อเพิ่มเวลา
  void incrementTime() {
    seconds.value++;
  }

  // ================================
  //           FIRESTORE
  // ================================

  Future<void> saveQuestionToFirestore(Question question) async {
    try {
      await _firestore.collection(_collectionQuestions).add(question.toJson());
      print('Question saved to Firestore');
    } catch (e) {
      print('Failed to save question: $e');
    }
  }

  Future<void> saveCategoryToFirestore(String title, String subtitle) async {
    try {
      await _firestore.collection(_collectionCategories).add({
        'title': title,
        'subtitle': subtitle,
      });
      print('Category saved to Firestore');
    } catch (e) {
      print('Failed to save category: $e');
    }
  }

  Future<void> loadCategoriesFromFirestore() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collectionCategories).get();

      List<String> categories = [];
      List<String> subtitles = [];

      for (var doc in snapshot.docs) {
        categories.add(doc['title']);
        subtitles.add(doc['subtitle']);
      }

      savedCategories.assignAll(categories);  // เพิ่ม categories ลงใน savedCategories
      savedSubtitle.assignAll(subtitles);     // เพิ่ม subtitles ลงใน savedSubtitle

      // พิมพ์ค่า savedCategories หลังจากโหลดจาก Firestore
      print('Loaded Categories: ${savedCategories.value}');
      update();
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }


  Future<void> loadQuestionsFromFirestore() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collectionQuestions).get();
      print("Documents fetched: ${snapshot.docs.length}");

      _questions = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        // ตรวจสอบว่าข้อมูลมีคีย์ที่คาดหวังหรือไม่
        if (data.containsKey("questions") && data.containsKey("category")) {
          var question = Question.fromJson(data);
          print('load questions');
          print(question.questions);  // ตรวจสอบข้อมูลที่ได้รับจาก Firestore
          return question;
        } else {
          print('Missing expected fields in document: ${doc.id}');
          return null;  // หรือการจัดการอื่นๆ
        }
      }).whereType<Question>().toList();

      update();
    } catch (e) {
      print('Failed to load questions: $e');
    }
  }



  // ================================
  //           QUIZ LOGIC
  // ================================

  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    update();

    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != filteredQuestion.length) {
      _isAnswered = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease,
        );
      });
    } else {
      Get.to(() => const ScorePage(), arguments: {
        'time': seconds.value,
        'category': selectedCategory,
      });
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    update();
  }

  Future<void> setFilteredQuestions(String category) async {
    // รอให้ข้อมูลโหลดก่อน
    await loadCategoriesFromFirestore();
    await loadQuestionsFromFirestore();

    // พิมพ์ค่าของ category ที่ส่งเข้ามา
    print('Selected Category: $category');

    if (savedCategories.contains(category)) {
      // กรองคำถามที่ category ตรงกับหมวดหมู่ที่เลือก
      _filteredQuestion.value = _questions.where((question) {
        // พิมพ์ค่า question.category สำหรับแต่ละคำถาม
        print('Question Category: ${question.category}');
        return question.category == category;
      }).toList();

      // พิมพ์ค่า _filteredQuestion หลังจากการกรอง
      print('Filtered Questions: ${_filteredQuestion.value}');

      if (_filteredQuestion.isEmpty) {
        Get.snackbar("No Questions", "There are no questions in this category.");
      }
    } else {
      Get.snackbar("Invalid Category", "This category doesn't exist.");
    }
  }





  List<Question> getQuestionsByCategory(String category) {
    // ตรวจสอบว่า category ที่เลือกมีอยู่ใน savedCategories หรือไม่
    if (savedCategories.contains(category)) {
      return _questions.where((question) => question.category == category).toList();
    } else {
      // ถ้า category ไม่มีใน savedCategories ก็คืนค่าเป็นลิสต์ว่าง
      return [];
    }
  }


  void saveCategoryFromInput() async {
    if (categoryTitleController.text.isNotEmpty) {
      await saveCategoryToFirestore(
        categoryTitleController.text,
        categorySubtitleController.text,
      );
      categoryTitleController.clear();
      categorySubtitleController.clear();
      await loadCategoriesFromFirestore(); // reload after saving
      update();
      Get.snackbar("Saved", "Category created successfully");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await loadCategoriesFromFirestore();
    await loadQuestionsFromFirestore();
    _pageController = PageController();
    update();
  }
}
