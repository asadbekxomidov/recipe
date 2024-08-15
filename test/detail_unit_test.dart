import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_app/ui/screens/recipe_detail_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

void main() {
  testWidgets('RecipeDetailsScreen renders correctly',
      (WidgetTester tester) async {
    final RecipeModel recipeModel = RecipeModel(
      id: '1',
      creatorId: 'creatorId',
      title: 'Test Recipe',
      ingredients: 'Test Ingredients',
      stagesOfPreparation: 'Test Stages',
      categoryId: 'Test Category',
      cookingTime: 30,
      likesCount: 10,
      comments: [],
      imageUrl: 'https://example.com/image.jpg',
      videoUrl: 'https://example.com/video.mp4',
      date: '2024-08-15',
    );

    // Mock VideoPlayerController
    final mockController = MockVideoPlayerController();

    when(mockController.value).thenReturn(VideoPlayerValue(
      duration: Duration.zero,
      isPlaying: false,
      isInitialized: true,
      size: const Size(640, 360),
    ));

    await tester.pumpWidget(MaterialApp(
      home: RecipeDetailsScreen(recipeModel: recipeModel),
    ));

    // Checking if the title is displayed
    expect(find.text('Test Recipe'), findsOneWidget);

    // Checking if the ingredients are displayed
    expect(find.text('Test Ingredients'), findsOneWidget);

    // Checking if the cooking time is displayed
    expect(find.text('30 min'), findsOneWidget);

    // Checking if the video player is displayed
    expect(find.byType(VideoPlayer), findsOneWidget);

    // Simulate play button press
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    // Verify the play function was called
    verify(mockController.play()).called(1);
  });
}
