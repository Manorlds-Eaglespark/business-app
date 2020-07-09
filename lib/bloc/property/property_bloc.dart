import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/resources/repositories/property_repository.dart';
import 'package:rxdart/rxdart.dart';

class PropertyBloc {
  final _repository = PropertyRepository();
  final _propertyFetcher = PublishSubject<List<Property>>();

  Stream<List<Property>> get propertyStream => _propertyFetcher.stream;

  loadPropertyByCategoryId(int id) async {
    if (_isDisposed) {
      return;
    }
    final property = await _repository.fetchPropertyByCategoryId(id);
    _propertyFetcher.sink.add(property);
  }

  bool _isDisposed = false;

  dispose() {
    _propertyFetcher.close();
    _isDisposed = true;
  }
}
