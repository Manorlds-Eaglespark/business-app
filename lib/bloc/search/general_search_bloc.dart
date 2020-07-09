import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/resources/repositories/search_repository.dart';
import 'package:rxdart/rxdart.dart';

class GeneralSearchBloc {
  final _repository = SearchRepository();
  final _searchResultsFetcher = PublishSubject<List<Property>>();

  Stream<List<Property>> get getSearchResultsStream =>
      _searchResultsFetcher.stream;

  loadSearchResults(String query) async {
    if (_isDisposed) {
      return;
    }
    List<Property> results = await _repository.fetchGeneralSearchResults(query);
    _searchResultsFetcher.sink.add(results);
  }

  bool _isDisposed = false;

  dispose() {
    _searchResultsFetcher.close();
    _isDisposed = true;
  }
}
