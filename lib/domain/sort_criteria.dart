enum SortField {
  name,
  size,
  createdAt,
  modifiedAt,
  lastLaunchedAt,
}

enum SortDirection {
  ascending,
  descending,
}

class SortCriteria {
  final SortField field;
  final SortDirection direction;

  SortCriteria({required this.field, required this.direction});
}
