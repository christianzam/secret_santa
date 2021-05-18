require "csv"
require_relative "../models/idea"

class IdeaRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @ideas = []
    @next_id = 1
    load_marked_csv if File.exist?(@csv_file)
  end

  def create(idea)
    idea.id = @next_id
    @ideas << idea
    @next_id += 1
    save_marked_csv
  end

  def create_etsy_result(gift)
    gift[:id] = @next_id
    gift = Idea.new(gift)
    @ideas << gift
    @next_id += 1
    save_marked_csv
  end

  def create_marked_gift(marked_gift)
    marked_gift.id = @next_id
    @ideas << marked_gift
    @next_id += 1
    save_marked_csv
  end

  def all
    @ideas
  end

  def find(id)
    @ideas.find { |idea| idea.id == id }
  end

private 

  def load_marked_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      row[:id] = row[:id].to_i
      row[:name] = row[:name].to_s
      row[:price] = row[:price].to_f.round(2)
      row[:bought] = row[:bought] == 'true'
      @ideas << Idea.new(row)
    end
    @next_id = @ideas.last.id + 1 #unless @ideas.empty?
    @ideas
  end

  def save_marked_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@csv_file, 'wb', csv_options) do |csv|
      csv << ['id', 'name', 'price', 'bought']
      @ideas.each do |idea|
        csv << [idea.id, idea.name, idea.price, idea.bought]
      end
    end
  end
end
