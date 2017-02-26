class Address < ApplicationRecord
  extend EnumerateIt

  validates :street_type, :name, :number, :complement, presence: true

  has_enumeration_for :street_type

end