import 'package:flutter/material.dart';

enum ProjectStatus {
  hiring('hiring', 'Merekrut'),
  going('ongoing', 'Sedang Berlangsung'),
  pending('pending', 'Ditunda'),
  cancled('cancel', 'Dibatalkan'),
  completed('done', 'Selesai');

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

  Color getTextColor(ThemeData theme) {
    switch (this) {
      case ProjectStatus.hiring:
        return theme.colorScheme.onPrimary;
      case ProjectStatus.going:
        return theme.colorScheme.onSecondary;
      case ProjectStatus.completed:
        return Colors.white;
      case ProjectStatus.cancled:
        return theme.colorScheme.onError;
      case ProjectStatus.pending:
        return Colors.white;
    }
  }

  Color getBackgroundColor(ThemeData theme) {
    switch (this) {
      case ProjectStatus.hiring:
        return theme.colorScheme.primary;
      case ProjectStatus.going:
        return theme.colorScheme.secondary;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.cancled:
        return theme.colorScheme.error;
      case ProjectStatus.pending:
        return Colors.deepOrange;
    }
  }
}
