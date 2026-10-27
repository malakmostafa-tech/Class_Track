import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/main.dart';
import 'package:class_track/features/classes/classes.dart';

void main() {
  testWidgets('ClassTrack app smoke test', (WidgetTester tester) async {
    final remoteDataSource = InMemoryClassRemoteDataSource();
    final classRepository = ClassRepositoryImpl(remoteDataSource: remoteDataSource);

    final createClassUseCase = CreateClassUseCase(classRepository);
    final getTeacherClassesUseCase = GetTeacherClassesUseCase(classRepository);
    final joinClassByCodeUseCase = JoinClassByCodeUseCase(classRepository);
    final checkStudentEnrollmentUseCase = CheckStudentEnrollmentUseCase(classRepository);

    await tester.pumpWidget(ClassTrackApp(
      createClassUseCase: createClassUseCase,
      getTeacherClassesUseCase: getTeacherClassesUseCase,
      joinClassByCodeUseCase: joinClassByCodeUseCase,
      checkStudentEnrollmentUseCase: checkStudentEnrollmentUseCase,
    ));

    await tester.pumpAndSettle();

    // Verify Doctor View loads by default with title
    expect(find.text('My Classes'), findsOneWidget);
    expect(find.text('Doctor View'), findsOneWidget);
    expect(find.text('Student View'), findsOneWidget);
  });
}
