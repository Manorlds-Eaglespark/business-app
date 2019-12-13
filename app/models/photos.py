from shared_db import db, ma
from app.models.properties import Property

class Photo(db.Model):
    __tablename__ = 'photos'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.Integer,db.ForeignKey(Property.id))
    photo_1 = db.Column(db.String(255))
    photo_2 = db.Column(db.String(255))
    photo_3 = db.Column(db.String(255))
    photo_4 = db.Column(db.String(255))
    photo_5 = db.Column(db.String(255))
    photo_6 = db.Column(db.String(255))
    photo_7 = db.Column(db.String(255))
    property_ = db.relationship('Property', backref='photo')

    def __init__(self, photo_obj):
        self.property_id = photo_obj["property_id"]
        self.photo_1 = photo_obj["photo_1"]
        self.photo_2 = photo_obj["photo_2"]
        self.photo_3 = photo_obj["photo_3"]
        self.photo_4 = photo_obj["photo_4"]
        self.photo_5 = photo_obj["photo_5"]
        self.photo_6 = photo_obj["photo_6"]
        self.photo_7 = photo_obj["photo_7"]

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    def add_added(self, photos_obj):
        if photos_obj["photo_1"] != '':
            self.photo_1 = photos_obj["photo_1"]
        if photos_obj["photo_2"] != '':
            self.photo_2 = photos_obj["photo_2"]
        if photos_obj["photo_3"] != '':
            self.photo_3 = photos_obj["photo_3"]
        if photos_obj["photo_4"] != '':
            self.photo_4 = photos_obj["photo_4"]
        if photos_obj["photo_5"] != '':
            self.photo_5 = photos_obj["photo_5"]
        if photos_obj["photo_6"] != '':
            self.photo_6 = photos_obj["photo_6"]
        if photos_obj["photo_7"] != '':
            self.photo_7 = photos_obj["photo_7"]

class PhotoSchema(ma.Schema):
    class Meta:
        fields = ("id", "property_id", "photo_1", "photo_2", "photo_3", "photo_4", "photo_5", "photo_6", "photo_7")

photo_schema = PhotoSchema()
photos_schema = PhotoSchema(many=True)