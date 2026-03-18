# 문BTI (MoonBTI)

[![Flutter](https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-Language-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

문BTI는 사용자의 문학적 취향을 MBTI 프레임으로 해석해, 결과를 대표 작가/작품/문장으로 연결해 주는 Flutter 앱입니다.

기존의 단순 심리 테스트 UI가 아니라, 다음 두 가지를 동시에 만족하는 것을 목표로 설계되었습니다.

- 감성적 브랜드 경험: 뉴모피즘 기반의 시각 아이덴티티 유지
- 실제 사용성: 읽기 쉬운 타이포, 명확한 버튼 흐름, 접근성 강화

## 목차

- [1) 제품 개요](#1-제품-개요)
- [2) 현재 구현 범위](#2-현재-구현-범위)
- [3) 점수 계산 방식](#3-점수-계산-방식)
- [4) UX 및 접근성 리디자인](#4-ux-및-접근성-리디자인)
- [5) 디자인 시스템](#5-디자인-시스템)
- [6) 기술 스택](#6-기술-스택)
- [7) 프로젝트 구조](#7-프로젝트-구조)
- [8) 로컬 실행 가이드](#8-로컬-실행-가이드)
- [9) 에셋 및 아이콘](#9-에셋-및-아이콘)
- [10) 데이터 수정 가이드](#10-데이터-수정-가이드)
- [11) QA 체크 포인트](#11-qa-체크-포인트)
- [12) 알려진 이슈 및 개선 메모](#12-알려진-이슈-및-개선-메모)
- [13) 문서](#13-문서)
- [14) 라이선스](#14-라이선스)

---

## 1) 제품 개요

### 핵심 컨셉

- 질문에 답하며 자신의 문장 취향을 탐색한다.
- 4개 축(E/I, S/N, T/F, J/P)에서 성향을 계산한다.
- 조합된 16가지 결과를 문학 작가 페르소나로 보여준다.

### 사용자 여정

1. 홈 화면에서 테스트 시작
2. 24개 문항에 1~5점(리커트)으로 응답
3. 문항별 응답을 확인하며 다음으로 이동
4. 마지막 문항에서 결과 계산
5. 결과 화면에서 작가 유형, 키워드, 추천 작품, 해석 노트 확인

---

## 2) 현재 구현 범위

### 진단 로직

- 문항 수: 총 24개
	- E/I 축 6개
	- S/N 축 6개
	- T/F 축 6개
	- J/P 축 6개
- 응답 스케일: 1~5점
- 중립점: 3점
- 결과 수: 16개 MBTI 조합

### 화면 구성

- HomeScreen
	- 브랜드 인트로
	- 시작 CTA
- QuestionScreen
	- 진행률 바
	- 현재 문항 카드
	- 5점 선택 버튼
	- 이전/다음 흐름
- ResultScreen
	- MBTI 뱃지
	- 작가 프로필 카드
	- 요약 문장 3줄
	- 키워드 배지
	- 해석 노트 토글
	- 명구절 카드
	- 다시 탐색하기

### 데이터 구성

- 질문 데이터: lib/data/mbti_data.dart
- 결과 데이터(16유형): lib/data/mbti_data.dart
- 질문 모델: lib/models/question.dart
- 결과 모델: lib/models/author_result.dart
- 계산기: lib/models/mbti_calculator.dart

---

## 3) 점수 계산 방식

문항마다 축(axis)과 방향(direction)이 지정되어 있습니다.

- axis: ei, sn, tf, jp 중 하나
- direction: e/i/s/n/t/f/j/p 중 하나
- weight: 문항 가중치(현재는 모든 문항 1.0)

계산 절차:

1. 사용자의 응답값(raw)에서 중립점 3을 빼서 정규화
	 - normalized = raw - 3
2. normalized에 문항 가중치(weight)를 곱해 기여값(contribution) 생성
3. 각 축에서 direction에 따라 더하거나 빼서 축 점수 누적
4. 축 점수의 부호로 문자 선택
	 - 예: E/I 축에서 score > 0 이면 E, score < 0 이면 I
5. 4축 문자를 합쳐 최종 MBTI 생성
6. 생성된 MBTI 키로 결과 데이터 조회

참고: 동점(score == 0)일 때는 현재 무작위 tie-break를 사용합니다.

---

## 4) UX 및 접근성 리디자인

리디자인 실행 기준은 UI_REDESIGN_CHECKLIST.md에서 관리합니다.

### 반영된 핵심 변경

- 자동 다음 이동 제거
	- 선택 즉시 화면 전환이 아닌, 사용자가 다음 버튼으로 명시 이동
- 이전 이동 시 응답 유지
	- 사용자가 실수 응답을 수정하기 쉬운 흐름
- 타이포 스케일 정리
	- 본문 가독성 중심의 크기/행간 체계 적용
- 상호작용 컨트롤 개선
	- Semantics + Material + InkWell 기반으로 통일
	- 최소 터치 영역 확보
	- 선택/프레스 피드백 제공
- 정보 위계 재정렬
	- 홈/문항/결과 각각 시선 흐름이 끊기지 않도록 카드 밀도와 강조 요소 정리

### 접근성 포인트

- 버튼/선택 요소에 Semantics 라벨 제공
- 선택 상태(selected) 전달
- 비활성 상태 안내(disabledHint) 제공
- 스크린리더 사용자 기준의 액션 의미 전달 강화

---

## 5) 디자인 시스템

앱 전체 스타일은 디자인 토큰으로 관리됩니다.

- 파일: lib/theme/app_tokens.dart
- 관리 대상
	- 색상(kBg, kAccent, kText 등)
	- 라운드(kRadiusS~XL)
	- 간격(kSpacingS~XL)
	- 타이포 스케일(kFontDisplay~kFontSmall)
	- 반응형 브레이크포인트
	- 뉴모피즘 그림자 규칙

공통 컴포넌트:

- NeuBox: raised/inset 컨테이너
- NeuButton: 상태(enabled/loading) 대응 버튼
- NeuIconButton: 원형 아이콘 액션 버튼

---

## 6) 기술 스택

- Flutter
- Dart
- Material 3
- flutter_lints
- flutter_launcher_icons

---

## 7) 프로젝트 구조

```text
lib/
	main.dart
	data/
		mbti_data.dart
	models/
		author_result.dart
		mbti_calculator.dart
		question.dart
	screens/
		home_screen.dart
		question_screen.dart
		result_screen.dart
	theme/
		app_tokens.dart
	widgets/
		neu_box.dart
		neu_button.dart
```

---

## 8) 로컬 실행 가이드

### 요구 사항

- Flutter SDK 설치
- Dart SDK(Flutter에 포함)
- macOS/Android/Windows 중 하나 이상의 타깃 환경

### 의존성 설치

```bash
flutter pub get
```

### 앱 실행

```bash
flutter run
```

### 정적 분석

```bash
flutter analyze
```

### 테스트

```bash
flutter test
```

---

## 9) 에셋 및 아이콘

### 에셋

- 로고: assets/logo.png
- 작가 이미지: assets/authors/

### 런처 아이콘 생성

pubspec.yaml의 flutter_launcher_icons 설정을 기준으로 생성합니다.

```bash
flutter pub run flutter_launcher_icons
```

---

## 10) 데이터 수정 가이드

### 문항 추가/수정

파일: lib/data/mbti_data.dart

확인할 항목:

- id 중복 여부
- axis/direction 일치 여부
- 문항 수 균형(축별 균형 유지 권장)
- 문구 길이(모바일 가독성)

### 결과 유형 수정

파일: lib/data/mbti_data.dart

각 MBTI 키(INTJ 등)에 대해 다음 필드가 채워져야 합니다.

- author
- tagline
- description
- cardColor
- work1, work2
- imageFile
- quote

---

## 11) QA 체크 포인트

릴리즈 전 최소 확인 권장 항목:

- 반응형 레이아웃
	- 모바일/태블릿/데스크톱에서 줄바꿈, 버튼 폭, 카드 오버플로우 점검
- 문항 플로우
	- 선택 전 다음 버튼 비활성화 동작
	- 이전 이동 후 응답 유지
	- 마지막 문항에서 결과 보기 전환
- 접근성
	- 스크린리더 라벨/선택 상태 전달 확인
	- 키보드 탐색(Tab/Enter) 동작 확인
- 결과 화면
	- 이미지 누락 시 fallback UI 확인
	- 상세 토글 열기/닫기 동작 확인

---

## 12) 알려진 이슈 및 개선 메모

- 홈 카피 문구에 남아 있을 수 있는 문항 수 표기(예: 16개)는 실제 데이터(24개)와 일치하도록 유지해야 합니다.
- 테스트 파일의 스모크 테스트 텍스트는 UI 문구 변경 시 함께 갱신해야 합니다.

---

## 13) 문서

- 리디자인 체크리스트: UI_REDESIGN_CHECKLIST.md
- Flutter 공식 문서: https://docs.flutter.dev/

---

## 14) 라이선스

이 프로젝트는 MIT License를 따릅니다.

- 전체 라이선스 본문: [LICENSE](LICENSE)
