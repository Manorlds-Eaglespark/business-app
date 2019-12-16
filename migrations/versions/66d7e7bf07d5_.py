"""empty message

Revision ID: 66d7e7bf07d5
Revises: 7e4be2ca5c90
Create Date: 2019-12-10 14:53:00.537001

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '66d7e7bf07d5'
down_revision = '7e4be2ca5c90'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint('properties_company_id_fkey', 'properties', type_='foreignkey')
    op.drop_column('properties', 'company_id')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('properties', sa.Column('company_id', sa.INTEGER(), autoincrement=False, nullable=True))
    op.create_foreign_key('properties_company_id_fkey', 'properties', 'companies', ['company_id'], ['id'])
    # ### end Alembic commands ###
