import 'package:mutuuze/resources/api_providers/categories_provider.dart';

class AllCategoriesRepository {
  final allCategoriesApiProvider = CategoriesApiProvider();

  fetchAllCategories() async {
    return await allCategoriesApiProvider.fetchAllCategories();
  }
}
