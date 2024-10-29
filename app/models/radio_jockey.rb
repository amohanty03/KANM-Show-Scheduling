class RadioJockey < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :show_name, presence: true
end
