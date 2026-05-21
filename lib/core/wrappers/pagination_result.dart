import 'package:sejasa/core/wrappers/pagination_meta.dart';

class PaginatedResult<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResult({required this.data, required this.meta});
}
