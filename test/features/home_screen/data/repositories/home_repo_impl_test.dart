
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home_screen/data/data_sources/home_remote_data_source_contract.dart';
import 'package:flower_app/features/home_screen/data/models/best_seller/best_seller.dart';
import 'package:flower_app/features/home_screen/data/models/category/category.dart';
import 'package:flower_app/features/home_screen/data/models/occasions/occasion.dart';
import 'package:flower_app/features/home_screen/data/repositories/home_repo_impl.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_model.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_model.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_repo_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSourceContract])
void main() {
  late HomeRepoImpl homeRepoImpl;
  late MockHomeRemoteDataSourceContract mockHomeRemoteDataSource;

 setUpAll((){
   provideDummy<BaseResponse<List<CategoryDto>>>(
     SuccessBaseResponse<List<CategoryDto>>(data: []),
   );
   provideDummy<BaseResponse<List<CategoryDto>>>(
     ErrorBaseResponse<List<CategoryDto>>(exception: Exception()),
   );
   provideDummy<BaseResponse<List<CategoryDto>>>(
     SuccessBaseResponse<List<CategoryDto>>(data: [
       CategoryDto(
         id: '1',
         name: 'test',
         slug: 'test',
         image: 'test',
         isSuperAdmin: true,
         createdAt: DateTime.now(),
         updatedAt: DateTime.now(),
         productsCount: 1,
       ),
     ]),
   );
   provideDummy<BaseResponse<List<OccasionDto>>>(
     SuccessBaseResponse<List<OccasionDto>>(data: []),
   );
   provideDummy<BaseResponse<List<OccasionDto>>>(
     ErrorBaseResponse<List<OccasionDto>>(exception: Exception()),
   );
   provideDummy<BaseResponse<List<OccasionDto>>>(
     SuccessBaseResponse<List<OccasionDto>>(data: [
       OccasionDto(
         id: '1',
         name: 'test',
         slug: 'test',
         image: 'test',
         isSuperAdmin: true,
         createdAt: DateTime.now(),
         updatedAt: DateTime.now(),
         productsCount: 1,
       ),
     ]),
   );
   provideDummy<BaseResponse<List<BestSellerDto>>>(
     SuccessBaseResponse<List<BestSellerDto>>(data: []),
   );
   provideDummy<BaseResponse<List<BestSellerDto>>>(
     ErrorBaseResponse<List<BestSellerDto>>(exception: Exception()),
   );
   provideDummy<BaseResponse<List<BestSellerDto>>>(
     SuccessBaseResponse<List<BestSellerDto>>(data: [
       BestSellerDto(
         id: '1',
         slug: 'test',
         isSuperAdmin: true,
         createdAt: DateTime.now(),
         updatedAt: DateTime.now(),
       ),
     ]),
   );

 });

 setUp(() {
   mockHomeRemoteDataSource = MockHomeRemoteDataSourceContract();
   homeRepoImpl = HomeRepoImpl(mockHomeRemoteDataSource);
 });

 group('Get Categories Function Test Group ', (){

   test('Test Success Case With Empty Data (No Products DTos Returned)  ', () async{
     when(mockHomeRemoteDataSource.getAllCategory()).thenAnswer((_)
     async => SuccessBaseResponse<List<CategoryDto>>(data: []));
    final result = await homeRepoImpl.getAllCategory();
    expect(result, isA<SuccessBaseResponse<List<CategoryModel>>>());
    expect((result as SuccessBaseResponse<List<CategoryModel>>).data, isEmpty);
   });
   test('Test Error Case With Exception ', () async{
     when(mockHomeRemoteDataSource.getAllCategory()).thenAnswer((_)
     async => ErrorBaseResponse<List<CategoryDto>>(exception: Exception()));
     final result = await homeRepoImpl.getAllCategory();
     expect(result, isA<ErrorBaseResponse<List<CategoryModel>>>());
   });
   test('Test Success Case With Data ', () async{
     when(mockHomeRemoteDataSource.getAllCategory()).thenAnswer((_)
     async => SuccessBaseResponse<List<CategoryDto>>(data: [
       CategoryDto(
         id: '1',
         name: 'test',
         slug: 'test',
         image: 'test',
         isSuperAdmin: true,
         createdAt: DateTime.now(),
         updatedAt: DateTime.now(),
         productsCount: 1,
       ),
     ]));
     final result = await homeRepoImpl.getAllCategory();
     expect(result, isA<SuccessBaseResponse<List<CategoryModel>>>());
     expect((result as SuccessBaseResponse<List<CategoryModel>>).data, isNotEmpty);
   });
   }) ;
  group('Get Occasion Function Test Group ', (){

    test('Test Success Case With Empty Data (No Products DTos Returned)  ', () async{
      when(mockHomeRemoteDataSource.getAllOccasion()).thenAnswer((_)
      async => SuccessBaseResponse<List<OccasionDto>>(data: []));
      final result = await homeRepoImpl.getAllOccasion();
      expect(result, isA<SuccessBaseResponse<List<OccasionModel>>>());
      expect((result as SuccessBaseResponse<List<OccasionModel>>).data, isEmpty);
    });
    test('Test Error Case With Exception ', () async{
      when(mockHomeRemoteDataSource.getAllOccasion()).thenAnswer((_)
      async => ErrorBaseResponse<List<OccasionDto>>(exception: Exception()));
      final result = await homeRepoImpl.getAllOccasion();
      expect(result, isA<ErrorBaseResponse<List<OccasionModel>>>());
    });
    test('Test Success Case With Data ', () async{
      when(mockHomeRemoteDataSource.getAllOccasion()).thenAnswer((_)
      async => SuccessBaseResponse<List<OccasionDto>>(data: [
        OccasionDto(
          id: '1',
          name: 'test',
          slug: 'test',
          image: 'test',
          isSuperAdmin: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productsCount: 1,
        ),
      ]));
      final result = await homeRepoImpl.getAllOccasion();
      expect(result, isA<SuccessBaseResponse<List<OccasionModel>>>());
      expect((result as SuccessBaseResponse<List<OccasionModel>>).data, isNotEmpty);
    });
  }) ;
  group('Get Best Seller Function Test Group ', (){

    test('Test Success Case With Empty Data (No Products DTos Returned)  ', () async{
      when(mockHomeRemoteDataSource.getAllBestSeller()).thenAnswer((_)
      async => SuccessBaseResponse<List<BestSellerDto>>(data: []));
      final result = await homeRepoImpl.getAllBestSeller();
      expect(result, isA<SuccessBaseResponse<List<BestSellerModel>>>());
      expect((result as SuccessBaseResponse<List<BestSellerModel>>).data, isEmpty);
    });
    test('Test Error Case With Exception ', () async{
      when(mockHomeRemoteDataSource.getAllBestSeller()).thenAnswer((_)
      async => ErrorBaseResponse<List<BestSellerDto>>(exception: Exception()));
      final result = await homeRepoImpl.getAllBestSeller();
      expect(result, isA<ErrorBaseResponse<List<BestSellerModel>>>());
    });
    test('Test Success Case With Data ', () async{
      when(mockHomeRemoteDataSource.getAllBestSeller()).thenAnswer((_)
      async => SuccessBaseResponse<List<BestSellerDto>>(data: [
        BestSellerDto(
          id: '1',
          slug: 'test',
          isSuperAdmin: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ]));
      final result = await homeRepoImpl.getAllBestSeller();
      expect(result, isA<SuccessBaseResponse<List<BestSellerModel>>>());
      expect((result as SuccessBaseResponse<List<BestSellerModel>>).data, isNotEmpty);
    });
  }) ;





}
