import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';

import 'package:fridgeat/features/onboarding/tutorial_screen.dart';
import 'package:fridgeat/features/onboarding/widgets/interest_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:google_fonts/google_fonts.dart';

class SetSeasoningSpiceryScreen extends StatefulWidget {
  final bool hideNavigationBar;
  final bool accessFromOtherScreen;

  final bool accessedByCameraScreen;
  final UserSelections userSelections;

  const SetSeasoningSpiceryScreen({
    Key? key,
    this.hideNavigationBar = true,
    this.accessFromOtherScreen = false,
    this.accessedByCameraScreen = false,
    required this.userSelections,
  }) : super(key: key);

  @override
  State<SetSeasoningSpiceryScreen> createState() =>
      _SetSeasoningSpiceryScreenState();
}

class _SetSeasoningSpiceryScreenState extends State<SetSeasoningSpiceryScreen> {
  double currentOffset = 0;
  String currentAppBarTitle = "가지고 계신 조미료를 선택해주세요";
  bool _isAddingSeasoning = false;
  bool _isAddingSpicery = false;
  final TextEditingController _seasoningTextController =
      TextEditingController();
  final TextEditingController _spiceryTextController = TextEditingController();
  List<String> selectedSeasonings = [];
  List<String> selectedSpiceries = [];
  late final UserSelections userSelections = UserSelections();
  final FocusNode _seasoningFocusNode = FocusNode();
  final FocusNode _spiceryFocusNode = FocusNode();

  List<String> seasonings = [
    "소금",
    "후추",
    "설탕",
    "고춧가루",
    "깨",
  ];

  List<String> spiceries = [
    "다진마늘",
    "고추장",
    "된장",
    "케첩",
    "마요네즈",
  ];

  @override
  void initState() {
    super.initState();

    selectedSeasonings = widget.userSelections.seasonings;
    selectedSpiceries = widget.userSelections.spiceries;

    // 중복을 제거하고 추가된 항목들을 기본 리스트에 포함시킵니다.
    for (var seasoning in widget.userSelections.seasonings) {
      if (!seasonings.contains(seasoning)) {
        seasonings.add(seasoning);
      }
    }

    for (var spicery in widget.userSelections.spiceries) {
      if (!spiceries.contains(spicery)) {
        spiceries.add(spicery);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onNextTap() {
    // UserSelections 객체를 사용하여 선택된 항목을 업데이트
    widget.userSelections.updateSeasonings(selectedSeasonings);
    widget.userSelections.updateSpiceries(selectedSpiceries);
    print("selectedSeasonings: $selectedSeasonings");
    print("selectedSpiceries: $selectedSpiceries");
    print("userSelections.seasonings: ${widget.userSelections.seasonings}");
    print("userSelections.spiceries: ${widget.userSelections.spiceries}");
    Navigator.pushReplacement(
      // pushReplacement를 사용하여 현재 화면을 스택에서 제거합니다.
      context,
      MaterialPageRoute(
        builder: (context) => TutorialScreen(
          selectedSeasonings: selectedSeasonings, // 선택된 조미료를 전달
          selectedSpiceries: selectedSpiceries, // 선택된 양념류를 전달
          userSelections: userSelections,
        ),
      ),
    );
  }

  void onBack() {
    // 업데이트된 조미료와 양념 리스트를 이전 화면으로 반환합니다.
    Navigator.pop(context, {
      'selectedSeasonings': selectedSeasonings,
      'selectedSpiceries': selectedSpiceries,
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: GoogleFonts.nanumGothic(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          automaticallyImplyLeading: false,
          leading: widget.accessedByCameraScreen
              ? Container()
              : null, // 비슷한 크기의 컨테이너 추가

          actions: <Widget>[
            if (widget.accessedByCameraScreen)
              Padding(
                padding: const EdgeInsets.only(right: 17),
                child: InkWell(
                  onTap: () {
                    onBack();
                  },
                  splashColor: Colors.transparent, // Splash 효과를 투명하게 설정
                  highlightColor: Colors.transparent, // Highlight 효과를 투명하게 설정
                  child: const Padding(
                    padding: EdgeInsets.only(right: 17),
                    child: Icon(
                      FontAwesomeIcons.chevronDown,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
          title: Text(
            "가지고 있는 조미료와 양념 선택하기",
            style: TextStyle(
                fontSize: widget.accessedByCameraScreen ? 14 : 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800),
          ),
          centerTitle: true,
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Sizes.size40,
                right: Sizes.size40,
                bottom: Sizes.size32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v40,
                  const Text(
                    "조미료",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  Gaps.v20,
                  const Text(
                    "선택하신 조미료는 레시피 추천 과정에 반영됩니다.",
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.start,
                  ),
                  Gaps.v40,
                  Wrap(
                    spacing: 15,
                    runSpacing: 30,
                    children: [
                      // 기존 조미료를 위한 InterestButton들을 추가합니다.
                      ...seasonings.map((seasoning) {
                        return InterestButton(
                          interest: seasoning,
                          isSelected: selectedSeasonings.contains(seasoning),
                          onSelected: (selected) {
                            setState(() {
                              if (selectedSeasonings.contains(seasoning)) {
                                selectedSeasonings.remove(seasoning);
                              } else {
                                selectedSeasonings.add(seasoning);
                                widget.userSelections
                                    .updateSeasonings(selectedSeasonings);
                              }
                              _isAddingSeasoning = false;
                            });
                          },
                        );
                      }).toList(),
                      // 조미료를 추가하는 TextField 또는 추가 버튼을 조건부로 추가합니다.
                      if (_isAddingSeasoning)
                        SizedBox(
                          height: 50,
                          child: TextField(
                            focusNode: _seasoningFocusNode,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _seasoningTextController,
                            onSubmitted: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  seasonings.add(value);
                                  _seasoningTextController.clear();
                                }
                                _isAddingSeasoning =
                                    false; // 사용자가 엔터를 누르면 TextField가 사라집니다.
                              });
                            },
                            decoration: InputDecoration(
                              hintText: '조미료를 추가하세요...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 16.0, top: 10.0, bottom: 10.0), // 패딩 설정

                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size32),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size32),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          alignment: Alignment.center,
                          width: 60,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Sizes.size32),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.only(bottom: 1),
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _isAddingSeasoning = true;
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                FocusScope.of(context)
                                    .requestFocus(_seasoningFocusNode);
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  Gaps.v96,
                  const Text(
                    "양념류",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  Gaps.v20,
                  const Text(
                    "선택하신 양념은 레시피 추천 과정에 반영됩니다.",
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.start,
                  ),
                  Gaps.v40,
                  Wrap(
                    spacing: 15,
                    runSpacing: 30,
                    children: [
                      // 기존 조미료를 위한 InterestButton들을 추가합니다.
                      ...spiceries.map((seasoning) {
                        return InterestButton(
                          interest: seasoning,
                          isSelected: selectedSpiceries.contains(seasoning),
                          onSelected: (selected) {
                            setState(() {
                              if (selectedSpiceries.contains(seasoning)) {
                                selectedSpiceries.remove(seasoning);
                              } else {
                                selectedSpiceries.add(seasoning);
                                widget.userSelections
                                    .updateSpiceries(selectedSpiceries);
                              }
                            });
                          },
                        );
                      }).toList(),
                      // 조미료를 추가하는 TextField 또는 추가 버튼을 조건부로 추가합니다.
                      if (_isAddingSpicery)
                        SizedBox(
                          height: 50,
                          child: TextField(
                            focusNode: _spiceryFocusNode,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _spiceryTextController,
                            onSubmitted: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  spiceries.add(value);

                                  _spiceryTextController.clear();
                                }
                                _isAddingSpicery =
                                    false; // 사용자가 엔터를 누르면 TextField가 사라집니다.
                              });
                            },
                            decoration: InputDecoration(
                              hintText: '조미료를 추가하세요...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 16.0, top: 10.0, bottom: 10.0), // 패딩 설정
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size32),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size32),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 60,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Sizes.size32),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.only(bottom: 1),
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _isAddingSpicery = true;
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                FocusScope.of(context)
                                    .requestFocus(_spiceryFocusNode);
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  Gaps.v96,
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
                      "다음",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
