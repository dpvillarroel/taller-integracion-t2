class Artist < ApplicationRecord
    has_many :albums, dependent: :destroy
    validates :name, presence: true
    validates :age, presence: true, numericality: { only_integer: true }
end
