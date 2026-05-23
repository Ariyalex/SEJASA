import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/models/project_category_model.dart';
import 'package:sejasa/data/models/project_model.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';
import 'package:sejasa/data/payloads/review_project_participant_payload.dart';

abstract class RemoteProjectProvider {
  Future<PaginatedResult<ProjectModel>> getProjects(
    Map<String, dynamic>? queryParameters, {
    required int page,
    required int limit,
  });
  Future<ProjectModel> getProject(String id);
  Future<List<ProjectModel>> getUserProjects(
    Map<String, dynamic>? queryParameters, {
    required String userId,
  });
  Future<ProjectModel> createProject(ProjectCreatePayload payload);
  Future<ProjectModel> updateProject(ProjectUpdatePayload payload);

  Future<List<ProjectCategoryModel>> getAllCategory();

  Future<({String chatId, String userId, String projectId})> applyPorject(
    String projectId,
  );

  Future<void> applyProjectParticipant({
    required String projectId,
    required String participantId,
    required String status,
  });

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
