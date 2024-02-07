import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';
import 'package:fridgeat/features/main_screen/camera_screen.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:fridgeat/main.dart';

FlutterVision vision = FlutterVision();

class TutorialScreen extends StatefulWidget {
  final UserSelections? userSelections;
  final List<String> selectedSeasonings;
  final List<String> selectedSpiceries;

  const TutorialScreen(
      {super.key,
      required this.userSelections,
      required this.selectedSeasonings,
      required this.selectedSpiceries});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  void _onEnterAppTap() {
    print(widget.selectedSeasonings);
    print(widget.selectedSpiceries);
    userSelections.updateSeasonings(widget.selectedSeasonings);
    userSelections.updateSpiceries(widget.selectedSpiceries);
    Navigator.pushReplacement(
      // pushReplacement를 사용하여 현재 화면을 스택에서 제거합니다.
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          selectedSeasonings: widget.selectedSeasonings, // 선택된 조미료를 전달
          selectedSpiceries: widget.selectedSpiceries, // 선택된 양념류를 전달
          userSelections: userSelections,
          vision: vision,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.size24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v80,
              Text(
                '모든 준비가 완료 되었습니다.',
                style: TextStyle(fontSize: 31, fontWeight: FontWeight.w800),
              ),
              Gaps.v20,
              Text(
                "Please make sure that you have read all the terms.",
                style: TextStyle(
                  fontSize: Sizes.size14,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Sizes.size24, horizontal: Sizes.size24),
          child: CupertinoButton(
            onPressed: _onEnterAppTap,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(30),
            child: const Text(
              "앱 시작하기",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ),
    );
  }
}
