class Routine < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
end
