import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  _AnimatedGradientBackgroundState createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> {
  List<List<Color>> gradientColors = [
    [Color(0xFFAAC4FF), Color(0xFFF3A6A6)], // Blue → Pink
    [Color(0xFFFDE2E4), Color(0xFFAAC4FF)], // Pink → Blue
    [Color(0xFFAAC4FF), Color(0xFFE3EAFD)], // Blue → Lighter Blue
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startGradientAnimation();
  }

  void _startGradientAnimation() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % gradientColors.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 3),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors[currentIndex],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:  widget.child
    );
  }
}
