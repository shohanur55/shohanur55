import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/data/models/project_model.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/presentation/widgets/project_detail_dialog.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    HttpOverrides.global = TestHttpOverrides();
  });

  final testProject = Project(
    id: '1',
    title: 'Test Project',
    description: 'This is a test project description.',
    technologies: ['Flutter', 'Dart'],
    imageUrl: 'http://example.com/test.png',
    images: ['http://example.com/test.png'],
    githubUrl: 'https://github.com/test',
    liveUrl: 'https://test.com',
  );

  testWidgets('ProjectCard renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: ProjectCard(project: testProject)),
        ),
      ),
    );

    // Verify Title and Description
    expect(find.text('Test Project'), findsOneWidget);
    expect(find.text('This is a test project description.'), findsOneWidget);
    expect(find.text('Flutter, Dart'), findsOneWidget);

    // Verify Read More button
    expect(find.text('Read More'), findsOneWidget);
  });

  testWidgets('Tapping Read More opens ProjectDetailDialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: ProjectCard(project: testProject)),
        ),
      ),
    );

    // Find Read More button
    final readMoreFinder = find.text('Read More');
    expect(readMoreFinder, findsOneWidget);

    // Ensure visible
    await tester.ensureVisible(readMoreFinder);
    await tester.pumpAndSettle();

    // Tap Read More
    await tester.tap(readMoreFinder);
    await tester.pumpAndSettle();

    // Verify Dialog opens
    expect(find.byType(ProjectDetailDialog), findsOneWidget);
    expect(find.text('Technologies Used:'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Dart'), findsOneWidget);
  });
}

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return FakeHttpClient();
  }
}

class FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return FakeHttpClientRequest();
  }
}

class FakeHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  HttpHeaders get headers => FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return FakeHttpClientResponse();
  }
}

class FakeHttpClientResponse extends Fake implements HttpClientResponse {
  final List<int> _imageBytes = [
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ];

  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _imageBytes.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream.value(_imageBytes).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class FakeHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}
