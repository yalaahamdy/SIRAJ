import 'package:equatable/equatable.dart';

/// Module grouping within a Course (§5, §37).
class CourseModule extends Equatable {
  final String moduleId;
  final String courseId;
  final String title;
  final String description;
  final int orderIndex;
  final List<String> lessonIds;
  final List<String> prerequisiteModuleIds;

  const CourseModule({
    required this.moduleId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.lessonIds,
    this.prerequisiteModuleIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'module_id': moduleId,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order_index': orderIndex,
      'lesson_ids': lessonIds,
      'prerequisite_module_ids': prerequisiteModuleIds,
    };
  }

  factory CourseModule.fromMap(Map<String, dynamic> map) {
    final rawLessons = map['lesson_ids'] as List<dynamic>? ?? [];
    final rawPrereqs = map['prerequisite_module_ids'] as List<dynamic>? ?? [];

    return CourseModule(
      moduleId: map['module_id'] as String,
      courseId: map['course_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      orderIndex: map['order_index'] as int,
      lessonIds: rawLessons.map((e) => e.toString()).toList(),
      prerequisiteModuleIds: rawPrereqs.map((e) => e.toString()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        moduleId,
        courseId,
        title,
        description,
        orderIndex,
        lessonIds,
        prerequisiteModuleIds,
      ];
}
