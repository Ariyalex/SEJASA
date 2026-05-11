import 'package:sejasa/data/entities/project.dart';

abstract class ProjectRepository {
  Stream<void> get projectUpdateStream;

  Future<List<Project>> getProjects({required int pages, required String type});

  Future<List<Project>> getMyProjects();

  Future<Project> getProject(String id);

  Future<void> addNewProject(Project project);

  Future<void> updateProject(Project project);
}
