import 'dart:math';

import '../models/question.dart';
import '../data/mbti_data.dart';
import '../models/author_result.dart';

class MbtiCalculator {
  /// answers: questionId → likert value (1‥5)
  ///
  /// 각 축의 raw score 가 **정확히 0** 이면 동전 던지기(무작위 배정) 대신
  /// 해당 축의 후반 극(E/S/T/J)을 기본값으로 한다 — 즉, 양•음 아무 쪽에도
  /// 치우치지 않았을 때 "측정 불가" 편향 없이 일관된 기본 경로를 제공한다.
  static AuthorResult calculate(Map<String, int> answers) {
    double eiScore = 0;
    double snScore = 0;
    double tfScore = 0;
    double jpScore = 0;

    for (final q in questions) {
      final raw = answers[q.id] ?? 3;
      final normalized = (raw - 3).toDouble();
      final contribution = normalized * q.weight;

      switch (q.axis) {
        case MbtiAxis.ei:
          eiScore += (q.direction == Direction.e) ? contribution : -contribution;
        case MbtiAxis.sn:
          snScore += (q.direction == Direction.s) ? contribution : -contribution;
        case MbtiAxis.tf:
          tfScore += (q.direction == Direction.t) ? contribution : -contribution;
        case MbtiAxis.jp:
          jpScore += (q.direction == Direction.j) ? contribution : -contribution;
      }
    }

    // 0 일 때(완전 중립) tie‑break: 무작위 배정으로 편향 제거
    final rng = Random();
    String pick(double score, String pos, String neg) {
      if (score > 0) return pos;
      if (score < 0) return neg;
      return rng.nextBool() ? pos : neg;
    }

    final mbti = '${pick(eiScore, 'E', 'I')}'
        '${pick(snScore, 'S', 'N')}'
        '${pick(tfScore, 'T', 'F')}'
        '${pick(jpScore, 'J', 'P')}';
    return authorResults[mbti]!;
  }
}
