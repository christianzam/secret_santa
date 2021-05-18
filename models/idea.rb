class Idea
  attr_accessor :id, :name, :bought
  attr_reader :price

  def initialize(attributes = {})
    @id = attributes[:id]
    @name = attributes[:name]
    @price = attributes[:price].to_f.round(2)
    @bought = attributes[:bought] #|| false
  end
end
