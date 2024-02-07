import 'package:flutter/material.dart';
import 'package:fridgeat/constants/gaps.dart';
import 'package:fridgeat/features/authentication/widgets/form_button.dart';
import 'package:fridgeat/features/onboarding/select_seasoning_spiceries_screen.dart';
import 'package:fridgeat/features/recipes_screen/%08user_selections.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};
  bool _obscureText = true;

  String? _isIdEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final regExp = RegExp(
        r"^[a-zA-Z0-9!#$%^&*()_+\-={}|[\];':,./<>?]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regExp.hasMatch(value)) {
      return "Invalid email format.";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    final regExp = RegExp(r'[^A-Za-z0-9]');
    if (!regExp.hasMatch(value)) {
      return "Password must include a special character";
    }
    return null;
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
// UserSelections 객체 생성
        UserSelections userSelections = UserSelections();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                SetSeasoningSpiceryScreen(userSelections: userSelections),
          ),
          (route) => false,
        );
      }
    }
  }

  void _toggleObscureText() {
    _obscureText = !_obscureText;
    setState(() {});
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
          title: const Text("로그인"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gaps.v28,
                const Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Gaps.v20,
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                  validator: _isIdEmail,
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['email'] = newValue;
                    }
                  },
                ),
                Gaps.v16,
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _obscureText,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                  validator: _validatePassword,
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData['password'] = newValue;
                    }
                  },
                ),
                Gaps.v28,
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: const FormButton(disabled: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
