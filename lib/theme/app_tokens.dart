import 'package:flutter/material.dart';

// ── 색상 ────────────────────────────────────────────────────────────────
const kBg = Color(0xFFE4E9F0);
const kShadowDark = Color(0xFFA3B1C6);
const kShadowLight = Color(0xFFFFFFFF);

const kAccent = Color(0xFF6B8CBA);
const kAccentDark = Color(0xFF4A6F9C); // hover / active
const kText = Color(0xFF2E4057); // 본문 — 대비 ≥ 7:1
const kSubText = Color(0xFF516A80); // 보조 — 대비 ≥ 4.5:1
const kDim = Color(0xFF8A9FB4); // 힌트 (대형 텍스트 전용)

// ── 라운딩 ──────────────────────────────────────────────────────────────
const kRadiusS = 12.0;
const kRadiusM = 20.0;
const kRadiusL = 24.0;
const kRadiusXL = 28.0;

// ── 스페이싱 ────────────────────────────────────────────────────────────
const kSpacingS = 8.0;
const kSpacingM = 16.0;
const kSpacingL = 24.0;
const kSpacingXL = 32.0;

// ── 반응형 브레이크포인트 ────────────────────────────────────────────────
const kMobileBreakpoint = 600.0;
const kTabletBreakpoint = 840.0;
const kDesktopBreakpoint = 1080.0;

const kContentMaxWidthMobile = 560.0;
const kContentMaxWidthTablet = 760.0;
const kContentMaxWidthDesktop = 1040.0;

enum ScreenSize { mobile, tablet, desktop }

ScreenSize screenSizeOf(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w >= kDesktopBreakpoint) return ScreenSize.desktop;
  if (w >= kTabletBreakpoint) return ScreenSize.tablet;
  return ScreenSize.mobile;
}

// ── 인터랙션 ────────────────────────────────────────────────────────────
const kMinInteractiveSize = 48.0; // WCAG 최소 터치 타겟
const kPrimaryButtonHeight = 56.0;

// ── 타이포그래피 스케일 (7 단계) ─────────────────────────────────────────
const kFontDisplay = 40.0;
const kFontHeadline = 28.0;
const kFontTitle = 22.0;
const kFontBodyL = 18.0;
const kFontBody = 16.0;
const kFontCaption = 14.0;
const kFontSmall = 12.0;

// ── 뉴모피즘 그림자 ─────────────────────────────────────────────────────
List<BoxShadow> neuRaisedShadow({
  Offset offset = const Offset(6, 6),
  double blur = 12,
}) {
  return [
    BoxShadow(color: kShadowDark, offset: offset, blurRadius: blur),
    BoxShadow(
      color: kShadowLight,
      offset: Offset(-offset.dx, -offset.dy),
      blurRadius: blur,
    ),
  ];
}

List<BoxShadow> neuInsetShadow() {
  return [
    BoxShadow(
      color: kShadowDark.withValues(alpha: 0.55),
      offset: const Offset(3, 3),
      blurRadius: 6,
    ),
    const BoxShadow(
      color: kShadowLight,
      offset: Offset(-3, -3),
      blurRadius: 6,
    ),
  ];
}
