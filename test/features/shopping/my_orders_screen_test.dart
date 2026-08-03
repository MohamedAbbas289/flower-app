import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/presentation/screens/orders_screen.dart';
import 'package:flower_app/features/shopping/presentation/view_models/orders_view_model/orders_state.dart';
import 'package:flower_app/features/shopping/presentation/view_models/orders_view_model/orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_orders_screen_test.mocks.dart';

class _SyncFileAssetLoader extends AssetLoader {
  const _SyncFileAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final file = File('$path/${locale.languageCode}.json');
    return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

const _tActiveOrder = OrderEntity(
  id: 'order1',
  orderNumber: '111',
  totalPrice: 300,
  isDelivered: false,
);

const _tCompletedOrder = OrderEntity(
  id: 'order2',
  orderNumber: '222',
  totalPrice: 600,
  isDelivered: true,
);

@GenerateMocks([OrdersViewModel])
void main() {
  late MockOrdersViewModel mockVm;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    mockVm = MockOrdersViewModel();
    await getIt.reset();
    getIt.registerSingleton<OrdersViewModel>(mockVm);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Widget buildApp({RouteFactory? onGenerateRoute}) => EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const _SyncFileAssetLoader(),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const OrdersScreen(),
            onGenerateRoute: onGenerateRoute,
          ),
        ),
      );

  void setupWithOrders({
    List<OrderEntity> active = const [],
    List<OrderEntity> completed = const [],
  }) {
    final loadedState = OrdersState(
      ordersState: BaseState.success([...active, ...completed]),
    );
    when(mockVm.state).thenReturn(loadedState);
    when(mockVm.stream).thenAnswer((_) => Stream.value(loadedState));
    when(mockVm.close()).thenAnswer((_) async {});
    when(mockVm.activeOrders).thenReturn(active);
    when(mockVm.completedOrders).thenReturn(completed);
  }

  testWidgets('"Track order" button shown on active order card', (tester) async {
    setupWithOrders(active: [_tActiveOrder]);

    await tester.pumpWidget(buildApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Track order'), findsOneWidget);
  });

  testWidgets('"Track order" NOT shown on completed order cards', (tester) async {
    setupWithOrders(completed: [_tCompletedOrder]);

    await tester.pumpWidget(buildApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Completed'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Track order'), findsNothing);
    expect(find.byType(SvgPicture), findsWidgets);
  });

  testWidgets('shows empty state when no active orders', (tester) async {
    setupWithOrders();

    await tester.pumpWidget(buildApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('No active orders'), findsOneWidget);
  });

  testWidgets('tapping "Track order" navigates to track order screen',
      (tester) async {
    setupWithOrders(active: [_tActiveOrder]);

    final navigatedRoutes = <String?>[];
    await tester.pumpWidget(
      buildApp(
        onGenerateRoute: (settings) {
          navigatedRoutes.add(settings.name);
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Track screen')),
          );
        },
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Track order'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(navigatedRoutes, contains('/trackOrderView'));
  });
}
