import 'dart:async';

import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:sejasa/core/wrappers/pagination_meta.dart';
import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/models/project_category_model.dart';
import 'package:sejasa/data/models/project_model.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';
import 'package:sejasa/data/payloads/review_project_participant_payload.dart';
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
  Future<PaginatedResult<ProjectModel>> getProjects(
    Map<String, dynamic>? queryParameters, {
    required int page,
    required int limit,
  }) async {
    final params = queryParameters ?? <String, dynamic>{};
    params['page'] = page;
    params['limit'] = limit;

    final response = await _apiService.get('/project', queryParameters: params);

    LogUtils.d("response getProjects: ${response.data}");

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
    LogUtils.i("response: $response");
    final data = response.data['data'];
    return ProjectModel.fromJson(data);
  }

  @override
  Future<List<ProjectModel>> getUserProjects(
    Map<String, dynamic>? queryParameter, {
    required String userId,
  }) async {
    final response = await _apiService.get(
      '/project/user/$userId',
      queryParameters: queryParameter,
    );

    final rawData = response.data['data'] as List?;

    return List<ProjectModel>.from(
      rawData?.map((e) => ProjectModel.fromJson(e)) ?? [],
    );
  }

  @override
  Future<List<ProjectCategoryModel>> getAllCategory() async {
    final response = await _apiService.get('/project/category');
    final rawData = response.data['data'] as List?;

    return List<ProjectCategoryModel>.from(
      rawData?.map((e) => ProjectCategoryModel.fromJson(e)) ?? [],
    );
  }

  @override
  Future<({String chatId, String projectId, String userId})> applyPorject(
    String projectId,
  ) async {
    final response = await _apiService.post('/project/$projectId/apply');
    final rawData = response.data['data'];

    return (
      chatId: rawData['id'] as String,
      userId: rawData['user_id'] as String,
      projectId: rawData['project_id'] as String,
    );
  }

  @override
  Future<void> applyProjectParticipant({
    required String projectId,
    required String participantId,
    required String status,
  }) async {
    await _apiService.post(
      '/project/$projectId/participant/$participantId',
      data: {'status': status},
    );
  }

  @override
  Future<void> reviewAllProjectParticipant({
    required String projectId,
    required double rating,
    required String review,
  }) async {
    await _apiService.post(
      '/project/$projectId/participant/review',
      data: {'rating': rating, 'review': review},
    );
  }

  @override
  Future<void> reviewProject({
    required String projectId,
    required double rating,
    required String review,
  }) async {
    await _apiService.post(
      '/project/$projectId/review',
      data: {'rating': rating, 'review': review},
    );
  }

  @override
  Future<void> reviewProjectParticipant(
    ReviewProjectParticipantPayload payload,
  ) async {
    await _apiService.post(
      '/project/${payload.projectId}/participant/${payload.participantId}/review',
      data: payload.toJson(),
    );
  }
}
