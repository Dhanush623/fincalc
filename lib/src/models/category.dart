import 'package:finance/src/models/sub_categories.dart';

class Category {
  int id;
  String name;
  List<SubCategories> subCategories;

  Category({
    required this.id,
    required this.name,
    required this.subCategories,
  });
}
