import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum GenderType {
  male("male", "Laki-Laki", LucideIcons.mars),
  female("female", "Perempuan", LucideIcons.venus);

  final String jsonValue;
  final String display;
  final IconData icon;
  const GenderType(this.jsonValue, this.display, this.icon);
}
