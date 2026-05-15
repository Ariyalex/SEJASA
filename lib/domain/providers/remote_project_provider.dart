import 'package:sejasa/data/models/project_model.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

abstract class RemoteProjectProvider {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProject(String id);
  Future<List<ProjectModel>> searchProjects({
    required String keyword,
    String? sort,
    ProjectStatus? status,
    String? category,
  });
}
