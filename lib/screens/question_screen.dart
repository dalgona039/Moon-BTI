import 'package:flutter/material.dart';
import '../data/mbti_data.dart';
import '../models/mbti_calculator.dart';
import '../theme/app_tokens.dart';
import '../widgets/neu_box.dart';
import '../widgets/neu_button.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentIndex = 0;
  final Map<String, int> _answers = {};
  bool _isSubmitting = false;

  static const List<String> _labels = ['전혀 아님', '아님', '보통', '그럼', '매우 그럼'];

  bool get _isLast => _currentIndex == questions.length - 1;
  int? get _selected => _answers[questions[_currentIndex].id];
  bool get _canProceed => _selected != null && !_isSubmitting;

  void _answer(int value) {
    final q = questions[_currentIndex];
    setState(() => _answers[q.id] = value);
  }

  Future<void> _goNext() async {
    if (!_isLast) {
      setState(() => _currentIndex++);
      return;
    }
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    final result = MbtiCalculator.calculate(_answers);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }

  void _goBack() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    } else {
      _confirmExit();
    }
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusM)),
        title: Text(
          '탐색 중단',
          style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '지금 나가면 ${_answers.length}개의 응답이 모두 사라집니다.\n정말 돌아가시겠습니까?',
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('계속하기', style: TextStyle(color: kAccent, fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('나가기', style: TextStyle(color: kSubText)),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = screenSizeOf(context);
    final q = questions[_currentIndex];
    final progress = (_currentIndex + 1) / questions.length;
    final tt = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size == ScreenSize.desktop
                    ? kContentMaxWidthDesktop
                    : size == ScreenSize.tablet
                        ? kContentMaxWidthTablet
                        : kContentMaxWidthMobile,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size == ScreenSize.desktop ? 36 : 24,
                  vertical: size == ScreenSize.desktop ? 24 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(
                      currentIndex: _currentIndex,
                      total: questions.length,
                      answeredCount: _answers.length,
                      onBack: _goBack,
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      label: '${_currentIndex + 1}번째 문항 중 ${questions.length}개, ${(progress * 100).round()}% 완료',
                      child: NeuBox(
                        borderRadius: 8,
                        inset: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(kAccent),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size == ScreenSize.desktop ? 28 : 16),
                    Text('문장 취향 탐색', style: tt.labelLarge),
                    SizedBox(height: size == ScreenSize.desktop ? 10 : 8),
                    if (size == ScreenSize.desktop)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 7,
                              child: _QuestionCard(text: q.text),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  _LikertPanel(
                                    selected: _selected,
                                    labels: _labels,
                                    onSelect: _answer,
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: double.infinity,
                                    child: NeuButton(
                                      label: _isLast
                                          ? (_isSubmitting ? '문학 프로필 계산 중...' : '문학 프로필 보기')
                                          : '다음 장으로',
                                      enabled: _canProceed,
                                      isLoading: _isSubmitting,
                                      disabledHint: _selected == null ? '응답을 선택해 주세요' : null,
                                      onTap: _goNext,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Expanded(
                        child: Column(
                          children: [
                            Flexible(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (child, animation) => FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.05, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                                child: _QuestionCard(
                                  key: ValueKey(_currentIndex),
                                  text: q.text,
                                  isMobile: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _LikertPanel(
                              selected: _selected,
                              labels: _labels,
                              onSelect: _answer,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: NeuButton(
                                label: _isLast
                                    ? (_isSubmitting ? '문학 프로필 계산 중...' : '문학 프로필 보기')
                                    : '다음 장으로',
                                enabled: _canProceed,
                                isLoading: _isSubmitting,
                                disabledHint: _selected == null ? '응답을 선택해 주세요' : null,
                                onTap: _goNext,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// 추출된 하위 위젯
// ═══════════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  final int currentIndex;
  final int total;
  final int answeredCount;
  final VoidCallback onBack;

  const _TopBar({
    required this.currentIndex,
    required this.total,
    required this.answeredCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        NeuIconButton(
          icon: Icons.arrow_back_ios_rounded,
          semanticLabel: currentIndex > 0 ? '이전 문항' : '홈으로 돌아가기',
          onTap: onBack,
        ),
        const Spacer(),
        NeuBox(
          borderRadius: kRadiusM,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${currentIndex + 1}장  /  $total장',
                style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kAccent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$answeredCount 응답',
                  style: tt.bodySmall?.copyWith(
                    color: kAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: kFontSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String text;
  final bool isMobile;

  const _QuestionCard({
    super.key,
    required this.text,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return NeuBox(
      borderRadius: isMobile ? kRadiusM : kRadiusL,
      padding: EdgeInsets.all(isMobile ? 28 : 34),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: isMobile ? tt.bodyLarge : tt.bodyLarge?.copyWith(fontSize: 24),
        ),
      ),
    );
  }
}

class _LikertPanel extends StatelessWidget {
  final int? selected;
  final List<String> labels;
  final ValueChanged<int> onSelect;

  const _LikertPanel({
    required this.selected,
    required this.labels,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return NeuBox(
      borderRadius: kRadiusL,
      inset: true,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '이 문장이 나를 얼마나 설명하나요?',
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (i) {
              final value = i + 1;
              return _LikertButton(
                value: value,
                label: labels[i],
                isSelected: selected == value,
                onTap: () => onSelect(value),
              );
            }),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('전혀 그렇지 않다', style: tt.bodySmall?.copyWith(fontSize: kFontSmall)),
                Text('매우 그렇다', style: tt.bodySmall?.copyWith(fontSize: kFontSmall)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            selected == null
                ? '가장 가까운 반응을 하나 선택해 주세요.'
                : '$selected점으로 기록되었습니다.',
            style: TextStyle(
              fontSize: kFontCaption,
              color: selected == null ? kSubText : kAccent,
              fontWeight: selected == null ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LikertButton extends StatefulWidget {
  final int value;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LikertButton({
    required this.value,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_LikertButton> createState() => _LikertButtonState();
}

class _LikertButtonState extends State<_LikertButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.isSelected;

    return Semantics(
      button: true,
      selected: selected,
      label: '${widget.label}, ${widget.value}점',
      child: Focus(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: kMinInteractiveSize,
                  height: kMinInteractiveSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? kAccent : kBg,
                    border: !selected && !_pressed
                        ? Border.all(color: kShadowDark.withValues(alpha: 0.4), width: 1.5)
                        : null,
                    boxShadow: selected || _pressed
                        ? []
                        : neuRaisedShadow(offset: const Offset(3, 3), blur: 6),
                  ),
                  child: Center(
                    child: selected
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : Text(
                            '${widget.value}',
                            style: TextStyle(
                              fontSize: kFontCaption,
                              color: kSubText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: kFontSmall,
                    color: selected ? kAccent : kSubText,
                    height: 1.3,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
