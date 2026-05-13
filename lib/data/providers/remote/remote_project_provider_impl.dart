import 'package:sejasa/data/models/project_model.dart';
import 'package:sejasa/data/value_objects/project_status.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';

class RemoteProjectProviderImpl extends RemoteProjectProvider {
  @override
  Future<List<ProjectModel>> getProjects() {
    // TODO: implement getProjects
    throw UnimplementedError();
  }

  @override
  Future<ProjectModel> getProject(String id) {
    // TODO: implement getProject
    throw UnimplementedError();
  }

  @override
  Future<List<ProjectModel>> searchProjects({
    required String keyword,
    String? sort,
    ProjectStatus? status,
    String? category,
  }) {
    // TODO: implement searchProjects
    throw UnimplementedError();
  }
}
