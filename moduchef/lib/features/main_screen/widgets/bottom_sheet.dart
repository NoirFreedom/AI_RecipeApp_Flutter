import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/features/category_select_screen/maincategory_select_screen.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';

class CustomBottomSheet extends StatefulWidget {
  final List<String> ingredients;
  final bool isExpanded;
  final VoidCallback onToggle;
  final UserSelections userSelections;
  final Function stopObjectDetection;

  const CustomBottomSheet(
      {super.key,
      required this.ingredients,
      required this.isExpanded,
      required this.onToggle,
      required this.userSelections,
      required this.stopObjectDetection});

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  double? sheetHeight;
  bool sheetExpanded = false;
  bool isLoading = false;
  Map<int, FocusNode> focusNodes = {};
  Map<int, TextEditingController> textControllers = {};
  double opacity = 0.0; // 애니메이션을 위한 opacity 변수 추가
  late final UserSelections userSelections = widget.userSelections;

  // Track the editing mode for each ingredient
  Map<int, bool> editingModes = {}; // 로딩 상태를 저장할 변수

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(CustomBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sheetHeight = MediaQuery.of(context).size.height * 0.1;
  }

  void _toggleSheetExpansion() {
    setState(() {
      if (sheetExpanded) {
        sheetHeight = MediaQuery.of(context).size.height * 0.1;
        opacity = 0.0; // 애니메이션을 위한 opacity 값 변경
      } else {
        sheetHeight = MediaQuery.of(context).size.height * 0.80;
        opacity = 1.0; // 애니메이션을 위한 opacity 값 변경
      }
      sheetExpanded = !sheetExpanded;
    });
  }

  bool isCompletedText(String text) {
    // 한글 완성형 글자에 대한 정규식 패턴
    const Pattern pattern = r'^[\uAC00-\uD7A3]+$';
    RegExp regex = RegExp(pattern.toString());

    // 모든 글자가 한글 완성형인지 확인
    return regex.hasMatch(text);
  }

  void _addNewIngredient() async {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // 식재료 추가 대화 상자를 반복적으로 표시할 수 있도록 함수로 정의
    Future<void> showAddIngredientDialog() async {
      await showDialog(
        context: context,
        barrierDismissible: false, // 사용자가 대화 상자 바깥을 터치했을 때 닫히지 않도록 설정
        builder: (BuildContext dialogContext) {
          // StatefulBuilder를 사용하여 대화 상자 내부의 상태를 변경할 수 있도록 함
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20.0), // 원하는 BorderRadius 값 설정
                ),
                title: const Text(
                  '새로운 식재료 추가',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: controller,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: '식재료 이름을 추가하세요',
                              hintStyle: TextStyle(fontSize: 12),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              // 여기에서 입력값 검증 로직을 추가합니다.
                              if (value == null || value.isEmpty) {
                                return '식재료를 입력해주세요';
                              }
                              if (!isCompletedText(value)) {
                                return '완성형 글자만 입력가능합니다';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Gaps.v24,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // 대화 상자 닫기
                          },
                          child: Text('취소',
                              style: TextStyle(
                                  color: Colors.red.shade300,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Gaps.h12,
                        TextButton(
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // 입력값 검증
                              String value = controller.text.trim(); // 공백 제거
                              // 리스트에 이미 존재하는지 확인
                              if (!widget.ingredients.contains(value)) {
                                // 리스트에 식재료 추가
                                setState(() {
                                  widget.ingredients.add(value);
                                });
                                Navigator.of(dialogContext).pop(); // 대화 상자 닫기
                              } else {
                                // 중복된 식재료에 대한 경고 메시지 표시
                                await showDialog(
                                  context: dialogContext,
                                  builder: (BuildContext alertContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      title: const Text(
                                        "중복된 식재료",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        "$value 은(는) 이미 리스트에 존재합니다.",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(alertContext)
                                                .pop(); // 경고 창 닫기
                                          },
                                          child: const Text(
                                            '확인',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: const Text('추가',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }

    // 식재료 추가 대화 상자를 표시
    await showAddIngredientDialog();

    // 상태 갱신
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      duration: const Duration(milliseconds: 300), // 키보드 애니메이션 시간에 맞춥니다.
      curve: Curves.easeOut, // 부드러운 애니메이션을 위한 커브
      child: Stack(
        children: [
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: GestureDetector(
              child: AnimatedContainer(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: sheetExpanded
                    ? MediaQuery.of(context).size.height * 0.5 +
                        MediaQuery.of(context)
                            .viewInsets
                            .bottom // 키보드 높이를 더합니다.
                    : MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    IconButton(
                      iconSize: 20,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: FaIcon(sheetExpanded
                          ? FontAwesomeIcons.chevronDown
                          : FontAwesomeIcons.chevronUp),
                      onPressed: _toggleSheetExpansion,
                    ),
                    if (sheetExpanded & widget.ingredients.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "현재까지 추가된 식재료 리스트",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade700),
                        ),
                      ),
                    !sheetExpanded
                        ? Text(
                            "추가된 식재료 확인하기",
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 12),
                          )
                        : Container(),
                    Expanded(
                      child: sheetExpanded
                          ? widget.ingredients.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 90),
                                  child: Center(
                                    child: Text(
                                      "추가된 식재료가 없습니다.",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 120),
                                  itemCount: widget.ingredients.length,
                                  itemBuilder: (context, index) {
                                    // 마지막 항목이고 재료 리스트가 비어 있지 않으면 추천 컨테이너를 반환
                                    if (index == widget.ingredients.length) {
                                      if (widget.ingredients.isNotEmpty) {}
                                      return const SizedBox
                                          .shrink(); // 아무것도 반환하지 않는 경우
                                    }
                                    // 그렇지 않은 경우 기존의 항목을 반환
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 30),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const Border.fromBorderSide(
                                            BorderSide.none),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.25), // 그림자의 색상과 불투명도
                                            spreadRadius: 0, // 그림자의 범위
                                            blurRadius: 4, // 그림자의 블러 정도
                                            offset:
                                                const Offset(0, 2), // 그림자의 위치
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: editingModes[index] == true
                                            ? TextField(
                                                controller: textControllers[
                                                        index] ??=
                                                    TextEditingController(
                                                        text:
                                                            widget.ingredients[
                                                                index]),
                                                focusNode: focusNodes[index] ??=
                                                    FocusNode(),
                                                onSubmitted: (newValue) {
                                                  setState(() {
                                                    widget.ingredients[index] =
                                                        newValue;
                                                    editingModes[index] = false;
                                                    focusNodes[index]
                                                        ?.unfocus();
                                                  });
                                                },
                                                autofocus: true,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              )
                                            : Text(
                                                widget.ingredients[index],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                editingModes[index] == true
                                                    ? Icons.check
                                                    : FontAwesomeIcons
                                                        .penToSquare,
                                                size: 18,
                                                color: Colors.grey.shade700,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (editingModes[index] ==
                                                      true) {
                                                    widget.ingredients[index] =
                                                        textControllers[index]
                                                                ?.text ??
                                                            widget.ingredients[
                                                                index];
                                                    editingModes[index] = false;
                                                    focusNodes[index]
                                                        ?.unfocus();
                                                  } else {
                                                    editingModes[index] = true;
                                                    focusNodes[index]
                                                        ?.requestFocus();
                                                  }
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close,
                                                  color: Colors.grey.shade700),
                                              onPressed: () {
                                                setState(() {
                                                  widget.ingredients
                                                      .removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 'sheetExpanded'가 true일 때만 하단 바 표시
          if (sheetExpanded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                elevation: 0.0,
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 'plus' 아이콘 버튼
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff202124), // Container의 배경색
                          shape: BoxShape.circle, // 원형 모양
                        ),
                        child: IconButton(
                          icon: const Icon(FontAwesomeIcons.plus,
                              color: Colors.white),
                          iconSize: 28,
                          onPressed: _addNewIngredient,
                        ),
                      ),

                      // 'share' 아이콘 버튼
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff202124), // Container의 배경색
                          shape: BoxShape.circle, // 원형 모양
                        ),
                        child: IconButton(
                          icon: const Icon(FontAwesomeIcons.share,
                              color: Colors.white),
                          onPressed: () {
                            debugPrint(
                                'Seasonings: ${userSelections.seasonings}');
                            debugPrint(
                                'Spiceries: ${userSelections.spiceries}');
                            debugPrint('ingredients: ${widget.ingredients}');

                            if (widget.ingredients.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // 원하는 BorderRadius 값 설정
                                  ),
                                  title: const Text(
                                    "알림",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Gaps.v8,
                                      const Text(
                                        "추가된 식재료가 없습니다. 식재료를 추가해 주세요.",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Gaps.v32,
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          splashFactory: NoSplash.splashFactory,
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          "확인",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              for (var ingredient in widget.ingredients) {
                                userSelections.addIngredient(ingredient);
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainCategorySelectScreen(
                                    ingredients: widget.ingredients,
                                    userSelections: userSelections,
                                  ),
                                ),
                              );
                            }
                            widget.stopObjectDetection();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
