import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/resources/api_providers/general_search.dart';

class SearchRepository {
  final generalSearchApiProvider = GeneralSearchApiProvider();

  Future <List<Property>>fetchGeneralSearchResults(String query) async {
    return await generalSearchApiProvider.fetchGeneralSearchResults(query);
  }
}