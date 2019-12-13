
class Photo_Validation():
    
    def __init__(self, photo_data):
        self.photo_1 = photo_data["photo_1"]
        self.photo_2 = photo_data["photo_2"]
        self.photo_3 = photo_data["photo_3"]
        self.photo_4 = photo_data["photo_4"]
        self.photo_5 = photo_data["photo_5"]
        self.photo_6 = photo_data["photo_6"]
        self.photo_7 = photo_data["photo_7"]

    def check_input(self):
        if not self.photo_1:
            return [400, "Upload atleast 1 image"]
        elif not isinstance(self.photo_1, str):
            return [406, "Image url should be a String "]
        return [200, "All Good"]
    