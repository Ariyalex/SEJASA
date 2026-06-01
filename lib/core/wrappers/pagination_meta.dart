class PaginationMeta {
  final int currentPage;
  final int limitPage;
  final int totalItems;
  final int totalPages;

  PaginationMeta({
    required this.currentPage,
    required this.limitPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'],
      limitPage: json['limit_page'],
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
    );
  }
}
