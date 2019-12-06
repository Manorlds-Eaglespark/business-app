from app.views import db

class Company(db.Model):
    __tablename__ = 'companies'
    id = db.Column(db.Integer, primary_key=True)
    manager = db.Column(db.Integer)
    name = db.Column(db.String(50))
    description = db.Column(db.String(255))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self):
        self.manager = manager
        self.name = name
        self.description = description