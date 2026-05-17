import 'dart:async';

import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/core/wrappers/pagination_meta.dart';
import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/models/project_model.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';

class RemoteProjectProviderImpl extends RemoteProjectProvider {
  final ApiService _apiService;
  RemoteProjectProviderImpl(this._apiService);
  @override
  Future<ProjectModel> getProject(String id) async {
    final response = await _apiService.get('/project/$id');
    final data = response.data['data'];
    return ProjectModel.fromJson(data);
  }

  @override
  Future<ProjectModel> createProject(ProjectCreatePayload payload) async {
    final response = await _apiService.post('/project', data: payload.toJson());

    final data = response.data['data'];
    return ProjectModel.fromJson(data);
  }

  @override
  Future<PaginatedResult<ProjectModel>> getNearestProjects(
    int page,
    int limit,
  ) async {
    final response = await _apiService.get(
      '/project/nearest',
      queryParameters: {'distance': 25000, 'page': page, 'limit': limit},
    );
    final metaRaw = response.data['meta'];
    final meta = metaRaw != null
        ? PaginationMeta.fromJson(metaRaw)
        : PaginationMeta(
            currentPage: page,
            limitPage: limit,
            totalItems: 0,
            totalPages: 1,
          );
    final data = response.data['data'] as List? ?? [];

    final projects = List<ProjectModel>.from(
      data.map((e) => ProjectModel.fromJson(e)),
    );
    return PaginatedResult<ProjectModel>(data: projects, meta: meta);
  }

  @override
  Future<PaginatedResult<ProjectModel>> getProjects(
    Map<String, dynamic>? queryParameters, {
    required int page,
    required int limit,
  }) async {
    final params = queryParameters ?? <String, dynamic>{};
    params['page'] = page;
    params['limit'] = limit;

    final response = await _apiService.get('/project', queryParameters: params);

    final metaRaw = response.data['meta'];
    final meta = metaRaw != null
        ? PaginationMeta.fromJson(metaRaw)
        : PaginationMeta(
            currentPage: page,
            limitPage: limit,
            totalItems: 0,
            totalPages: 1,
          );
    final data = response.data['data'] as List? ?? [];
    final projects = List<ProjectModel>.from(
      data.map((e) => ProjectModel.fromJson(e)),
    );

    return PaginatedResult<ProjectModel>(data: projects, meta: meta);
  }

  @override
  Future<ProjectModel> updateProject(ProjectUpdatePayload payload) async {
    final response = await _apiService.patch(
      '/project/${payload.id}',
      data: payload.toJson(),
    );
    final data = response.data['data'];
    return ProjectModel.fromJson(data);
  }
}
