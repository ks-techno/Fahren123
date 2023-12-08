import '../../../enums/category.dart';

class QuestionCategory{
  final int id;
  final String primaryName;
  final String secondaryName;
  final String imageUrl;

  QuestionCategory({
    required this.id,
    required this.primaryName,
    required this.secondaryName,
    required this.imageUrl,
  });
  factory QuestionCategory.fromJson(Map<String,dynamic>json){
    return QuestionCategory(
        id: int.parse("${json['catid']??json['category_id']??0}"),
        primaryName: json['primary'],
        secondaryName: json['secondary']??"",
        imageUrl: json['image'],
    );
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic> data = {};
    data['catid'] = id.toString();
    data['primary'] = primaryName;
    data['secondary'] = secondaryName;
    data['image'] = imageUrl;
    return data;
  }
}