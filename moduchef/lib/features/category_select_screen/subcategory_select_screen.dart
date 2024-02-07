import 'package:flutter/material.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:fridgeat/features/category_select_screen/widgets/subcategory_keyword_input.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:fridgeat/features/recipes_screen/gpt.dart';
import 'package:fridgeat/features/recipes_screen/recipes_result_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SubCategorySelectScreen extends StatefulWidget {
  final bool hideNavigationBar;
  final bool accessFromOtherScreen;
  final UserSelections userSelections;

  const SubCategorySelectScreen({
    Key? key,
    this.hideNavigationBar = true,
    this.accessFromOtherScreen = false,
    required this.userSelections,
  }) : super(key: key);

  @override
  _SubCategorySelectScreenState createState() =>
      _SubCategorySelectScreenState();
}

class _SubCategorySelectScreenState extends State<SubCategorySelectScreen> {
  bool isSwitched = false;
  double _sliderValue = 30.0;
  String dropdownValue = 'Novice';
  int? selectedContainer;
  late final UserSelections userSelections = widget.userSelections;

  // Added from the provided form code
  final List<String> cookingSkillItems = ['초보자', '중급자', '전문가'];
  String? selectedValue;
  final _formKey = GlobalKey<FormState>();

  void onNextTap() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 메서드를 호출하여 값을 설정합니다.
      userSelections
          .mainCategoryServings(widget.userSelections.maincategoryServings);
      userSelections
          .mainCategoryUtensil(widget.userSelections.maincategoryUtensil);

      // null 체크를 한 후에 String 타입의 변수에 값을 할당합니다.
      if (selectedValue != null) {
        userSelections.subcategoryCookingSkill = selectedValue!;
      }

      // Slider 값은 이미 double 타입이므로 그대로 할당합니다.
      userSelections.subcategoryCookingTime = _sliderValue;

      userSelections.subcategoryKeywords =
          widget.userSelections.subcategoryKeywords;

      // 모드 선택 여부를 설정합니다.
      userSelections.gourmetMode = selectedContainer == 0;
      userSelections.allinMode = selectedContainer == 1;

      // 로딩 다이얼로그를 표시합니다.
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              // 여기에서 모양을 설정합니다.
              borderRadius: BorderRadius.circular(30), // 테두리 반경을 20으로 설정
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.waveDots(
                      color: Colors.black, size: 40),
                  Gaps.v10,
                  const Text(
                    "레시피를 생성 중입니다...",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      );

      try {
        String recipes = await getRecipe(userSelections: userSelections);

        // 로딩 다이얼로그를 닫습니다.
        Navigator.pop(context);

        // 결과 화면으로 네비게이션합니다.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipesResultScreen(recipes: recipes),
          ),
        );
      } catch (e) {
        // 로딩 다이얼로그를 닫습니다.
        Navigator.pop(context); // 오류가 발생했을 때도 다이얼로그를 닫아야 합니다.

        // 에러 다이얼로그를 보여줍니다.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0), // 원하는 BorderRadius 값 설정
              ),
              title: const Text(
                '오류',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text('레시피를 불러오는 데 실패했습니다: $e'), // 오류 메시지를 보여줍니다.
              actions: <Widget>[
                TextButton(
                  child: const Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 오류 다이얼로그를 닫습니다.
                  },
                ),
              ],
            );
          },
        );
      }

      debugPrint(
          'Main Category Foodtype: ${userSelections.maincategoryServings}');
      debugPrint(
          'Main Category Utensil: ${userSelections.maincategoryUtensil}');
      debugPrint(
          'Selected Main Ingredient: ${userSelections.selectedMainIngredient}');
      debugPrint(
          'Subcategory Cooking Skill: ${userSelections.subcategoryCookingSkill}');
      debugPrint(
          'Subcategory Cooking Time: ${userSelections.subcategoryCookingTime}');
      debugPrint('Subcategory Keywords: ${userSelections.subcategoryKeywords}');
      debugPrint('Gourmet Mode: ${userSelections.gourmetMode}');
      debugPrint('All-in Mode: ${userSelections.allinMode}');
      debugPrint('Seasonings: ${userSelections.seasonings}');
      debugPrint('Spiceries: ${userSelections.spiceries}');
      debugPrint(
          'Custom Bottom Sheet Ingredients: ${userSelections.customBottomSheetIngredients}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서브 카테고리 선택',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        titleTextStyle: GoogleFonts.nanumGothic(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gaps.v10,
                Text("\"보다 개인화된 레시피 추천을 위해 선택하시는 것을 권장합니다\"",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600)),
                Gaps.v60,
                const Text("1. 자신의 요리 실력을 선택해 주세요.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gaps.v32,
                        DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            // Add Horizontal padding using menuItemStyleData.padding so it matches
                            // the menu padding when button's width is not specified.
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // Add more decoration..
                          ),
                          hint: const Text(
                            '내 요리 실력은?',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: cookingSkillItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              userSelections.subcategoryCookingSkill =
                                  newValue; // 요리 실력을 UserSelections 인스턴스에 저장합니다.
                            });
                          },
                          onSaved: (value) {
                            selectedValue = value.toString();
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Gaps.v32,
                const Text(
                  '2. 희망 조리시간을 설정해주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                      thumbColor: Colors.white,
                      activeTrackColor: Colors.blue,
                      activeTickMarkColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      inactiveTickMarkColor: Colors.white,
                      thumbShape: CustomSliderThumbShape(),
                      overlayColor: Colors.transparent),
                  child: Slider(
                    value: _sliderValue,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                        userSelections.subcategoryCookingTime =
                            value; // 희망 조리 시간을 UserSelections 인스턴스에 저장합니다.
                      });
                    },
                    min: 5,
                    max: 60,
                    divisions: 11,
                  ),
                ),
                Text(
                  '⏲️ ${_sliderValue.toInt()} 분',
                  style: const TextStyle(fontSize: 13),
                ),
                Gaps.v52,
                KeywordInput(userSelections: userSelections),
                Gaps.v28,
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // ListTile 간격을 최대로 벌림
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedContainer = 0;
                            // 해당 값을 UserSelections의 gourmetMode에 저장합니다.
                            userSelections.gourmetMode = true;
                            userSelections.allinMode = false;
                          });
                        },
                        splashColor: Colors.transparent, // Splash 효과 제거
                        child: Container(
                          constraints: const BoxConstraints(
                              minHeight: 100), // 최소 높이를 100으로 설정
                          padding: const EdgeInsets.symmetric(
                              vertical: 20), // 상하 패딩 추가
                          decoration: BoxDecoration(
                            border: selectedContainer == 0
                                ? Border.all(color: Colors.blue, width: 4.0)
                                : Border.all(
                                    color: Colors.grey.shade300, width: 1.0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                                MainAxisAlignment.center, // 세로축 가운데 정렬
                            children: [
                              const Text(
                                'Gourmet 모드 🎯',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Gaps.v10,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '최적의 식재료를 선별하여 레시피 출력',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  textAlign: TextAlign.start, // 텍스트 정렬
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gaps.h10, // 수평 간격 추가
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedContainer = 1;
                            // 해당 값을 UserSelections의 allinMode에 저장합니다.
                            userSelections.allinMode = true;
                            userSelections.gourmetMode = false;
                          });
                        },
                        splashColor: Colors.transparent, // Splash 효과 제거
                        child: Container(
                          constraints: const BoxConstraints(
                              minHeight: 100), // 최소 높이를 100으로 설정
                          padding: const EdgeInsets.symmetric(
                              vertical: 20), // 상하 패딩 추가
                          decoration: BoxDecoration(
                            border: selectedContainer == 1
                                ? Border.all(color: Colors.blue, width: 4.0)
                                : Border.all(
                                    color: Colors.grey.shade300, width: 1.0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // 세로축 가운데 정렬
                            children: [
                              const Text(
                                'ALL-IN 모드 🔥',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Gaps.v10,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '주어진 식재료를 모두 활용하여 레시피 출력',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  textAlign: TextAlign.start, // 텍스트 정렬
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.hideNavigationBar
          ? BottomAppBar(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Sizes.size10,
                  bottom: Sizes.size20,
                  left: Sizes.size32,
                  right: Sizes.size32,
                ),
                child: CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Sizes.size32),
                  padding: const EdgeInsets.symmetric(vertical: Sizes.size14),
                  onPressed: onNextTap,
                  child: const Text(
                    "레시피 추천받기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(10.0); // 핸들의 크기를 정의
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    double value = 0.0,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // 그림자 스타일을 툴팁과 유사하게 조정
    final shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: 12));
    canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.8), 2, true);

    // 핸들의 색상과 스타일 정의
    final paint = Paint()
      ..color = Colors.white // 핸들의 색상
      ..style = PaintingStyle.fill;

    // 핸들 그리기 (동그란 모양)
    canvas.drawCircle(center, 10, paint);
  }
}
