enum ProjectFilterType {
  all("all", "Semua"),
  hiring("hiring", "Merekrut"),
  going("on_going", "Sedang Berlangsung"),
  completed("completed", "Selesai"),
  cancled("cancled", "Dibatalkan");

  final String jsonValue;
  final String label;
  const ProjectFilterType(this.jsonValue, this.label);

  String get toJson => jsonValue;
  String get display => label;
}
