class Ad < ActiveRecord::Base
  validates :title, :description, :city, presence: true
end
