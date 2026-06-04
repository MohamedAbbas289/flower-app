
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/add_address/domain/use_cases/add_address_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_addres_view_model_test.mocks.dart';

@GenerateMocks([AddAddressUseCases])
void main (){
late MockAddAddressUseCases addAddressUseCases;

final request =  AddAddressDto(
    id: '1',
    street: 'shalpy',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',

);
  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>(data: [AddressEntity()]),
    );
    provideDummy<BaseResponse<List<AddressEntity>>>(
      ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
    );

  });
  setUp(() {
    addAddressUseCases = MockAddAddressUseCases();
  });
  group('AddAddressUseCases', () {
    test('returns success response when repository succeeds', () async {
      final response = SuccessBaseResponse<List<AddressEntity>>(
          data: [AddressEntity()]);
      when(
        addAddressUseCases(request),
      ).thenAnswer((_) async => response);
      final result = await addAddressUseCases(request);
      expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
      expect((result as SuccessBaseResponse<List<AddressEntity>>).data,
          [AddressEntity()]);
      verify(addAddressUseCases(request)).called(1);
      verifyNoMoreInteractions(addAddressUseCases);
    });
    test('returns error response when repository fails', () async {
      final exception = Exception();
      final response = ErrorBaseResponse<List<AddressEntity>>(
          exception: exception);
      when(
        addAddressUseCases(request),
      ).thenAnswer((_) async => response);
      final result = await addAddressUseCases(request);
      expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
      expect((result as ErrorBaseResponse<List<AddressEntity>>).exception,
          exception);
      verify(addAddressUseCases(request)).called(1);
      verifyNoMoreInteractions(addAddressUseCases);
    });}


    ); }




