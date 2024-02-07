import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/constants/sizes.dart';
import 'package:fridgeat/features/authentication/login/login_screen.dart';
import 'package:fridgeat/features/authentication/signup/signup_username_screen.dart';
import 'package:fridgeat/features/authentication/widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) {
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _onEmailSignUpTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
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
                '회원가입',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v24,
              const Text(
                '계정을 만들어 더 많은 기능을 이용하세요.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v60,
              AuthButton(
                  onTapFunction: _onEmailSignUpTap,
                  icon: const FaIcon(FontAwesomeIcons.user),
                  text: '이메일 & 비밀번호로 회원가입'),
              Gaps.v16,
              AuthButton(
                  onTapFunction: _navigateToEmptyScreen,
                  icon: const FaIcon(FontAwesomeIcons.google),
                  text: 'Google 계정으로 회원가입'),
              Gaps.v16,
              AuthButton(
                  onTapFunction: _navigateToEmptyScreen,
                  icon: const FaIcon(FontAwesomeIcons.apple),
                  text: 'Apple 계정으로 회원가입'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '이미 계정이 있으신가요?',
                style: TextStyle(
                  fontSize: Sizes.size12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onLoginTap(context),
                child: Text(
                  '로그인',
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
