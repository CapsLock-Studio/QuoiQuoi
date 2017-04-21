class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  ROLES = %w[admin, author]

  devise :database_authenticatable, :rememberable, :trackable, :validatable
end