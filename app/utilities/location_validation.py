

class Location_Validation():

    def __init__(self, location_data):
        self.latitude = location_data["latitude"]
        self.longitude = location_data["longitude"]
        self.description = location_data["description"]

    def check_input(self):
        if not (self.latitude and self.longitude and self.description):
            return [400, "Make sure you fill all the required fields"]
        elif (not isinstance(self.latitude, float) or not isinstance(self.longitude, float) or not isinstance(self.description, str)):
            return [406, "Make sure to use correct types for all fields: Floats and String "]
        return [200, "All Good"]