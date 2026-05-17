import 'dart:async';

import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  final RemoteProjectProvider _provider;
  ProjectRepositoryImpl(this._provider);

  @override
  Future<PaginatedResult<ProjectEntity>> getNearestProjects(
    int page,
    int limit,
  ) async {
    final result = await _provider.getNearestProjects(page, limit);

    final projects = result.data.map((e) => e.toEntity()).toList();

    return PaginatedResult<ProjectEntity>(data: projects, meta: result.meta);
  }

  @override
  Future<List<ProjectEntity>> getMyProjects() {
    throw UnimplementedError();
  }

  @override
  Future<ProjectEntity> getProject(String id) async {
    final data = await _provider.getProject(id);
    return data.toEntity();
  }

  @override
  Future<PaginatedResult<ProjectEntity>> searchProjects({
    required String keyword,
    String? sort,
    ProjectStatus? status,
    String? category,
    required int page,
    required int limit,
  }) async {
    try {
      final Map<String, dynamic> queryParameter = {'q': keyword};
      if (sort != null) queryParameter['sort'] = sort;
      if (status != null) queryParameter['status'] = status.jsonValue;
      if (category != null) queryParameter['category'] = category;

      final result = await _provider.getProjects(
        queryParameter,
        page: page,
        limit: limit,
      );

      final entities = result.data.map((e) => e.toEntity()).toList();

      return PaginatedResult(data: entities, meta: result.meta);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProjectEntity> createProject(ProjectCreatePayload payload) async {
    try {
      final response = await _provider.createProject(payload);

      return response.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProjectEntity> updateProject(ProjectUpdatePayload payload) async {
    try {
      final response = await _provider.updateProject(payload);
      return response.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<ProjectEntity>> getNewestProjects(
    int page,
    int limit,
  ) async {
    try {
      final response = await _provider.getProjects(
        {'sort': 'newest'},
        page: page,
        limit: limit,
      );
      final List<ProjectEntity> projects = List<ProjectEntity>.from(
        response.data.map((e) => e.toEntity()),
      );
      return PaginatedResult(data: projects, meta: response.meta);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<ProjectEntity>> getPopularProjects(
    int page,
    int limit,
  ) async {
    try {
      final response = await _provider.getProjects(
        {'sort': 'popular'},
        page: page,
        limit: limit,
      );
      final List<ProjectEntity> projects = response.data
          .map((e) => e.toEntity())
          .toList();
      return PaginatedResult(data: projects, meta: response.meta);
    } catch (e) {
      rethrow;
    }
  }
}
