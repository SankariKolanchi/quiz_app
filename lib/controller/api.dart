import 'package:dio/dio.dart';

import '../model/quiz_model.dart';

class QuizApi {
  final Dio dio = Dio();

  Future<QuizModel> fetchQuizData() async {
    try {
      final response = await dio.get(
          'https://caee781c-ed41-48a0-98a2-49f59780c46a.mock.pstmn.io/quizzes');
      if (response.statusCode == 200) {
        return quizModelFromJson(response.data);
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
