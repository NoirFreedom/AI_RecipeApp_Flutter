import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fridgeat/constants/sizes.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final FaIcon icon;
  final void Function(BuildContext) onTapFunction;

  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapFunction(context),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: Sizes.size14, horizontal: Sizes.size32),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: Sizes.size1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: icon,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
