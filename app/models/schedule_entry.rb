class ScheduleEntry < ApplicationRecord
    validates :day, presence: true, inclusion: { in: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday] }
    validates :hour, presence: true, numericality: { only_integer: true, in: 0..23 }
  
    #belongs_to :radio_jockey, optional: true, foreign_key: :jockey_id # Can be implemented later
  end
  