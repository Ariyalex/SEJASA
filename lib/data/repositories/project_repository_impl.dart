import 'dart:async';

import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';
import 'package:sejasa/data/payloads/review_project_participant_payload.dart';
import 'package:sejasa/domain/entities/project_category_entity.dart';
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
    double latitude,
    double longitude,
  ) async {
    final result = await _provider.getProjects(
      {
        'distance': 25000,
        'most_distance': 'nearest',
        'lat': latitude,
        'lon': longitude,
      },
      page: page,
      limit: limit,
    );

    final projects = result.data.map((e) => e.toEntity()).toList();

    return PaginatedResult<ProjectEntity>(data: projects, meta: result.meta);
  }

  @override
  Future<List<ProjectEntity>> getAcceptedProjects(String userId) async {
    try {
      final result = await _provider.getUserProjects({
        'sort': 'accepted',
      }, userId: userId);
      return List<ProjectEntity>.from(result.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProjectEntity>> getUploadedProjects(String userId) async {
    try {
      final result = await _provider.getUserProjects({
        'sort': 'uploaded',
      }, userId: userId);
      return List<ProjectEntity>.from(result.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProjectEntity>> getPendingProjects(String userId) async {
    try {
      final result = await _provider.getUserProjects({
        'sort': 'pending',
      }, userId: userId);
      return List<ProjectEntity>.from(result.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProjectEntity>> getRejectedProjects(String userId) async {
    try {
      final result = await _provider.getUserProjects({
        'sort': 'rejected',
      }, userId: userId);
      return List<ProjectEntity>.from(result.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
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

  @override
  Future<List<ProjectCategoryEntity>> getAllCategory() async {
    try {
      final response = await _provider.getAllCategory();

      return List<ProjectCategoryEntity>.from(
        response.map((e) => e.toEntity()),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<({String chatId, String projectId, String userId})> applyPorject(
    String projectId,
  ) async {
    final response = await _provider.applyPorject(projectId);
    return response;
  }

  @override
  Future<void> acceptProjectParticipant(
    String projectId,
    String participantId,
  ) async {
    await _provider.applyProjectParticipant(
      projectId: projectId,
      participantId: participantId,
      status: 'accepted',
    );
  }

  @override
  Future<void> rejectProjectParticipant(
    String projectId,
    String participantId,
  ) async {
    await _provider.applyProjectParticipant(
      projectId: projectId,
      participantId: participantId,
      status: 'rejected',
    );
  }

  @override
  Future<void> reviewAllProjectParticipant({
    required String projectId,
    required double rating,
    required String review,
  }) async {
    await _provider.reviewAllProjectParticipant(
      projectId: projectId,
      rating: rating,
      review: review,
    );
  }

  @override
  Future<void> reviewProject({
    required String projectId,
    required double rating,
    required String review,
  }) async {
    await _provider.reviewProject(
      projectId: projectId,
      rating: rating,
      review: review,
    );
  }

  @override
  Future<void> reviewProjectParticipant(
    ReviewProjectParticipantPayload payload,
  ) async {
    await _provider.reviewProjectParticipant(payload);
  }
}
