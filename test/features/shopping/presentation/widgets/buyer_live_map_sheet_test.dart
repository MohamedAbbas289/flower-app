import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:flower_app/features/shopping/presentation/view_models/buyer_map_cubit/buyer_map_cubit.dart';
import 'package:flower_app/features/shopping/presentation/view_models/buyer_map_cubit/buyer_map_state.dart';
import 'package:flower_app/features/shopping/presentation/widgets/buyer_live_map_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'buyer_live_map_sheet_test.mocks.dart';

@GenerateMocks([BuyerMapCubit])
void main() {
  late MockBuyerMapCubit mockCubit;

  void stubState(BuyerMapState state) {
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream)
        .thenAnswer((_) => const Stream<BuyerMapState>.empty());
    when(mockCubit.isClosed).thenReturn(false);
    when(mockCubit.close()).thenAnswer((_) async {});
  }

  setUp(() {
    mockCubit = MockBuyerMapCubit();
    getIt.registerFactory<BuyerMapCubit>(() => mockCubit);
  });

  tearDown(() {
    getIt.reset();
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BuyerLiveMapSheet(orderId: 'order_1'),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows a progress indicator while loading', (tester) async {
    stubState(const BuyerMapState());

    await pumpSheet(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a FlutterMap when ready with a driver location',
      (tester) async {
    stubState(
      const BuyerMapState(
        phase: BuyerMapPhase.ready,
        driverLocation: LatLngPoint(lat: 30.0, lng: 31.0),
        destination: LatLngPoint(lat: 30.1, lng: 31.1),
      ),
    );

    await pumpSheet(tester);

    expect(find.byType(FlutterMap), findsOneWidget);
  });

  testWidgets('always renders the grey handle bar', (tester) async {
    stubState(const BuyerMapState());

    await pumpSheet(tester);

    final handle = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == Colors.grey,
    );

    expect(handle, findsOneWidget);
  });
}
