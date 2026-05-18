import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/get_profile_screen/domain/entities/user_entitiy.dart';
import 'package:flower_app/features/get_profile_screen/domain/use_cases/get_profile_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_view_model_test.mocks.dart';

@GenerateMocks([GetProfileUseCases])
void main() {
late GetProfileUseCases getProfileUseCases;

setUpAll(() {
provideDummy<BaseResponse<GetUserEntity>>(
SuccessBaseResponse<GetUserEntity>(
data: GetUserEntity(
id: '1',
firstName: 'test',
lastName: 'test',
email: 'test',
password: 'test',
gender: 'test',
phone: 'test',
photo: 'test',
role: 'test',
),
),
);

provideDummy<BaseResponse<GetUserEntity>>(
ErrorBaseResponse<GetUserEntity>(
exception: Exception(),
),
);
});

setUp(() {
getProfileUseCases = MockGetProfileUseCases();
});

group('Get Profile Data Test Group', () {
test(
'Test Success Case With Empty Data',
() async {
when(getProfileUseCases()).thenAnswer(
(_) async => SuccessBaseResponse<GetUserEntity>(
data: GetUserEntity(),
),
);

final result = await getProfileUseCases();

expect(
result,
isA<SuccessBaseResponse<GetUserEntity>>(),
);

expect(
(result as SuccessBaseResponse<GetUserEntity>).data,
isNotNull,
);
},
);

test(
'Test Error Case With Exception',
() async {
when(getProfileUseCases()).thenAnswer(
(_) async => ErrorBaseResponse<GetUserEntity>(
exception: Exception(),
),
);

final result = await getProfileUseCases();

expect(
result,
isA<ErrorBaseResponse<GetUserEntity>>(),
);
},
);

test(
'Test Success Case With Data',
() async {
when(getProfileUseCases()).thenAnswer(
(_) async => SuccessBaseResponse<GetUserEntity>(
data: GetUserEntity(
id: '1',
firstName: 'test',
lastName: 'test',
email: 'test',
password: 'test',
gender: 'test',
phone: 'test',
photo: 'test',
role: 'test',
),
),
);

final result = await getProfileUseCases();

expect(
result,
isA<SuccessBaseResponse<GetUserEntity>>(),
);

expect(
(result as SuccessBaseResponse<GetUserEntity>).data,
isNotNull,
);
},
);
});
}
