import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';
import 'package:fridgeat/features/authentication/login/login_form_screen.dart';
import 'package:fridgeat/features/authentication/signup/sign_up_sceen.dart';
import 'package:fridgeat/features/authentication/widgets/auth_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onEmailLoginTap(BuildContext context) async {
    // await signInWithEmailAndPassword('example@email.com', 'password');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  void _onSignUpTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _navigateToEmptyScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Scaffold()), // 빈 Scaffold를 이용하여 빈 화면 표시
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                '로그인',
                style: TextStyle(
                  fontSize: Sizes.size28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v24,
              const Text(
                '자신의 레시피를 관리하고, 더 많은 기능을 이용하세요.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v60,
              GestureDetector(
                onTap: () => _onEmailLoginTap(context),
                child: AuthButton(
                    onTapFunction: _onEmailLoginTap,
                    icon: const FaIcon(FontAwesomeIcons.user),
                    text: '이메일 & 비밀번호로 로그인'),
              ),
              Gaps.v16,
              AuthButton(
                  onTapFunction: _navigateToEmptyScreen,
                  icon: const FaIcon(FontAwesomeIcons.google),
                  text: 'Google 계정으로 로그인'),
              Gaps.v16,
              AuthButton(
                  onTapFunction: _navigateToEmptyScreen,
                  icon: const FaIcon(FontAwesomeIcons.apple),
                  text: 'Apple 계정으로 로그인'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade100,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "아직 계정이 없으신가요?",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onSignUpTap(context),
                child: Text(
                  '회원가입',
                  style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
