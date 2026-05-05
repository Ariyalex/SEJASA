import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';

class ProjectRepository {
  final RemoteProjectProvider _provider;
  ProjectRepository(this._provider);

  Future<List<Project>> getProjects() async {
    final data = await _provider.getProjects();
    return data.map((e) => e.toEntity()).toList();
  }
}
