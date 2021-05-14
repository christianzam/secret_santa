class Router
  def initialize(meals_controller, customers_controller, sessions_controller, orders_controller, ideas_controller)
    @meals_controller = meals_controller
    @customers_controller = customers_controller
    @sessions_controller = sessions_controller
    @orders_controller = orders_controller
    @ideas_controller = ideas_controller
    @running = true
  end

  def run
    while @running
      @current_user = @sessions_controller.login
      while @current_user
        if @current_user.admin?
          route_admin_action
        else
          route_user_action
        end
      end
      print `clear`
    end
  end

  private

  def route_admin_action
    print_admin_menu
    choice = gets.chomp.to_i
    print `clear`
    admin_action(choice)
  end

  def route_user_action
    print_user_menu
    choice = gets.chomp.to_i
    print `clear`
    user_action(choice)
  end

  def print_admin_menu
    puts "\n"
    puts "------- MENU -------"
    puts "--------------------"
    puts ""
    puts " #{@current_user.name.upcase} SELECT THE NUMBER OF THE INSTRUCTION PLEASE: "
    puts "\n"
    puts "1. SHOW all gifts in my list "
    puts "2. ADD a gift to your list"
    puts "3. ADD a person to the Secret Santa list"
    puts "4. SHOW the list of people in the Secret Santa"
    puts "5. ADD new gift exchange to your list" #GIFT
    puts "6. SHOW the list gifts exchange" #GIFT
    puts "7. Logout"
    puts "8. Exit"
    puts "9. SHOW ETSY.COM wishlist"
    puts "10. ADD IDEA FROM ETSY to your wishlist"
    puts "11. GET IDEAS FROM ETSY.COM"
    puts "12. MARK"
    print "> "
  end

  def print_user_menu
    puts "\n"
    puts "------- MENU -------"
    puts "--------------------"
    puts ""
    puts " #{@current_user.name.upcase} SELECT THE NUMBER OF THE INSTRUCTION PLEASE: "
    puts "\n"
    puts "1. SHOW my gifts to give"
    puts "2. Mark gift as bought or given"
    puts "3. Logout"
    puts "4. Exit"
    print "> "
  end

  def admin_action(choice)
    case choice
    when 1 then @meals_controller.list
    when 2 then @meals_controller.add
    when 3 then @customers_controller.add
    when 4 then @customers_controller.list
    when 5 then @orders_controller.add #GIFTS
    when 6 then @orders_controller.list_undelivered_orders #GIFTS
    when 7 then logout!
    when 8 then stop!
    when 9 then @ideas_controller.list_ideas
    when 10 then @ideas_controller.add_idea
    when 11 then @ideas_controller.print_etsy_ideas
    when 12 then @ideas_controller.mark
    else puts "That's an incorrect number..... /n/n please Try again..."
    end
  end

  def user_action(choice)
    case choice
    when 1 then @orders_controller.list_my_orders(@current_user)
    when 2 then @orders_controller.mark_as_delivered(@current_user)
    when 3 then logout!
    when 4 then stop!
    else puts "That's an incorrect number..... /n/n please Try again..."
    end
  end

  def logout!
    sleep(1)
    @current_user = nil
  end

  def stop!
    puts "See ya later.... #{@current_user.name.capitalize}"
    puts "Have a nice one!"
    sleep(1)
    logout!
    @running = false
  end
end
