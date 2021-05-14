# TODO: you can build your christmas list program here!

require "csv"
require "open-uri"
require 'nokogiri'

puts "\n"
puts "*" * 31
puts "*" + " " * 29 + "*" 
puts "*  Welcome to Christmas List  *"
puts "*" + " " * 29 + "*" 
puts "*" * 31

gift_list = load_csv

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
  html_doc.search('.v2-listing-card__info').each do |element|
    etsy_name = element.search('.text-body').text.strip
    etsy_price = element.search('.currency-value').text.strip.to_i
    # create a gift with those information
    etsy_gifts << { name: etsy_name, price: etsy_price }
  end
  # return an array of gifts
  etsy_gifts
end

def list(gifts)
  gifts.each_with_index do |gift, index|
    # condition ? code if true : code if false
    status = gift[:bought] ? "[x]" : "[ ]"
    puts "#{index + 1} - #{status} #{gift[:name]} / #{gift[:price]}$"
  end
end

def load_csv
  filepath = 'ideas.csv'
  gifts = []

  CSV.foreach(filepath, { headers: :first_row }) do |row|
    gift = { name: row['name'], price: row['price'].to_i, bought: row['bought'] == "true" }
    gifts << gift
  end
  return gifts
end

def save_csv(gifts)
  csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
  filepath = 'ideas.csv'

  CSV.open(filepath, 'wb', csv_options) do |csv|
    csv << ['name', 'price', 'bought']

    gifts.each do |gift|
      csv << [ gift[:name], gift[:price], gift[:bought] ]
    end
  end
end


action = ""
until action == "quit"
  puts "\n"
  puts "You can [ list | add | delete | mark | idea | quit ]"
  puts "What do you want to do ?"
  print "> "
  action = gets.chomp.downcase

  case action
  when "list"
    puts "\n"
    puts "You currently have #{gift_list.length} item(s) in your list"
    list(gift_list)

  when "add"
    # ask user for gift name
    puts "\n"
    puts "What do you want to add?"
    print "> "
    user_gift_name = gets.chomp
    # ask user for gift price
    puts "\n"
    puts "What price?"
    print "> "
    user_gift_price = gets.chomp.to_i
    # build a hash with keys :name and :price and the correct values
    gift = { name: user_gift_name, price: user_gift_price, bought: false }
    # push the gift into gift_list with <<
    gift_list << gift
    puts "\n"
    puts "#{gift[:name]} has been added to your list"
    # save gift_list in csv file
    save_csv(gift_list)

  when "delete"
    puts "\n"
    list(gift_list)
    # ask user for index to remove
    puts "Which item do you want to delete?"
    print "> "
    # retrieve index
    user_index = gets.chomp.to_i - 1
    gift = gift_list[user_index]
    puts "\n"
    puts "#{gift[:name]} has been deleted from your list"
    # delete gift element in gift_list
    gift_list.delete_at(user_index)
    # save the gift_list in csv
    save_csv(gift_list)

  when "mark"
    puts "\n"
    list(gift_list)
    # ask user for index to mark
    puts "Which item have you bought (give the index)"
    print "> "
    # retrieve index
    user_index = gets.chomp.to_i - 1
    # grab the right gift in gift_list and toggle its value
    gift = gift_list[user_index]
    gift[:bought] = !gift[:bought] 
    status = gift[:bought] ? "bought" : "pending"
    puts "\n"
    puts "#{gift[:name]} has been marked as #{status}"
    # save gift_list in csv
    save_csv(gift_list)

  when "idea"
    puts "\n"
    puts "What are you looking for on Etsy?"
    print "> "
    keyword = gets.chomp
    # call the scrape etsy method with keyword
    etsy_results = scrape_etsy(keyword)
    # display results from etsy
    puts "\n"
    puts "Here are Etsy results for '#{keyword}':"
    list(etsy_results)
    # ask the user which item to add
    puts "Pick one to add to your list (give the number)"
    print "> "
    # retrieve index
    user_index = gets.chomp.to_i - 1
    # grab the item in Etsy results
    gift = etsy_results[user_index]
    # add the gift to gift_list
    gift_list << gift

    puts "\n"
    puts "#{gift[:name]} has been added to your list"
    # save the gift_list in the CSV
    save_csv(gift_list)

  when "quit"
    puts "\n"
    puts "Goodbye"
    puts "\n"

  else
    puts "I don't know what you mean"
  end
end

