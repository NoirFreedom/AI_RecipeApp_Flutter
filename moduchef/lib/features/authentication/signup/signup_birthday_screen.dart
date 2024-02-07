import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';
import 'package:fridgeat/features/authentication/signup/signup_view_model.dart';
import 'package:fridgeat/features/authentication/widgets/form_button.dart';
import 'package:fridgeat/features/onboarding/select_seasoning_spiceries_screen.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenScreenState();
}

class _BirthdayScreenScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime currentDate = DateTime.now();
  DateTime get _initialDate =>
      DateTime(currentDate.year - 19, currentDate.month, currentDate.day);

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(_initialDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    ref.read(signUpProvider.notifier).signUp();

    UserSelections userSelections = UserSelections();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>
            SetSeasoningSpiceryScreen(userSelections: userSelections),
      ),
      (route) => false,
    );
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ")[0];
    _birthdayController.value = TextEditingValue(text: textDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: GoogleFonts.nanumGothic(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        title: const Text(
          '회원가입',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              '생년월일 입력',
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v10,
            const Text(
              "입력하신 생일은 공개되지 않습니다.",
              style: TextStyle(
                fontSize: Sizes.size12,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              enabled: false,
              controller: _birthdayController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(disabled: ref.watch(signUpProvider).isLoading),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: SizedBox(
        height: 200,
        child: CupertinoDatePicker(
          maximumDate: currentDate,
          initialDateTime: _initialDate,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: _setTextFieldDate,
        ),
      )),
    );
  }
}
