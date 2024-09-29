class Admin < ApplicationRecord
    validates :email, presence: true, uniqueness: true
end
