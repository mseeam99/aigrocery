import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum Category {
  FOOD,
  HOME,
  MEDICINE,
  OTHERS,
  AI,
}

final categoryIcons = {
  Category.FOOD: Icons.dinner_dining,
  Category.HOME: Icons.home,
  Category.MEDICINE: Icons.medication_outlined,
  Category.OTHERS: Icons.attach_money,
  Category.AI: MdiIcons.robotConfused,
};
