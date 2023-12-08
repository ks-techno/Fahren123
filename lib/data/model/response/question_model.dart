import 'package:Fahren123/util/app_constants.dart';

class Question{
  final int id;
  final TranslationLanguage question;
  final List<TranslationLanguage> options;
  final String ?imageUrl;
  final String ?videoUrl;
  final String ?audioUrl;
  final String ?audioUrl_german;
  final String answerValue;
  final String marks;
  final String type;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.audioUrl,
    required this.audioUrl_german,

    required this.imageUrl,
    required this.videoUrl,
    required this.type,
    required this.marks,
    required this.answerValue,
  });
  factory Question.fromJson(Map<String,dynamic>json){
    Map<String,dynamic>questionMap = json['questions']['Question'];
    dynamic answerMap = json['answers']['Answers'];
    return Question(
        id: int.parse(questionMap['question_id']),
        options: List<TranslationLanguage>.from(answerMap.map((question) => TranslationLanguage.fromJson(question)).toList()),
        audioUrl:  json['audio']['Audio'] ,
        audioUrl_german:  json['audio']['german_audio'] ,

        type: checkForAnswerValue(json['answers']['Answers']) != ''? 'textbox': 'option'  ,
        imageUrl: questionMap['Image'],
        marks: questionMap['marks'] != null ? questionMap['marks']: '0',
        videoUrl: questionMap['Video'],
        question: TranslationLanguage.fromJson(questionMap),


        answerValue: checkForAnswerValue(json['answers']['Answers'])
        // answerValue: json['answers']['answervalue']??""
    );
  }
}

String checkForAnswerValue(List answers){
  String da = '';

  var ind = answers.indexWhere((el) => el['answervalue'] != null && el['answervalue'] != '');

  if(ind != -1){
    da = answers[ind]['answervalue'];
  }

  return da;
}

class TranslationLanguage{
  final String primary;
  final String secondary;
  final bool isCorrectAnswer;


  TranslationLanguage({required this.primary, required this.secondary, this.isCorrectAnswer=false,});

  factory TranslationLanguage.fromJson(Map<String,dynamic>json){
    return TranslationLanguage(
      
      // secondary: 'faraz',
      primary: AppConstants.learnInEnglish? "${json['tertiary']??"-"}".trim(): json['primary'].trim(),
      secondary: "${json['secondary']??""}".trim(),
      isCorrectAnswer: (json['answer']??"0")=="1",
    );
  }
  Map<String,dynamic> toJson(){
    Map<String,dynamic> data = {};
    data['primary'] = primary;
    data['secondary'] = secondary;
    data['answer'] = isCorrectAnswer? 1:0;
    return data;
  }
}