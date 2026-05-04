enum ProjectStatus {
  hiring('hiring', 'Merekrut'),
  going('on_going', 'Sedang Berlangsung'),
  cancled('cancled', 'Dibatalkan'),
  completed('completed', 'Selesai');

  final String jsonValue;
  final String label;
  const ProjectStatus(this.jsonValue, this.label);

  String get display => label;
  String get toJson => jsonValue;

  static ProjectStatus stringToEnum(String value) {
    return ProjectStatus.values.firstWhere(
      (element) => element.jsonValue == value || element.label == value,
      orElse: () => throw Exception('invalid status value: $value'),
    );
  }
}
