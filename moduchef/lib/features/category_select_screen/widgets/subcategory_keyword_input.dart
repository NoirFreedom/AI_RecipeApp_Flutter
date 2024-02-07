import 'package:flutter/material.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';

class KeywordInput extends StatefulWidget {
  final UserSelections userSelections;

  const KeywordInput({
    Key? key,
    required this.userSelections,
  }) : super(key: key);

  @override
  _KeywordInputState createState() => _KeywordInputState();
}

class _KeywordInputState extends State<KeywordInput> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _keywords = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserSelections userSelections = UserSelections();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Text("3. 추가하고 싶은 키워드가 있다면 입력해주세요.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            Gaps.v16,
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "키워드 입력 (최대 3개)",
                  hintStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 2.0, color: Colors.blue),
                  ),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _controller.clear();
                            FocusScope.of(context).unfocus(); // 포커스 해제

                            setState(() {});
                          },
                        ),
                ),
                onSaved: (text) {
                  // 해당 값을 UserSelections의 subcategoryKeywords에 저장합니다.
                  userSelections.subcategoryKeywords = text;
                },
                validator: (value) {
                  final regex =
                      RegExp(r'^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣\s\p{P}\p{S}]{0,10}$');

                  if (value == null || value.isEmpty) {
                    if (_controller.text.isNotEmpty) {
                      return '키워드를 입력해주세요.';
                    } else {
                      return null;
                    }
                  } else if (value.contains(' ')) {
                    return '띄어쓰기를 사용할 수 없습니다.';
                  } else if (value.length > 10) {
                    return '10자 이상 작성할 수 없습니다.';
                  } else if (!regex.hasMatch(value)) {
                    return '특수문자를 사용할 수 없습니다.';
                  } else if (_keywords.contains(value)) {
                    return '이미 추가된 키워드입니다.';
                  } else if (_keywords.length >= 3) {
                    return '키워드는 최대 3개까지만 추가 가능합니다.';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  // Form의 현재 상태가 유효한지 검사
                  if (_formKey.currentState?.validate() ?? false) {
                    // 유효성 검사가 성공하면 키워드 추가
                    if (_keywords.length < 3 && value.isNotEmpty) {
                      setState(() {
                        _keywords.add(value);
                        widget.userSelections.subcategoryKeywords =
                            _keywords.join(', '); // 쉼표로 구분된 문자열로 변환하여 저장합니다.
                        _controller.clear();
                      });
                    }
                  }
                },
              ),
            ),
            Gaps.v20,
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _keywords.map((keyword) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 10, top: 7, bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade700,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(keyword,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _keywords.remove(keyword);
                          });
                        },
                        child: const Icon(Icons.close,
                            size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
