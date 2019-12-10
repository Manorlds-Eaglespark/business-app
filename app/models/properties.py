from shared_db import db, ma
from app.models.companies import Company
from app.models.categories import Category

class Property(db.Model):
    __tablename__ = 'properties'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    description = db.Column(db.String(255))
    category_id = db.Column(db.Integer, db.ForeignKey(Category.id))
    company_id = db.Column(db.Integer, db.ForeignKey(Company.id))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())
    company = db.relationship('Company', backref='property')
    category = db.relationship('Category', backref='property')

    def __init__(self, name, description, category, company):
        self.name = name
        self.description = description
        self.category = category
        self.company_id = company

class PropertySchema(ma.Schema):
    class Meta:
        fields = ("id", "name", "company_id" "description", "category", "time_added")

property_schema = PropertySchema()
properties_schema = PropertySchema(many=True)
