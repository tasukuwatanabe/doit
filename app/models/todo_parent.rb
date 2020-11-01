class TodoParent < ApplicationRecord
  belongs_to :user
  has_many :todos, dependent: :destroy
end
