import 'dart:convert';

class TranslationLanguageModel {
  int languageId;
  String imageUrl;
  String fontFamily;
  String languageName;
  String nativeName;
  bool isSelected;
  bool isLTR;

  TranslationLanguageModel({required this.imageUrl,required this.languageName,required this.fontFamily,required this.nativeName,required this.languageId,required this.isLTR,this.isSelected = false,});
  factory TranslationLanguageModel.fromJson(Map<String,dynamic>json){
    String langName = json['language']??"English";
    langName = langName.substring(0,1).toUpperCase()+langName.substring(1).toLowerCase();
    return TranslationLanguageModel(
      languageId: int.parse(json['langid']?.toString()??"0"),
        imageUrl: json['image']??"",
        languageName: langName,
        fontFamily: json['font_family'].toString().trim(),
        isLTR: json['is_ltr'].runtimeType==String ? jsonDecode(json['is_ltr'])==1 : (json['is_ltr']??1)==1,
        nativeName: json['native']==langName.toLowerCase()? '':json['native']??"",
    );
  }

  Map<String,dynamic>toJson(){
    Map<String,dynamic> data = {};
    data['langid'] = languageId;
    data['language'] = languageName;
    data['image'] = imageUrl;
    data['is_ltr'] = isLTR?1:0;
    data['native'] = nativeName;
    data['font_family'] = fontFamily;
    return data;
  }

  static List encodeToJson(List<TranslationLanguageModel> list) {
    List jsonList = [];
    list.map((language) => jsonList.add(language.toJson())).toList();
    return jsonList;
  }
}