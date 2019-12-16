from shared import db, ma
from app.models.user import User

class Company(db.Model):
    __tablename__ = 'companies'
    id = db.Column(db.Integer, primary_key=True)
    manager = db.Column(db.Integer, db.ForeignKey(User.id))
    name = db.Column(db.String(50))
    description = db.Column(db.String(255))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())
    user = db.relationship('User', backref='company')

    def __init__(self, manager, name, description):
        self.manager = manager
        self.name = name
        self.description = description

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

class CompanySchema(ma.Schema):
    class Meta:
        fields = ("id", "manager", "name", "description", "time_added")

company_schema = CompanySchema()
companies_schema = CompanySchema(many=True)