import 'package:flutter/material.dart';
import '../models/author_result.dart';
import '../theme/app_tokens.dart';
import '../widgets/neu_box.dart';
import 'home_screen.dart' show HomeScreen;

class ResultScreen extends StatefulWidget {
  final AuthorResult result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showDetail = false;

  List<String> get _summaryLines {
    return [
      '${widget.result.author}의 문장 결과 가장 가까운 흐름입니다.',
      widget.result.tagline,
      '첫 페이지 추천: ${widget.result.work1} · ${widget.result.work2}',
    ];
  }

  List<String> get _keywords {
    final labels = <String>[];
    for (final letter in widget.result.mbti.split('')) {
      switch (letter) {
        case 'E':
          labels.add('대화형 화자');
          break;
        case 'I':
          labels.add('독백형 화자');
          break;
        case 'S':
          labels.add('장면 중심 묘사');
          break;
        case 'N':
          labels.add('상징 중심 상상');
          break;
        case 'T':
          labels.add('구조적 전개');
          break;
        case 'F':
          labels.add('정서적 공명');
          break;
        case 'J':
          labels.add('치밀한 구성');
          break;
        case 'P':
          labels.add('즉흥적 전개');
          break;
      }
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= kDesktopBreakpoint;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kContentMaxWidthDesktop),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 36 : 24,
                vertical: isDesktop ? 34 : 40,
              ),
              child: Column(
                children: [
                  Text(
                    '당신의 문장 결',
                    style: TextStyle(fontSize: 14, color: kSubText, letterSpacing: 0.4),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.result.cardColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.result.mbti,
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.result.cardColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _AuthorCard(result: widget.result),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              _SummaryCard(
                                lines: _summaryLines,
                                keywords: _keywords,
                              ),
                              const SizedBox(height: 16),
                              _DetailToggleButton(
                                expanded: _showDetail,
                                onTap: () => setState(() => _showDetail = !_showDetail),
                              ),
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 180),
                                crossFadeState: _showDetail
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                firstChild: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: _DetailCard(description: widget.result.description),
                                ),
                                secondChild: const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _AuthorCard(result: widget.result),
                    const SizedBox(height: 24),
                    _SummaryCard(
                      lines: _summaryLines,
                      keywords: _keywords,
                    ),
                    const SizedBox(height: 16),
                    _DetailToggleButton(
                      expanded: _showDetail,
                      onTap: () => setState(() => _showDetail = !_showDetail),
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 180),
                      crossFadeState: _showDetail
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _DetailCard(description: widget.result.description),
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  NeuBox(
                    borderRadius: kRadiusM,
                    inset: true,
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.format_quote_rounded, color: kAccent, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '닮은 문장의 결',
                              style: TextStyle(
                                fontSize: 14,
                                color: kAccent,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.result.quote,
                          style: TextStyle(
                            fontSize: 16,
                            color: kText,
                            height: 1.7,
                            letterSpacing: 0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '— ${widget.result.author}',
                            style: TextStyle(
                              fontSize: 14,
                              color: kSubText,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  _RetryButton(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    '경희문학회에 많은 관심 바랍니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: kFontCaption,
                      color: kSubText,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<String> lines;
  final List<String> keywords;

  const _SummaryCard({required this.lines, required this.keywords});

  @override
  Widget build(BuildContext context) {
    return NeuBox(
      borderRadius: kRadiusM,
      inset: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문학 프로필',
            style: TextStyle(
              fontSize: 14,
              color: kAccent,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '• $line',
                style: const TextStyle(fontSize: 15, color: kText, height: 1.55),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords.map((keyword) => _KeywordBadge(text: keyword)).toList(),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String description;
  const _DetailCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return NeuBox(
      borderRadius: kRadiusM,
      inset: true,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories_rounded, color: kAccent, size: 16),
              const SizedBox(width: 8),
              Text(
                '해석 노트',
                style: TextStyle(
                  fontSize: 14,
                  color: kAccent,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: kText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordBadge extends StatelessWidget {
  final String text;
  const _KeywordBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: kAccent,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _DetailToggleButton extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const _DetailToggleButton({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: expanded ? '해석 노트 접기' : '해석 노트 보기',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  expanded ? '해석 노트 접기' : '해석 노트 보기',
                  style: const TextStyle(
                    fontSize: 14,
                    color: kAccent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 18,
                  color: kAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthorCard extends StatelessWidget {
  final AuthorResult result;
  const _AuthorCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return NeuBox(
      borderRadius: kRadiusXL,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: result.cardColor.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/authors/${result.imageFile}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: kBg,
                    border: Border.all(color: kAccent.withValues(alpha: 0.28), width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_stories_rounded, color: kAccent, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          result.author.substring(0, 1),
                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: kText),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            result.author,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: kText,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: result.cardColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              result.tagline,
              style: TextStyle(
                fontSize: 14,
                color: result.cardColor,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: kShadowDark.withValues(alpha: 0.3), thickness: 1),
          const SizedBox(height: 16),
          Text(
            '함께 읽으면 좋은 작품',
            style: TextStyle(
              fontSize: 14,
              color: kSubText,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _WorkBadge(title: result.work1, color: result.cardColor),
              _WorkBadge(title: result.work2, color: result.cardColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkBadge extends StatelessWidget {
  final String title;
  final Color color;
  const _WorkBadge({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _RetryButton extends StatefulWidget {
  final VoidCallback onTap;
  const _RetryButton({required this.onTap});

  @override
  State<_RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<_RetryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '다시 탐색하기',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: widget.onTap,
          onHighlightChanged: (value) => setState(() => _pressed = value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 220,
            height: kPrimaryButtonHeight,
            decoration: BoxDecoration(
              color: kBg,
              borderRadius: BorderRadius.circular(28),
              boxShadow: _pressed ? [] : neuRaisedShadow(),
            ),
            child: Center(
              child: Text(
                '다시 탐색하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _pressed ? kSubText : kAccent,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
