require_relative "../views/meals_view"
require_relative "../models/meal"
require "open-uri"
require 'nokogiri'

# =================================================================== GIFTS
class MealsController
  def initialize(meal_repository)
    @meal_repository = meal_repository
    @meals_view = MealsView.new
  end

  def add
    puts "\n"
    puts "What do you want to add?"
    print "> "
    name = @meals_view.ask_user_for(:name)
    puts "\n"
    puts "What price?"
    print "> "
    price = @meals_view.ask_user_for(:price).to_f.round(2)
    meal = Meal.new(name: name, price: price, bought: false)
    @meal_repository.create(meal)
    puts "\n"
    puts "#{meal.name} has been added to your list"
  end

  def list
    display_meals
  end

  def display_meals
    meals = @meal_repository.all
    puts "There are #{meals.length} in your list"
    puts " "
    @meals_view.display(meals)
  end
end