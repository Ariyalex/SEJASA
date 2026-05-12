import 'package:sejasa/data/models/project_model.dart';

abstract class RemoteProjectProvider {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProject(String id);
}
