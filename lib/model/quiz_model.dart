// To parse this JSON data, do
//
//     final quizModel = quizModelFromJson(jsonString);

import 'dart:convert';

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));

String quizModelToJson(QuizModel data) => json.encode(data.toJson());

class QuizModel {
  Quiz? quiz;

  QuizModel({
    this.quiz,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        quiz: json["quiz"] == null ? null : Quiz.fromJson(json["quiz"]),
      );

  Map<String, dynamic> toJson() => {
        "quiz": quiz?.toJson(),
      };
}

class Quiz {
  String? title;
  List<Subject>? subjects;

  Quiz({
    this.title,
    this.subjects,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        title: json["title"],
        subjects: json["subjects"] == null
            ? []
            : List<Subject>.from(
                json["subjects"]!.map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subjects": subjects == null
            ? []
            : List<dynamic>.from(subjects!.map((x) => x.toJson())),
      };
}

class Subject {
  String? subjectId;
  String? subject;
  List<Question>? questions;

  Subject({
    this.subjectId,
    this.subject,
    this.questions,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        subjectId: json["subject_id"],
        subject: json["subject"],
        questions: json["questions"] == null
            ? []
            : List<Question>.from(
                json["questions"]!.map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subject_id": subjectId,
        "subject": subject,
        "questions": questions == null
            ? []
            : List<dynamic>.from(questions!.map((x) => x.toJson())),
      };
}

class Question {
  String? questionId;
  String? question;
  List<String>? options;
  List<String>? answer;
  List<String>? submittedAnswer;
  bool? isCorrectAnswer;

  Question({
    this.questionId,
    this.question,
    this.options,
    this.answer,
    this.isCorrectAnswer,
    this.submittedAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final answerList =
        json["answer"] == null ? [] : [json["answer"].toString()];
    return Question(
        questionId: json["question_id"],
        question: json["question"],
        options: json["options"] == null
            ? []
            : List<String>.from(json["options"]!.map((x) => x)),
        answer: json["answer"] == null
            ? []
            : List<String>.from(answerList.map((x) => x)),
        submittedAnswer: json['submitted_answer']);
  }

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "question": question,
        "options":
            options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "answer":
            answer == null ? [] : List<dynamic>.from(answer!.map((x) => x)),
        "submitted_answer": submittedAnswer == null
            ? []
            : List<dynamic>.from(submittedAnswer!.map((x) => x)),
      };

  @override
  String toString() {
    return 'submittedAnswer $submittedAnswer, answer $answer,isCorrectAnswer $isCorrectAnswer';
  }
}
