import 'dart:async';

import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  final RemoteProjectProvider _provider;
  ProjectRepositoryImpl(this._provider);

  final _projectUpdateController = StreamController.broadcast();

  @override
  Stream<void> get projectUpdateStream => _projectUpdateController.stream;

  @override
  Future<List<Project>> getProjects({
    required int pages,
    required String type,
  }) async {
    final data = await _provider.getProjects();
    return data.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Project>> getMyProjects() async {
    final data = await _provider.getProjects();
    return data.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Project> getProject(String id) async {
    final data = await _provider.getProject(id);
    return data.toEntity();
  }

  @override
  Future<void> addNewProject(Project project) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _projectUpdateController.add(null);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateProject(Project project) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _projectUpdateController.add(null);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void dispose() {
    _projectUpdateController.close();
  }
}
