import 'package:flutter/material.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';
import 'package:fridgeat/features/authentication/signup/signup_email_screen.dart';
import 'package:fridgeat/features/authentication/widgets/form_button.dart';
import 'package:google_fonts/google_fonts.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  String _username = "";

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onNextTap() {
    if (_username.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
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
                '유저이름 설정',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v10,
              const Text(
                '앱 내에서 사용할 이름을 설정해주세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: const TextStyle(fontSize: 14),
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
                  child: FormButton(disabled: _username.isEmpty))
            ],
          ),
        ),
      ),
    );
  }
}
