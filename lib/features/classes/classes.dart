/// Classes Management Module (Module B) - Public API.
///
/// Exports all domain entities, repository interfaces, use cases,
/// state management controllers, pages, and widgets required for
/// classes management in ClassTrack.
library classes;

// Domain Layer Exports
export 'domain/entities/class_entity.dart';
export 'domain/repositories/class_repository.dart';
export 'domain/errors/class_exceptions.dart';
export 'domain/usecases/create_class_usecase.dart';
export 'domain/usecases/get_teacher_classes_usecase.dart';
export 'domain/usecases/join_class_by_code_usecase.dart';
export 'domain/usecases/check_student_enrollment_usecase.dart';

// Data Layer Exports
export 'data/models/class_model.dart';
export 'data/datasources/class_remote_data_source.dart';
export 'data/repositories/class_repository_impl.dart';

// Presentation Layer Exports (State Management & UI)
export 'presentation/bloc/classes_state.dart';
export 'presentation/bloc/classes_cubit.dart';
export 'presentation/pages/teacher_classes_page.dart';
export 'presentation/pages/student_classes_page.dart';
export 'presentation/pages/class_details_page.dart';
export 'presentation/widgets/class_card.dart';
export 'presentation/widgets/create_class_dialog.dart';
export 'presentation/widgets/join_class_dialog.dart';
