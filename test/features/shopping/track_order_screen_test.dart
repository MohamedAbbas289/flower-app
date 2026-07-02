import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/shopping/presentation/screens/track_order_screen.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_state.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'track_order_screen_test.mocks.dart';

// Reads translations synchronously from disk so tests don't depend on
// rootBundle's asynchronous asset channel (which needs real I/O to resolve).
class _SyncFileAssetLoader extends AssetLoader {
  const _SyncFileAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final file = File('$path/${locale.languageCode}.json');
    return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

@GenerateMocks([TrackOrderViewModel])
void main() {
  late MockTrackOrderViewModel mockVm;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    mockVm = MockTrackOrderViewModel();
    await getIt.reset();
    getIt.registerSingleton<TrackOrderViewModel>(mockVm);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildApp() => EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const _SyncFileAssetLoader(),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const TrackOrderScreen(orderId: 'order1'),
          ),
        ),
      );

  void setupState(TrackOrderState state) {
    when(mockVm.state).thenReturn(state);
    when(mockVm.stream).thenAnswer((_) => Stream.value(state));
    when(mockVm.close()).thenAnswer((_) async {});
  }

  testWidgets('shows CircularProgressIndicator when isLoading=true',
      (tester) async {
    setupState(const TrackOrderState(isLoading: true));

    await tester.pumpWidget(buildApp());
    await tester.pump();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows driver name in driver card', (tester) async {
    setupState(const TrackOrderState(
      driverName: 'Ahmed Ali',
      driverPhone: '01012345678',
      stepsCompleted: 1,
    ));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Ahmed Ali'), findsOneWidget);
  });

  testWidgets('shows all 4 timeline step labels', (tester) async {
    setupState(const TrackOrderState(stepsCompleted: 0));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Received your order'), findsOneWidget);
    expect(find.text('Preparing your order'), findsOneWidget);
    expect(find.text('Out for delivery'), findsOneWidget);
    expect(find.text('Delivered'), findsOneWidget);
  });

  testWidgets(
      '"Order Delivered" button visible when stepsCompleted=4 and userConfirmed=false',
      (tester) async {
    setupState(const TrackOrderState(
      status: 'arrived_user',
      stepsCompleted: 4,
      userConfirmed: false,
    ));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Order Delivered'), findsOneWidget);
  });

  testWidgets('"Order Delivered" button NOT visible when stepsCompleted < 4',
      (tester) async {
    setupState(const TrackOrderState(stepsCompleted: 2));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Order Delivered'), findsNothing);
  });

  testWidgets('"Order Delivered" button NOT visible when userConfirmed=true',
      (tester) async {
    setupState(const TrackOrderState(
      status: 'delivered',
      stepsCompleted: 4,
      userConfirmed: true,
    ));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Order Delivered'), findsNothing);
    expect(find.text('Order confirmed ✓'), findsOneWidget);
  });

  testWidgets('tapping "Order Delivered" shows confirmation dialog',
      (tester) async {
    setupState(const TrackOrderState(
      status: 'arrived_user',
      stepsCompleted: 4,
      userConfirmed: false,
    ));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Order Delivered'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Order Delivered'));
    await tester.pumpAndSettle();

    expect(find.text('Confirm Delivery'), findsOneWidget);
    expect(find.text('Have you received your order?'), findsOneWidget);
  });
}
