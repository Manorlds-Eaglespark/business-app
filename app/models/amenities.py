from shared_db import db, ma
from app.models.properties import Property

class Amenity(db.Model):
    __tablename__ = 'amenities'
    id = db.Column(db.Integer, primary_key=True)
    property_id = db.Column(db.Integer, db.ForeignKey(Property.id))
    description = db.Column(db.String(255))
    property_ = db.relationship('Property', backref='amenity')

    def __init__(self, property_id, description):
        self.property_id = property_id
        self.description = description
        
    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class AmenitySchema(ma.Schema):
    class Meta:
        fields = ("id", "property_id", "description")

amenity_schema = AmenitySchema()
amenities_schema = AmenitySchema(many=True)