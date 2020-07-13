from shared import db, ma
from app.models.properties import Property

class Amenity(db.Model):
    __tablename__ = 'amenities'
    id = db.Column(db.Integer, primary_key=True)
    icon = db.Column(db.String(100))
    del_icon = db.Column(db.String(100))
    name = db.Column(db.String(100))

    def __init__(self, icon, icon_del, name):
        self.icon = icon
        self.del_icon = icon_del
        self.name = name
        
    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class AmenitySchema(ma.Schema):
    class Meta:
        fields = ("id", "icon", "name")

amenity_schema = AmenitySchema()
amenities_schema = AmenitySchema(many=True)