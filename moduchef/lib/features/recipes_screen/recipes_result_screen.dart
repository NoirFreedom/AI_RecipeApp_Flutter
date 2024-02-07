import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

import 'package:fridgeat/constants/gaps.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipesResultScreen extends StatefulWidget {
  final String recipes;

  const RecipesResultScreen({
    Key? key,
    required this.recipes,
  }) : super(key: key);

  @override
  State<RecipesResultScreen> createState() => _RecipesResultScreenState();
}

class _RecipesResultScreenState extends State<RecipesResultScreen> {
  String? selectedImage;
  List<Widget> iconsList = []; // 아이콘 리스트를 위한 변수

  @override
  void initState() {
    super.initState();
    selectImageBasedOnDifficulty();
  }

  void selectImageBasedOnDifficulty() {
    if (widget.recipes.contains("초급")) {
      selectedImage = 'noviceImg${Random().nextInt(6) + 1}.jpg';
      iconsList = [
        FaIcon(FontAwesomeIcons.solidStar,
            size: 14, color: Colors.grey.shade800),
        Gaps.h7,
        FaIcon(FontAwesomeIcons.star, size: 13, color: Colors.grey.shade800),
        Gaps.h7,
        FaIcon(FontAwesomeIcons.star, size: 13, color: Colors.grey.shade800),
      ];
    } else if (widget.recipes.contains("중급")) {
      selectedImage = 'intermediateImg${Random().nextInt(2) + 1}.jpg';
      iconsList = [
        FaIcon(FontAwesomeIcons.solidStar,
            size: 13, color: Colors.grey.shade800),
        Gaps.h7,
        FaIcon(FontAwesomeIcons.solidStar,
            size: 13, color: Colors.grey.shade800),
        Gaps.h7,
        FaIcon(FontAwesomeIcons.star, size: 13, color: Colors.grey.shade800),
      ];
    } else if (widget.recipes.contains("고급")) {
      selectedImage = 'advancedImg${Random().nextInt(2) + 1}.jpg';
      iconsList = [
        FaIcon(FontAwesomeIcons.solidStar,
            size: 13, color: Colors.grey.shade800),
        Gaps.h7,
        FaIcon(FontAwesomeIcons.solidStar,
            size: 13, color: Colors.grey.shade800),
        Gaps.h7,
        FaIcon(FontAwesomeIcons.solidStar,
            size: 13, color: Colors.grey.shade800),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsList = [];

    bool isIngredientSection = false;
    bool isMethodSection = false;
    List<Widget> ingredientWidgets = [];
    List<Widget> methodWidgets = [];

    for (String line in widget.recipes.split('\n')) {
      line = line.replaceAll(":", "");

      if (line.startsWith("요리제목") || line.startsWith("요리 제목")) {
        // '요리제목' 텍스트를 제거하고 제목만 추출
        String recipeTitle = line.replaceFirst(RegExp("요리제목|요리 제목"), "").trim();
        widgetsList.add(
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: Text(
              recipeTitle,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
          ),
        );
      } else if (line.startsWith("요리설명") || line.startsWith("요리 설명")) {
        String recipeDescription =
            line.replaceFirst(RegExp("요리설명|요리 설명"), "").trim();
        widgetsList.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0, left: 3, right: 3),
            child: Text(
              recipeDescription,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade700, height: 1.5),
            ),
          ),
        );
      } else if (line.startsWith("난이도")) {
        Widget recipeDifficulty = Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                line.replaceFirst(RegExp("초급|중급|고급"), ""),
                style: GoogleFonts.nanumGothic(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Gaps.h10,
            ...iconsList, // 아이콘 리스트를 여기에 추가
          ],
        );

        widgetsList.add(
          recipeDifficulty,
        );
      } else if (line.startsWith("소요시간")) {
        String remainingText = line.replaceFirst("소요시간", "");
        widgetsList.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "소요시간",
                      style: GoogleFonts.nanumGothic(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    TextSpan(
                      text: "     ⏱️  $remainingText", // 이 부분에서 간격을 조정합니다.
                      style: GoogleFonts.nanumGothic(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (line.startsWith("인분")) {
        String remainingText = line.replaceFirst("인분", "");
        widgetsList.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "분량",
                      style: GoogleFonts.nanumGothic(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    TextSpan(
                      text: "   $remainingText", // 이 부분에서 간격을 조정합니다.
                      style: GoogleFonts.nanumGothic(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (line.startsWith("기본재료")) {
        if (isMethodSection) {
          widgetsList.add(createSectionContainer(methodWidgets, false));
          methodWidgets.clear();
          isMethodSection = false;
        }
        // 기본 재료 제목 위젯 추가
        ingredientWidgets.add(
          const Padding(
            padding: EdgeInsets.only(top: 30, bottom: 5),
            child: Text(
              "기본재료", // '기본 재료' 제목 설정
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );

        // 재료 목록을 별도의 Text 위젯으로 추가
        ingredientWidgets.add(
          Text(
            line.replaceFirst("기본재료", ""), // 재료 목록 여기에 표시
            style: const TextStyle(fontSize: 13), // 스타일 조정 가능
          ),
        );
        isIngredientSection = true;
      } else if (line.startsWith("조리방법")) {
        if (isIngredientSection) {
          widgetsList.add(createSectionContainer(ingredientWidgets, true));
          ingredientWidgets.clear();
          isIngredientSection = false;
        }
        methodWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 15),
            child: Text(
              line,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
        isMethodSection = true;
      } else {
        if (isIngredientSection) {
          ingredientWidgets.add(
            Text(line, style: const TextStyle(fontSize: 14, height: 2)),
          );
        } else if (isMethodSection) {
          if (RegExp(r'^\d+\.').hasMatch(line)) {
            // 숫자로 시작하는지 확인
            // 숫자 앞에 "단계" 단어 추가
            line = 'Step $line';
          }
          methodWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child:
                  Text(line, style: const TextStyle(fontSize: 14, height: 1.5)),
            ),
          );
        }
      }
    }

    if (isIngredientSection) {
      widgetsList.add(createSectionContainer(ingredientWidgets, true));
    }
    if (isMethodSection) {
      widgetsList.add(createSectionContainer(methodWidgets, false));
    }

//레시피 원본 텍스트 보기
    // for (String line in widget.recipes.split('\n')) {
    //   widgetsList.add(
    //     Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 5),
    //       child: Text(line, style: const TextStyle(fontSize: 14)),
    //     ),
    //   );
    // }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                if (selectedImage != null)
                  Image.asset(
                    'assets/images/$selectedImage',
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgetsList,
                  ),
                ),
                Gaps.v32
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              color: Colors.white,
              icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 24),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget createSectionContainer(List<Widget> sectionWidgets,
      [bool isIngredient = true]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sectionWidgets.map((widget) {
        if (widget is Text && !isIngredient) {
          return Text(widget.data ?? '', style: const TextStyle(fontSize: 13));
        }
        return widget;
      }).toList(),
    );
  }
}
