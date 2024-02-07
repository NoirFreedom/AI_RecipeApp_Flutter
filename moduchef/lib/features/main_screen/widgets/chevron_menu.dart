import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fridgeat/constants/gaps.dart';

class ChevronMenu extends StatefulWidget {
  const ChevronMenu({super.key});

  @override
  _ChevronMenuState createState() => _ChevronMenuState();
}

class _ChevronMenuState extends State<ChevronMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(5, (index) {
          if (index < 3) {
            return const Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.paperPlane,
                  color: Colors.white,
                  size: 14,
                ),
                Gaps.v28,
                SizedBox(width: 8.0),
                Text(
                  'Label',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            );
          }
          return FadeTransition(
            opacity: _animation,
            child: SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1,
              child: const Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.paperPlane,
                    color: Colors.white,
                    size: 14,
                  ),
                  Gaps.v28,
                  SizedBox(width: 8.0),
                  Text(
                    'Label',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }),
        IconButton(
          icon: FaIcon(
            _isExpanded
                ? FontAwesomeIcons.chevronUp
                : FontAwesomeIcons.chevronDown,
            size: 14,
            color: Colors.white,
          ),
          onPressed: _toggleMenu,
        ),
      ],
    );
  }

  void _toggleMenu() {
    setState(() {
      if (_controller.isCompleted) {
        _controller.reverse();
        _isExpanded = false;
      } else {
        _controller.forward();
        _isExpanded = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
