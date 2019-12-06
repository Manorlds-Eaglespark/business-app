
class Property(Model.db):
    __tablename__ = 'properties'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(155))
    description = db.Column(db.String(255))
    category = db.Column(db.String(200))
    client_id = db.Column(db.Integer))
    time_added = db.Column(db.DateTime, default=db.func.current_timestamp())

    def __init__(self, name, description, category, company):
        self.name = name
        self.description = description
        self.category = category
        self.company = company
