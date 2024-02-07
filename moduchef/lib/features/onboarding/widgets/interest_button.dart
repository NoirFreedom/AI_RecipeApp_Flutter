import 'package:flutter/material.dart';
import 'package:fridgeat/constants/sizes.dart';

class InterestButton extends StatefulWidget {
  final String interest;
  final bool isSelected; // 추가된 부분
  final Function(String) onSelected;

  const InterestButton({
    super.key,
    required this.interest,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<InterestButton> createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(widget.interest); // 추가된 부분
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(
            vertical: Sizes.size12, horizontal: Sizes.size16),
        decoration: BoxDecoration(
            color: widget.isSelected ? Colors.blueGrey.shade400 : Colors.white,
            borderRadius: BorderRadius.circular(
              Sizes.size32,
            ),
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                spreadRadius: 2,
              )
            ]),
        child: Text(
          widget.interest,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: widget.isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
