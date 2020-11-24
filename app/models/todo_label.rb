class TodoLabel < ApplicationRecord
  belongs_to :todo
  belongs_to :label
end
