import 'dart:async';

import 'package:sejasa/data/value_objects/project_status.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  final RemoteProjectProvider _provider;
  ProjectRepositoryImpl(this._provider);

  final _projectUpdateController = StreamController.broadcast();

  @override
  Stream<void> get projectUpdateStream => _projectUpdateController.stream;

  @override
  Future<List<ProjectEntity>> getProjects({
    required int pages,
    required String type,
  }) async {
    final data = await _provider.getProjects();
    return data.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<ProjectEntity>> getMyProjects() async {
    final data = await _provider.getProjects();
    return data.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ProjectEntity> getProject(String id) async {
    final data = await _provider.getProject(id);
    return data.toEntity();
  }

  @override
  Future<List<ProjectEntity>> searchProjects({
    required String keyword,
    String? sort,
    ProjectStatus? status,
    String? category,
  }) async {
    final data = await _provider.searchProjects(
      keyword: keyword,
      sort: sort,
      status: status,
      category: category,
    );
    return data.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addNewProject(ProjectEntity project) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _projectUpdateController.add(null);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateProject(ProjectEntity project) async {
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
