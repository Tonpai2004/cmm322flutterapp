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

  List<Question> _questions = [];
  List<Question> get questions => _questions;

  RxList<Question> _filteredQuestion = <Question>[].obs;
  List<Question> get filteredQuestion => _filteredQuestion.toList();

  final TextEditingController questionControllerText = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
        (index) => TextEditingController(),
  );
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController quizCategory = TextEditingController();

  final String _collectionQuestions = "questions";
  final String _collectionCategories = "categories";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  void incrementTime() {
    seconds.value++;
  }

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

      savedCategories.assignAll(categories);
      savedSubtitle.assignAll(subtitles);
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

        if (data.containsKey("questions") && data.containsKey("category")) {
          var question = Question.fromJson(data);
          print('load questions: ${question.questions}');
          return question;
        } else {
          print('Missing expected fields in document: ${doc.id}');
          return null;
        }
      }).whereType<Question>().toList();

      update();
    } catch (e) {
      print('Failed to load questions: $e');
    }
  }

  void resetQuiz() {
    _isAnswered = false;
    _correctAns = 0;
    _selectedAns = 0;
    _numOfCorrectAns = 0;
    _questionNumber.value = 1;
    seconds.value = 0;
    _filteredQuestion.clear();
    _pageController = PageController();

    update();
  }

  void checkAns(Question question, int selectedIndex) {
    print('Answer selected: $selectedIndex');
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) {
      _numOfCorrectAns++;
    }

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

      update();
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
    await loadCategoriesFromFirestore();
    await loadQuestionsFromFirestore();

    print('Selected Category: $category');

    if (savedCategories.contains(category)) {
      final filtered = _questions.where((question) {
        print('Question Category: ${question.category}');
        return question.category == category;
      }).toList();

      print('Filtered Questions Length: ${filtered.length}');
      _filteredQuestion.value = filtered;

      if (_filteredQuestion.isEmpty) {
        Get.snackbar("No Questions", "There are no questions in this category.");
      }
    } else {
      Get.snackbar("Invalid Category", "This category doesn't exist.");
    }

    update(); // ✅ Refresh UI หลัง filter เสร็จ
  }

  List<Question> getQuestionsByCategory(String category) {
    if (savedCategories.contains(category)) {
      return _questions.where((question) => question.category == category).toList();
    } else {
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
      await loadCategoriesFromFirestore();
      update();
      Get.snackbar("Saved", "Category created successfully");
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await loadCategoriesFromFirestore();
    await loadQuestionsFromFirestore();
    _pageController = PageController(); // สำรองไว้ใน onInit สำหรับครั้งแรก
    update();
  }

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }
}
