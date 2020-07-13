from shared import db, ma
from app.models.properties import Property

class Photo(db.Model):
    __tablename__ = 'photos'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.Integer,db.ForeignKey(Property.id))
    image = db.Column(db.String(255))
    del_hash = db.Column(db.String(155))
    property_ = db.relationship('Property', backref='photo')

    def __init__(self, photo_obj):
        self.property_id = photo_obj["property_id"]
        self.image = photo_obj["image"]
        self.del_hash = photo_obj["del_hash"]

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class PhotoSchema(ma.Schema):
    class Meta:
        fields = ("image",)

photo_schema = PhotoSchema()
photos_schema = PhotoSchema(many=True)
