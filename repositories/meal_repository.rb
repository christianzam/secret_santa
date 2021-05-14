require "csv"
require_relative "../models/meal"

class MealRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @meals = []
    @next_id = 1
    load_csv if File.exist?(@csv_file)
  end

  def create(meal)
    meal.id = @next_id
    @meals << meal
    @next_id += 1
    save_csv
  end

  def all
    @meals
  end

  def find(id)
    @meals.find { |meal| meal.id == id }
  end


  private

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@csv_file, "wb", csv_options) do |csv|
      csv << ['id', 'name', 'price', 'bought']
      @meals.each do |meal|
        csv << [meal.id, meal.name, meal.price, meal.bought]
      end
    end
  end

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      row[:id] = row[:id].to_i
      row[:name] = row[:name].to_s
      row[:price] = row[:price].to_f
      row[:bought] = "true"
      @meals << Meal.new(row)
    end
    @next_id = @meals.last.id + 1 unless @meals.empty?
  end
end
