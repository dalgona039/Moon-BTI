import 'package:flutter/material.dart';

class AuthorResult {
  final String mbti;
  final String author;
  final String tagline;
  final String description;
  final Color cardColor;
  final String work1;
  final String work2;
  final String imageFile;
  final String quote;

  const AuthorResult({
    required this.mbti,
    required this.author,
    required this.tagline,
    required this.description,
    required this.cardColor,
    required this.work1,
    required this.work2,
    required this.imageFile,
    required this.quote,
  });
}
