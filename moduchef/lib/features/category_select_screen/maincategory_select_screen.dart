import 'package:flutter/material.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:fridgeat/features/category_select_screen/subcategory_select_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fridgeat/features/onboarding/widgets/interest_button.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:google_fonts/google_fonts.dart';

class MainCategorySelectScreen extends StatefulWidget {
  final bool hideNavigationBar;
  final bool accessFromOtherScreen;
  final List<String> ingredients;
  final UserSelections userSelections;

  const MainCategorySelectScreen({
    super.key,
    this.hideNavigationBar = true,
    this.accessFromOtherScreen = false,
    required this.ingredients,
    required this.userSelections,
  });

  @override
  State<MainCategorySelectScreen> createState() =>
      _MainCategorySelectScreenState();
}

class _MainCategorySelectScreenState extends State<MainCategorySelectScreen> {
  String dropdownValue = 'Novice';
  int? selectedContainer;
  String? selectedIngredient;

  // Added from the provided form code
  final List<String> servings = [
    '1인분',
    '2인분',
    '3인분',
    '4인분',
    '5인분',
  ];

  final List<String> utensils = ["인버터", "가스레인지", "전자레인지", "에어프라이어", "오븐"];
  String? selectedValue;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late final UserSelections userSelections = widget.userSelections;

  void onNextTap() {
    if (_formKey1.currentState!.validate() &&
        _formKey2.currentState!.validate() &&
        selectedIngredient != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategorySelectScreen(
            userSelections: userSelections,
          ),
        ),
      );
    } else {
      // 유효성 검사에 실패한 경우, 경고 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          '모든 항목을 선택해주세요!',
          style: GoogleFonts.nanumGothic(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
      );
    }
  }

  void selectIngredient(String ingredient) {
    setState(() {
      // UI의 선택된 식재료를 업데이트
      selectedIngredient = ingredient;

      // UserSelections에 선택된 메인 식재료를 업데이트
      userSelections.selectMainIngredient(ingredient);
    });
  }

  void onMainCategorySelected(String category) {
    // 인스턴스를 통해 메서드를 호출합니다.
    setState(() {
      userSelections.mainCategoryServings(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 카테고리 선택',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        titleTextStyle: GoogleFonts.nanumGothic(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gaps.v60,
              const Text(
                "1. 인분을 선택해주세요.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gaps.v32,
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '인분을 선택해주세요.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        hint: const Text(
                          '인분 선택',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: servings
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
                        onChanged: (value) {
                          // 해당 값을 UserSelections의 maincategoryFoodtype에 저장합니다.
                          setState(() {
                            userSelections.mainCategoryServings(value);
                            _formKey1.currentState!.validate();
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
                      Gaps.v32
                    ],
                  ),
                ),
              ),
              Gaps.v32,
              const Text(
                "2. 조리에 사용하실 조리도구를 선택해주세요.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gaps.v32,
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '조리도구를 선택해주세요.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        hint: const Text(
                          '조리도구',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: utensils
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
                        onChanged: (value) {
                          // 해당 값을 UserSelections의 maincategoryUtensil에 저장합니다.
                          setState(() {
                            userSelections.mainCategoryUtensil(value);
                            _formKey1.currentState!.validate();
                            _formKey2.currentState!.validate();
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
                      Gaps.v40
                    ],
                  ),
                ),
              ),
              Gaps.v32,
              const Text(
                '3. 메인 식재료를 선택해주세요.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v32,
              Wrap(
                spacing: 10.0, // gap between adjacent chips
                runSpacing: 10.0, // gap between lines
                children: widget.ingredients
                    .map((ingredient) => InterestButton(
                          interest: ingredient,
                          isSelected:
                              selectedIngredient == ingredient, // 변경된 부분
                          onSelected: selectIngredient, // 변경된 부분
                        ))
                    .toList(),
              ),
            ],
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
                    "다음",
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
