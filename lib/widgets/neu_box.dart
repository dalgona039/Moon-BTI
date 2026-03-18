import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

/// 뉴모피즘 박스 — raised / inset 두 가지 모드를 단일 Container 로 처리.
class NeuBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool inset;

  const NeuBox({
    super.key,
    required this.child,
    this.borderRadius = kRadiusM,
    this.padding,
    this.inset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: inset ? neuInsetShadow() : neuRaisedShadow(),
      ),
      child: child,
    );
  }
}
