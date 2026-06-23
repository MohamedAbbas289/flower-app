import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/profile/domain/repository_contract/edit_profile_repo_contract.dart';
import 'package:flower_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'upload_photo_use_case_test.mocks.dart';

@GenerateMocks([EditProfileRepoContract])
void main() {
  late MockEditProfileRepoContract mockRepo;
  late UploadPhotoUseCase useCase;

  final tFile = File('test/assets/test_image.png');

  setUp(() {
    mockRepo = MockEditProfileRepoContract();
    useCase = UploadPhotoUseCase(mockRepo);
    provideDummy<BaseResponse<void>>(
      SuccessBaseResponse<void>(data: null),
    );
  });

  group('UploadPhotoUseCase', () {
    test('should return SuccessBaseResponse when repo succeeds', () async {
      when(mockRepo.uploadPhoto(tFile))
          .thenAnswer((_) async => SuccessBaseResponse<void>(data: null));

      final result = await useCase(tFile);

      expect(result, isA<SuccessBaseResponse<void>>());
      verify(mockRepo.uploadPhoto(tFile)).called(1);
    });

    test('should return ErrorBaseResponse when repo fails', () async {
      when(mockRepo.uploadPhoto(tFile))
          .thenAnswer((_) async => ErrorBaseResponse<void>(exception: Exception('error')));

      final result = await useCase(tFile);

      expect(result, isA<ErrorBaseResponse<void>>());
      verify(mockRepo.uploadPhoto(tFile)).called(1);
    });
  });
}