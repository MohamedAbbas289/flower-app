import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/core/values/firestore_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firestore_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late FirestoreService service;

  const userId = 'user_1';
  const orderId = 'order_1';

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocument = MockDocumentReference<Map<String, dynamic>>();
    service = FirestoreService(mockFirestore);
  });

  group('saveUserFcmData', () {
    test('writes fcmToken and language to correct doc path with merge', () async {
      when(mockFirestore.collection(FirestoreKeys.usersCollection))
          .thenReturn(mockCollection);
      when(mockCollection.doc(userId)).thenReturn(mockDocument);
      when(mockDocument.set(any, any)).thenAnswer((_) async {});

      await service.saveUserFcmData(
        userId: userId,
        fcmToken: 'token_1',
        language: 'en',
      );

      verify(mockFirestore.collection(FirestoreKeys.usersCollection))
          .called(1);
      verify(mockCollection.doc(userId)).called(1);
      final captured = verify(mockDocument.set(captureAny, captureAny))
          .captured;
      expect(captured[0], {
        FirestoreKeys.fcmToken: 'token_1',
        FirestoreKeys.language: 'en',
      });
      expect((captured[1] as SetOptions).merge, true);
    });
  });

  group('updateUserLanguage', () {
    test('writes only the language field to correct doc path with merge', () async {
      when(mockFirestore.collection(FirestoreKeys.usersCollection))
          .thenReturn(mockCollection);
      when(mockCollection.doc(userId)).thenReturn(mockDocument);
      when(mockDocument.set(any, any)).thenAnswer((_) async {});

      await service.updateUserLanguage(userId: userId, language: 'ar');

      verify(mockFirestore.collection(FirestoreKeys.usersCollection))
          .called(1);
      verify(mockCollection.doc(userId)).called(1);
      final captured = verify(mockDocument.set(captureAny, captureAny))
          .captured;
      expect(captured[0], {FirestoreKeys.language: 'ar'});
      expect((captured[1] as SetOptions).merge, true);
    });
  });

  group('orderStream', () {
    test('returns the snapshots stream from the correct order doc', () {
      final controller = StreamController<DocumentSnapshot<Map<String, dynamic>>>();
      when(mockFirestore.collection(FirestoreKeys.ordersCollection))
          .thenReturn(mockCollection);
      when(mockCollection.doc(orderId)).thenReturn(mockDocument);
      when(mockDocument.snapshots()).thenAnswer((_) => controller.stream);

      final result = service.orderStream(orderId);

      expect(result, controller.stream);
      verify(mockFirestore.collection(FirestoreKeys.ordersCollection))
          .called(1);
      verify(mockCollection.doc(orderId)).called(1);
      controller.close();
    });
  });

  group('confirmDelivery', () {
    test('updates userConfirmed to true on correct order doc', () async {
      when(mockFirestore.collection(FirestoreKeys.ordersCollection))
          .thenReturn(mockCollection);
      when(mockCollection.doc(orderId)).thenReturn(mockDocument);
      when(mockDocument.update(any)).thenAnswer((_) async {});

      await service.confirmDelivery(orderId);

      verify(mockFirestore.collection(FirestoreKeys.ordersCollection))
          .called(1);
      verify(mockCollection.doc(orderId)).called(1);
      final captured = verify(mockDocument.update(captureAny)).captured;
      expect(captured[0], {FirestoreKeys.userConfirmed: true});
    });
  });
}
