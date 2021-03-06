from shared import db, ma
from app.models.agents import Agent
from app.models.categories import Category

class Property(db.Model):
    __tablename__ = 'properties'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    description = db.Column(db.String(255))
    category_id = db.Column(db.Integer, db.ForeignKey(Category.id))
    agent_id = db.Column(db.Integer, db.ForeignKey(Agent.id))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())
    agent = db.relationship('Agent', backref='property')
    category = db.relationship('Category', backref='property')

    def __init__(self, name, description, category, company):
        self.name = name
        self.description = description
        self.category_id = category
        self.company_id = company
    
    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class PropertySchema(ma.Schema):
    class Meta:
        fields = ("id", "name", "company_id", "description", "category_id", "time_added")

property_schema = PropertySchema()
properties_schema = PropertySchema(many=True)
