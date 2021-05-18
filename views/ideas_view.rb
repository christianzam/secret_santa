class IdeasView
  def display(ideas)
    ideas.each_with_index do |gift, index|
      ideas.delete_if { |present| present.price.zero? || present.name.empty? }
      status = gift.bought ? "\u{2705}" : "\u{2b1c}"
      puts "#{index + 1} - #{status} #{gift.name} average price £#{gift.price.to_f.round(2)}"
    end
  end

  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    gets.chomp
  end
end
