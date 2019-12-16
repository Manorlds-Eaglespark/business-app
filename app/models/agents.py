from shared import db, ma
from app.models.user import User

class Agent(db.Model):
    __tablename__ = 'agents'
    id = db.Column(db.Integer, primary_key=True)
    manager = db.Column(db.Integer, db.ForeignKey(User.id))
    name = db.Column(db.String(50))
    description = db.Column(db.String(255))
    telephone = db.Column(db.String(50))
    email = db.Column(db.String(150))
    address = db.Column(db.String(255))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())
    user = db.relationship('User', backref='agent')

    def __init__(self, agent_data):
        self.manager = agent_data['manager']
        self.name = agent_data['name']
        self.description = agent_data['description']
        self.telephone = agent_data['telephone']
        self.email = agent_data['email']
        self.address = agent_data['address']

    def save(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    def add_added(self, agent_obj):
        if agent_obj['name'] != '':
            self.name = agent_obj['name']
        if agent_obj["description"] != '':
            self.description = agent_obj["description"]
        if agent_obj["telephone"] != '':
            self.telephone = agent_obj["telephone"]
        if agent_obj["email"] != '':
            self.email = agent_obj["email"]
        if agent_obj["address"] != '':
            self.address = agent_obj["address"]
      

class AgentSchema(ma.Schema):
    class Meta:
        fields = ("id", "manager", "name", "description", "telephone", "email", "address", "time_added")

agent_schema = AgentSchema()
agents_schema = AgentSchema(many=True)