enum MbtiAxis { ei, sn, tf, jp }

enum Direction { e, i, s, n, t, f, j, p }

class Question {
  final String id;
  final MbtiAxis axis;
  final String text;
  final double weight;
  final Direction direction;

  const Question({
    required this.id,
    required this.axis,
    required this.text,
    required this.weight,
    required this.direction,
  });
}
