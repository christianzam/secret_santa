class IdeasView
  def display(ideas)
    ideas.each_with_index do |gift, index|
      # condition ? code if true : code if false
      status = gift.bought ? "[x]" : "[ ]"
      puts "#{index + 1} - #{status} #{gift.name} average price £#{gift.price}"
    end
  end

  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end
end
