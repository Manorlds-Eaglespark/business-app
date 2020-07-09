import 'package:mutuuze/models/category.dart';
import 'package:mutuuze/resources/repositories/category_repository.dart';
import 'package:rxdart/rxdart.dart';

class AllCategoriesBloc {
  final _repository = AllCategoriesRepository();
  final _allCategoriesFetcher = PublishSubject<List<Category>>();

  Stream<List<Category>> get getAllCategoriesStream => _allCategoriesFetcher.stream;

  loadAllCategories() async {
    if(_isDisposed){
      return;
    }
    final categories = await _repository.fetchAllCategories();
    _allCategoriesFetcher.sink.add(categories);
  }

  bool _isDisposed = false;
  dispose() {
    _allCategoriesFetcher.close();
    _isDisposed = true;
  }
}
