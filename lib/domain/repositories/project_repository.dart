import 'package:sejasa/domain/entities/project_entity.dart';

abstract class ProjectRepository {
  Stream<void> get projectUpdateStream;

  Future<List<ProjectEntity>> getProjects({
    required int pages,
    required String type,
  });

  Future<List<ProjectEntity>> getMyProjects();

  Future<ProjectEntity> getProject(String id);

  Future<void> addNewProject(ProjectEntity project);

  Future<void> updateProject(ProjectEntity project);
}
