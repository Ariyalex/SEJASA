import 'package:sejasa/data/entities/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects({required int pages, required String type});

  Future<List<Project>> getMyProjects();

  Future<Project> getProject(String id);
}
