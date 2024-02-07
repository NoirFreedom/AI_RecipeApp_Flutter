import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getRecipe({required UserSelections userSelections}) async {
  final apiKey = dotenv.env['GPT'];

  // 사용자 선호도 문자열 생성

  // 키워드 정보 관리

  // 재료, 양념, 향신료 목록을 문자열로 변환
  String ingredientList =
      userSelections.customBottomSheetIngredients.join(', ');
  String seasoningList = userSelections.seasonings.join(', ');
  String spiceryList = userSelections.spiceries.join(', ');

  String mainCategoryServings = userSelections.maincategoryServings!;
  String mainCateregoryUtensil = userSelections.maincategoryUtensil!;
  String mainIngredient = userSelections.selectedMainIngredient != null
      ? ", 주요 재료: ${userSelections.selectedMainIngredient}"
      : "";

  String subCategoryCookingSkill = userSelections.subcategoryCookingSkill;
  String subCategoryCookingTime =
      userSelections.subcategoryCookingTime.toInt().toString();

  String userKeywords = userSelections.subcategoryKeywords ?? "";
  if (userKeywords.isNotEmpty) {
    userKeywords += ', 키워드: $userKeywords';
  }
  String recipesMode = userSelections.getModeText();

  // 사용자 메시지 생성
  String userMessage =
      "냉장고에 있는 식재료를 활용한 레시피를 만들려고합니다. 제약조건: 1.다음 레시피 양식에서 [info]에 해당하는 내용만 작성하세요. 요리제목:[info], 요리설명:[info], 난이도:[info], 소요시간:[info], 인분[info], 기본재료:[info], 조리방법:[info]. 2. 난이도는 '초급','중급' 또는 '고급'으로 표시할 것. 3.각 기본재료는 필요한 양과 함께 한줄에 한개 씩 표기할 것, 예)-목살(200g). 4.주어진 조미료인 $seasoningList(와)과 향신료 $spiceryList(는)를 모두 사용할 필요없이 요리에 필요한 것만 사용가능. 5.'조리방법'에 해당하는 부분에서 조미료와 양념은 양과 함께 표시할 것, 예)고춧가루(1작은술). 요구사항: $ingredientList$recipesMode하여 $subCategoryCookingSkill수준의 $mainCategoryServings기준 레시피를 만들어주세요. 메인으로 사용할 식재료는 $mainIngredient, 희망 조리시간은 $subCategoryCookingTime이내 이고, 요리에 사용할 조리도구는 $mainCateregoryUtensil입니다. 반드시 1~5번까지의 제약조건을 지켜야하며, $userKeywords(이)가 반영된 레시피를 만들어주세요";

  final messages = [
    {"role": "system", "content": "You are a helpful assistant for cooking."},
    {"role": "user", "content": userMessage}
  ];

  // API 호출
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': "gpt-3.5-turbo",
      'messages': messages,
      'temperature': 0.7,
      'max_tokens': 3000,
    }),
  );

  // 응답 처리
  if (response.statusCode == 200) {
    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    return responseBody['choices'][0]['message']['content'];
  } else {
    print('Error: ${response.statusCode}');
    print('Error body: ${response.body}');
    throw Exception('Failed to load recipe');
  }
}
