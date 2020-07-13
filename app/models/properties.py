from shared import db, ma
import datetime
from app.models.agents import Agent
from app.models.categories import Category

class Property(db.Model):
    __tablename__ = 'properties'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    price_offer  = db.Column(db.String(155))
    description = db.Column(db.String(255))
    address = db.Column(db.String(255))
    lat = db.Column(db.Float)
    long = db.Column(db.Float)
    category_id = db.Column(db.Integer, db.ForeignKey(Category.id))
    # agent_id = db.Column(db.Integer, db.ForeignKey(Agent.id))
    agent_id = db.Column(db.Integer)
    time_added = db.Column(db.String)
    # agent = db.relationship('Agent', backref='property')
    category = db.relationship('Category', backref='property')

    def __init__(self, name, price_offer, description, category, agent_id, address, lat, long):
        self.name = name
        self.price_offer = price_offer
        self.description = description
        self.category_id = category
        self.agent_id = agent_id
        self.address = address
        self.lat = lat
        self.long = long
        self.time_added = datetime.datetime.utcnow()
    
    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class PropertySchema(ma.Schema):
    class Meta:
        fields = ("id", "name", "price_offer", "agent_id", "description", "category_id", "address", "lat", "long", "time_added")

property_schema = PropertySchema()
properties_schema = PropertySchema(many=True)
