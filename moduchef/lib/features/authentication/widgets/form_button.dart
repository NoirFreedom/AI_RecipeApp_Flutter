import 'package:flutter/material.dart';
import 'package:fridgeat/constants/sizes.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.disabled,
  });

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        alignment: Alignment.center,
        height: 44,
        decoration: BoxDecoration(
            color: disabled
                ? Colors.grey.shade300
                : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Sizes.size20)),
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
                color: disabled ? Colors.grey.shade500 : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300),
            child: const Text(
              "다음",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
