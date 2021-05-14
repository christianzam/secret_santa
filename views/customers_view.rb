class CustomersView
  def display(customers)
    customers.each_with_index do |customer, index|
      puts "\n #{index + 1}. #{customer.name}"
      puts " "*2 + "  Birthday: #{customer.birthday}"
      puts " "*2 + "  Notes:  #{customer.notes}"
    end
  end

  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end
end