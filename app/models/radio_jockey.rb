class RadioJockey < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :show_name, presence: true

  def self.process_alt_times(day)
    alt_list = []
    day = day.delete(" ")
    day = day.split(";")
    alt_list = day.each.to_a
    alt_list
  end
end
