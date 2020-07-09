import 'package:mutuuze/models/create_property_response.dart';
import 'package:mutuuze/resources/repositories/property_repository.dart';
import 'package:rxdart/rxdart.dart';

class CreatePropertyBloc {
  final _repository = PropertyRepository();
  final _createPropertyFetcher = PublishSubject<CreatePropertyResponse>();

  Stream<CreatePropertyResponse> get agentPropertyStream => _createPropertyFetcher.stream;

  createNewProperty(String token, var details, List imagesList) async {
    if (_isDisposed) {
      return;
    }
     await _repository.createNewProperty(token, details, imagesList);
//    _createPropertyFetcher.sink.add(propertyResponse);
  }

  bool _isDisposed = false;

  dispose() {
    _createPropertyFetcher.close();
    _isDisposed = true;
  }
}