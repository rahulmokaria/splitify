import 'dart:ui';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:splitify/ui/utils/colors.dart';

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  final double borderRadius;
  final Color accent;
  const GlassMorphism({
    Key? key,
    required this.child,
    required this.start,
    required this.end,
    required this.borderRadius,
    this.accent=white
  }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(start),
                accent.withOpacity(end),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            border: Border.all(
              width: 1.5,
              color: accent.withOpacity(0.2),
            ),
          ),
          child: Container(
            decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: borderRadius,
                  cornerSmoothing: 2,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
