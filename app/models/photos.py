from app.views import db

class Photo(db.Model):
    __tablename__ = 'photos'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.Integer)
    photo_1 = db.Column(db.String(255))
    photo_2 = db.Column(db.String(255))
    photo_3 = db.Column(db.String(255))
    photo_4 = db.Column(db.String(255))
    photo_5 = db.Column(db.String(255))
    photo_6 = db.Column(db.String(255))
    photo_7 = db.Column(db.String(255))

    def __init__(self, property_id, photo_1, photo_2,
         photo_3, photo_4, photo_5, photo_6, photo_7):
        self.property_id = property_id
        self.photo_1 = photo_1
        self.photo_2 = photo_2
        self.photo_3 = photo_3
        self.photo_4 = photo_4
        self.photo_5 = photo_5
        self.photo_6 = photo_6
        self.photo_7 = photo_7