import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';
import '../widgets/neu_box.dart';
import 'question_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= kDesktopBreakpoint;

    return Scaffold(
      backgroundColor: kBg,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kContentMaxWidthDesktop),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40 : 24,
              vertical: isDesktop ? 56 : 40,
            ),
            child: isDesktop ? _DesktopHomeContent() : _MobileHomeContent(),
          ),
        ),
      ),
    );
  }
}

class _DesktopHomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: NeuBox(
            borderRadius: kRadiusL,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadiusL),
              child: Image.asset('assets/logo.png', fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(width: 36),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '문학 성향 아카이브',
                style: TextStyle(
                  fontSize: 14,
                  color: kSubText,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              NeuBox(
                borderRadius: kRadiusL,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '문BTI',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: kAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '나는 어떤 작가의 결을 닮았을까',
                      style: TextStyle(
                        fontSize: 22,
                        color: kSubText,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '문장 16개를 따라가며\n당신의 문학적 기질을 찾아보세요.',
                      style: TextStyle(
                        fontSize: 16,
                        color: kText,
                        height: 1.55,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              NeuBox(
                borderRadius: kRadiusM,
                inset: true,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: Text(
                  '“좋은 문장은 독자의 하루를 바꾼다.”\n지금, 당신의 문장이 닮은 작가를 만납니다.',
                  style: TextStyle(
                    fontSize: 16,
                    color: kSubText,
                    height: 1.6,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _NeuButton(
                width: 260,
                label: '문장 여정 시작',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuestionScreen()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileHomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: kContentMaxWidthMobile),
      child: Column(
        children: [
          NeuBox(
            borderRadius: kRadiusM,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadiusM),
              child: Image.asset('assets/logo.png', fit: BoxFit.fitWidth),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            '문학 성향 아카이브',
            style: TextStyle(
              fontSize: 14,
              color: kSubText,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          NeuBox(
            borderRadius: kRadiusL,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: Column(
              children: [
                Text(
                  '문BTI',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: kAccent,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '나는 어떤 작가의 결을 닮았을까',
                  style: TextStyle(
                    fontSize: 22,
                    color: kSubText,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '문장 16개를 따라가며\n당신의 문학적 기질을 찾아보세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: kText,
                    height: 1.55,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          NeuBox(
            borderRadius: kRadiusM,
            inset: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              '“좋은 문장은 독자의 하루를 바꾼다.”\n지금, 당신의 문장이 닮은 작가를 만납니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: kSubText,
                height: 1.6,
                letterSpacing: 0.1,
              ),
            ),
          ),
          const SizedBox(height: 40),
          _NeuButton(
            label: '문장 여정 시작',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuestionScreen()),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _NeuButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final double width;

  const _NeuButton({
    required this.label,
    required this.onTap,
    this.width = 220,
  });

  @override
  State<_NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<_NeuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: widget.onTap,
          onHighlightChanged: (value) => setState(() => _pressed = value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: widget.width,
            height: 56,
            decoration: BoxDecoration(
              color: kBg,
              borderRadius: BorderRadius.circular(kRadiusXL),
              boxShadow: _pressed
                  ? []
                  : neuRaisedShadow(),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _pressed ? kSubText : kAccent,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
