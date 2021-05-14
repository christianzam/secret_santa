# interface.rb

# Pseudo-code:
# 1. Welcome
# 2. Display menu (list / add / delete / mark )
# 3. Get user action
# 4. Perform the right action
menu = "[list|add|delete|mark|quit]"
puts "*********************************************"
puts "===== Hello, Welcome to Xmas List App ====="
puts "*********************************************"

user_choice =""
while user_choice != "quit"
  puts ""
  puts "You can:  #{menu}"
  puts ""
  puts "What would yo like to do: "
  print "> "
  user_choice = gets.chomp.downcase
 

  case user_choice
  when "list"   then puts "list" 
  when "add"    then puts "add" 
  when "delete" then puts "delete" 
  when "mark"   then puts "mark"
  when "quit"   then puts "\n GOODBYE!!!"
  else
    puts "\n"
    puts "That's not a choice please select one of the below:"
    puts ""
  end
end
sleep(4)
print `clear` #======================