enum SortProjectType {
  newest('newest', 'Terbaru'),
  oldest('oldest', 'Terlama'),
  popular('popular', 'Terpopuler');

  final String jsonValue;
  final String display;
  const SortProjectType(this.jsonValue, this.display);
}
