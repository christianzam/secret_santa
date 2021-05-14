class Meal
  attr_accessor :id
  attr_reader :name, :price, :bought

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @price = attributes[:price]
    @bought = false
  end
end