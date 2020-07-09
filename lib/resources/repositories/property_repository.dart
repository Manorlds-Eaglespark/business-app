
import 'file:///E:/projects/Flutter/mutuuze/lib/resources/api_providers/property/property_provider.dart';

class PropertyRepository {
  final propertyApiProvider = PropertyApiProvider();

  fetchPropertyByCategoryId(categoryId) async {
    return await propertyApiProvider.fetchAllPropertyByCategoryId(categoryId);
  }

  fetchPropertyByAgentId(agentId) async {
    return await propertyApiProvider.fetchAllPropertyByAgentId(agentId);
  }

  createNewProperty(token, propertyDetails, imagesList) async {
    return await propertyApiProvider.sendNewPropertyDetails(token, propertyDetails, imagesList);
  }
}
