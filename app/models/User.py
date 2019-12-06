from app.views import db

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    email = db.Column(db.String(200))
    password = db.Column(db.String(255))
    thumbnail = db.Column(db.String(255))
    role = db.Column(db.String(20))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self, name, password, email, role):
        self.name = name
        self.password = password
        self.email = email
        self.role = role
