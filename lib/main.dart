import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'features/classes/classes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Data Layer (In-Memory Data Source with sample classes matching Figma)
  final remoteDataSource = InMemoryClassRemoteDataSource();
  final classRepository = ClassRepositoryImpl(remoteDataSource: remoteDataSource);

  // Pre-populate sample classes from Figma design so the user sees live data immediately
  await remoteDataSource.createClass(ClassModel(
    id: 'cs201',
    name: 'Data Structures',
    courseCode: 'CS201',
    description: 'Algorithms and Data Structures course covering queues, stacks, trees.',
    joinCode: 'DS2026',
    teacherId: 'teacher_maya',
    teacherName: 'Dr. Maya Chen',
    enrolledStudentIds: const ['std_01', 'std_02', 'std_03'],
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    isActive: true,
    room: 'Engineering 204',
    schedule: 'Mon / Wed • 10:00 AM',
    term: 'Fall 2026',
  ));

  await remoteDataSource.createClass(ClassModel(
    id: 'cs202',
    name: 'Database Systems',
    courseCode: 'CS202',
    description: 'Relational & NoSQL Database design and normalization.',
    joinCode: 'DB2026',
    teacherId: 'teacher_maya',
    teacherName: 'Dr. Maya Chen',
    enrolledStudentIds: const ['std_01'],
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    isActive: true,
    room: 'Hall 3',
    schedule: 'Tue / Thu • 12:00 PM',
    term: 'Fall 2026',
  ));

  // Initialize Domain Layer UseCases
  final createClassUseCase = CreateClassUseCase(classRepository);
  final getTeacherClassesUseCase = GetTeacherClassesUseCase(classRepository);
  final joinClassByCodeUseCase = JoinClassByCodeUseCase(classRepository);
  final checkStudentEnrollmentUseCase = CheckStudentEnrollmentUseCase(classRepository);

  runApp(ClassTrackApp(
    createClassUseCase: createClassUseCase,
    getTeacherClassesUseCase: getTeacherClassesUseCase,
    joinClassByCodeUseCase: joinClassByCodeUseCase,
    checkStudentEnrollmentUseCase: checkStudentEnrollmentUseCase,
  ));
}

class ClassTrackApp extends StatelessWidget {
  final CreateClassUseCase createClassUseCase;
  final GetTeacherClassesUseCase getTeacherClassesUseCase;
  final JoinClassByCodeUseCase joinClassByCodeUseCase;
  final CheckStudentEnrollmentUseCase checkStudentEnrollmentUseCase;

  const ClassTrackApp({
    super.key,
    required this.createClassUseCase,
    required this.getTeacherClassesUseCase,
    required this.joinClassByCodeUseCase,
    required this.checkStudentEnrollmentUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClassesCubit>(
      create: (_) => ClassesCubit(
        createClassUseCase: createClassUseCase,
        getTeacherClassesUseCase: getTeacherClassesUseCase,
        joinClassByCodeUseCase: joinClassByCodeUseCase,
        checkStudentEnrollmentUseCase: checkStudentEnrollmentUseCase,
      ),
      child: MaterialApp(
        title: 'ClassTrack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.brandBlue,
            primary: AppColors.brandBlue,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.cardWhite,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: const MainNavigationShell(),
      ),
    );
  }
}

/// Navigation shell allowing the developer to easily test both Doctor and Student views
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TeacherClassesPage(
      teacherId: 'teacher_maya',
      teacherName: 'Dr. Maya Chen',
    ),
    StudentClassesPage(
      studentId: 'student_alex',
      studentName: 'Alex Rivera',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.cardWhite,
        indicatorColor: AppColors.blueLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.school_rounded, color: AppColors.brandBlue),
            label: 'Doctor View',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.brandBlue),
            label: 'Student View',
          ),
        ],
      ),
    );
  }
}
