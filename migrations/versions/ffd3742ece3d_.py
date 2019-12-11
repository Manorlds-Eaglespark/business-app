"""empty message

Revision ID: ffd3742ece3d
Revises: 66d7e7bf07d5
Create Date: 2019-12-10 14:54:06.792380

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'ffd3742ece3d'
down_revision = '66d7e7bf07d5'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('properties', sa.Column('company_id', sa.Integer(), nullable=True))
    op.create_foreign_key(None, 'properties', 'companies', ['company_id'], ['id'])
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(None, 'properties', type_='foreignkey')
    op.drop_column('properties', 'company_id')
    # ### end Alembic commands ###