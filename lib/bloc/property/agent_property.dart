import 'package:mutuuze/models/property.dart';
import 'package:mutuuze/resources/repositories/property_repository.dart';
import 'package:rxdart/rxdart.dart';

class AgentPropertyBloc {
  final _repository = PropertyRepository();
  final _agentPropertyFetcher = PublishSubject<List<Property>>();

  Stream<List<Property>> get agentPropertyStream => _agentPropertyFetcher.stream;

  loadPropertyByAgentId(int agentId) async {
    if (_isDisposed) {
      return;
    }
    final property = await _repository.fetchPropertyByAgentId(agentId);
    _agentPropertyFetcher.sink.add(property);
  }

  bool _isDisposed = false;

  dispose() {
    _agentPropertyFetcher.close();
    _isDisposed = true;
  }
}
