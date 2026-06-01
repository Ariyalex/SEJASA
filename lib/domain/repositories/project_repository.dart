import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';
import 'package:sejasa/data/payloads/review_project_participant_payload.dart';
import 'package:sejasa/domain/entities/project_category_entity.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/domain/entities/project_entity.dart';

abstract class ProjectRepository {
  Future<PaginatedResult<ProjectEntity>> getNearestProjects(
    int page,
    int limit,
    double latitude,
    double longitude,
  );
  Future<PaginatedResult<ProjectEntity>> getNewestProjects(int page, int limit);
  Future<PaginatedResult<ProjectEntity>> getPopularProjects(
    int page,
    int limit,
  );

  Future<List<ProjectEntity>> getAcceptedProjects(String userId);
  Future<List<ProjectEntity>> getUploadedProjects(String userId);
  Future<List<ProjectEntity>> getPendingProjects(String userId);
  Future<List<ProjectEntity>> getRejectedProjects(String userId);

  Future<ProjectEntity> getProject(String id);

  Future<PaginatedResult<ProjectEntity>> searchProjects({
    required String keyword,
    String? sort,
    ProjectStatus? status,
    String? category,
    required int page,
    required int limit,
  });

  Future<ProjectEntity> createProject(ProjectCreatePayload payload);

  Future<ProjectEntity> updateProject(ProjectUpdatePayload payload);

  Future<List<ProjectCategoryEntity>> getAllCategory();

  Future<({String chatId, String userId, String projectId})> applyPorject(
    String projectId,
  );

  Future<void> acceptProjectParticipant(String projectId, String participantId);
  Future<void> rejectProjectParticipant(String projectId, String participantId);
  Future<void> reviewProject({
    required String projectId,
    required double rating,
    required String review,
  });

  Future<void> reviewProjectParticipant(
    ReviewProjectParticipantPayload payload,
  );
  Future<void> reviewAllProjectParticipant({
    required String projectId,
    required double rating,
    required String review,
  });
}
