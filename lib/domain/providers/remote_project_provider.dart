import 'package:sejasa/domain/models/project_model.dart';

abstract class RemoteProjectProvider {
  Future<List<ProjectModel>> getProjects();
}
