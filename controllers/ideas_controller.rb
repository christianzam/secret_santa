require_relative '../models/idea'
require 'open-uri'
require 'nokogiri'
require 'csv'
# require 'pry-byebug'

class IdeasController
  def initialize(idea_repository)
    @idea_repository = idea_repository
    @ideas_view = IdeasView.new
  end 
 
  def add_idea
    # ask user for gift name
    puts "\n"
    puts "What do you want to add?"
    print "> "
    # user_gift_name = gets.chomp
    name = @ideas_view.ask_user_for(:name)
    # ask user for gift price
    puts "\n"
    puts "What price?"
    print "> "
    # user_gift_price = gets.chomp.to_i
    price = @ideas_view.ask_user_for(:price).to_f.round(2)
    # build a hash with keys :name and :price and the correct values
    # gift = { name: user_gift_name, price: user_gift_price, bought: false }
    idea = Idea.new(name: name, price: price, bought: false)
    # push the gift into gift_list with <<
    # gift_list << gift
    @idea_repository.create(idea)
    puts "\n"
    puts "#{idea.name} has been added to your list"
    # save gift_list in csv file
    # save_csv(gift_list)
  end 

  def list_ideas
    display_ideas
  end

  def display_ideas
    
    ideas = @idea_repository.all
    puts "There are #{ideas.length} ideas from Etsy.com in your list"
    puts " "
    @ideas_view.display(ideas)
  end
    
  
  def scrape_etsy(keyword)
    # forge the URL
    url = "https://www.etsy.com/search?q=#{keyword}"
    # open the URL
    response = URI.open(url).read
    # convert the response into a Nokogiri document
    html_doc = Nokogiri::HTML(response)
    # search in the doc each element with class '.v2-listing-card__info'
    # initialize a etsy_gifts array
    etsy_gifts = []
    id = 1
    html_doc.search('.v2-listing-card__info').each do |element|
      etsy_name = element.search('.text-body').text.strip
      etsy_price = element.search('.currency-value').text.strip.to_i
      # create a gift with those information
      bought = false
      etsy_gifts << {id: id, name: etsy_name, price: etsy_price, bought: bought }
      id += 1
    end
    # return an array of gifts
    etsy_gifts
  end

  def show_etsy_results(etsy_results)
    etsy_results.each_with_index do |gift, index|
      # condition ? code if true : code if false
      status = gift[:bought] ? "[x]" : "[ ]"
      puts "#{index + 1} - #{status} #{gift[:name]} / #{gift[:price]}$"
    end
  end

  def print_etsy_ideas
    puts "\n"
    puts "What are you looking for on Etsy?"
    print "> "
    keyword = gets.chomp
    # call the scrape etsy method with keyword
    etsy_results = scrape_etsy(keyword)
    # display results from etsy
    puts "\n"
    puts "Here are Etsy results for '#{keyword.upcase}':"
    show_etsy_results(etsy_results)
    #ask the user which item to add
    puts "Pick one to add to your list (give the number)"
    print "> "
    # retrieve index
    user_index = gets.chomp.to_i - 1
    # grab the item in Etsy results and toggle its value
    gift = etsy_results[user_index]
    gift[:bought] = !gift[:bought]
    # delete original gift not marked
    etsy_results.delete_at(user_index) if gift[:name] == etsy_results[user_index][:name]
    # add the gift to gift_list
    @idea_repository.create_etsy_result(gift)
    puts "Your #{keyword.upcase} has been added to your list"
  end

  def mark
    puts "\n"
    list_ideas
    # create array from repo
    ideas_array = @idea_repository.all
     #ask user for index to mark
    puts "Which item have you bought (give the index)"
    print "> "
    # retrieve item index
    user_index = gets.chomp.to_i - 1
    # grab the right gift in gift_list and toggle its value
    marked_gift = ideas_array[user_index]
    marked_gift.bought = !marked_gift.bought
    status = marked_gift.bought ? "bought" : "pending"
    puts "\n"
    puts "#{marked_gift.name} has been marked as #{status}"
    # delete original gift not marked
    ideas_array.delete_at(user_index) if marked_gift.name == ideas_array[user_index].name
    # save gift_list in csv
    @idea_repository.create_marked_gift(marked_gift)
  end
  # #=================================================================
  # #   when "delete"
  # #   puts "\n"
  # #   list(gift_list)
  # #   # ask user for index to remove
  # #   puts "Which item do you want to delete?"
  # #   print "> "
  # #   # retrieve index
  # #   user_index = gets.chomp.to_i - 1
  # #   gift = gift_list[user_index]
  # #   puts "\n"
  # #   puts "#{gift[:name]} has been deleted from your list"
  # #   # delete gift element in gift_list
  # #   gift_list.delete_at(user_index)
  # #   # save the gift_list in csv
  # #   save_csv(gift_list)
  # # end
end