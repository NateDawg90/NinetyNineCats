class Cat < ActiveRecord::Base
  COLORS = [
    'Blue', 'Grey', 'Black', 'White', 'Orange', 'Red', 'Purple', 'Brown'
  ]
  validates :name, presence: true
  validates :sex, inclusion: { in: %w(M F),
    message: "%{value} is not a valid sex" }
  validates :color, inclusion: { in: COLORS,
    message: "%{value} is not a valid color" }

  has_many :cat_rental_requests,
    foreign_key: :cat_id,
    class_name: :CatRentalRequest, dependent: :destroy

  def age
    (Date.today - self.birth_date).numerator / 365
  end
end
