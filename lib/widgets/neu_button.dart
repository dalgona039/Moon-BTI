import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

/// 공통 뉴모피즘 버튼
///
/// - [enabled] 가 false 면 시각적으로 비활성화.
/// - [isLoading] 이 true 면 spinner 표시.
/// - [onTap] 은 `Future<void> Function()?` 으로 async 도 수용.
class NeuButton extends StatefulWidget {
  final String label;
  final Future<void> Function()? onTap;
  final double? width;
  final double height;
  final bool enabled;
  final bool isLoading;
  final IconData? icon;
  final String? disabledHint; // 비활성 이유 안내

  const NeuButton({
    super.key,
    required this.label,
    required this.onTap,
    this.width,
    this.height = kPrimaryButtonHeight,
    this.enabled = true,
    this.isLoading = false,
    this.icon,
    this.disabledHint,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _pressed = false;

  bool get _active => widget.enabled && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _active,
      label: widget.label,
      hint: !_active ? widget.disabledHint : null,
      child: Tooltip(
        message: !_active && widget.disabledHint != null
            ? widget.disabledHint!
            : '',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kRadiusXL),
            onTap: _active
                ? () async {
                    await widget.onTap?.call();
                  }
                : null,
            onHighlightChanged:
                _active ? (v) => setState(() => _pressed = v) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: widget.width,
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                color: _active ? kBg : kShadowDark.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(kRadiusXL),
                border: _active
                    ? null
                    : Border.all(
                        color: kShadowDark.withValues(alpha: 0.35)),
                boxShadow: _active && !_pressed ? neuRaisedShadow() : [],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: kAccent,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18, color: _labelColor),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: kFontBody,
                        fontWeight: FontWeight.w700,
                        color: _labelColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color get _labelColor {
    if (!_active) return kText.withValues(alpha: 0.45);
    return _pressed ? kSubText : kAccent;
  }
}

/// 뉴모피즘 원형 아이콘 버튼 (뒤로가기 등)
class NeuIconButton extends StatefulWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;

  const NeuIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
  });

  @override
  State<NeuIconButton> createState() => _NeuIconButtonState();
}

class _NeuIconButtonState extends State<NeuIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: kMinInteractiveSize,
            height: kMinInteractiveSize,
            decoration: BoxDecoration(
              color: kBg,
              shape: BoxShape.circle,
              boxShadow: _pressed
                  ? []
                  : neuRaisedShadow(offset: const Offset(4, 4), blur: 8),
            ),
            child: Icon(widget.icon, color: kSubText, size: 18),
          ),
        ),
      ),
    );
  }
}
