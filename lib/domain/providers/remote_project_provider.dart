import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/models/project_category_model.dart';
import 'package:sejasa/data/models/project_model.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';

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
}
