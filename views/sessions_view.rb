# require 'io/console'
# password = STDIN.noecho(&:gets).chomp
require 'highline'

class SessionsView
  def ask_for(stuff)
    puts "#{stuff}?"
    print "> "
    return gets.chomp
  end

  def ask_user_password
    cli = HighLine.new
    pass = cli.ask("Enter your password:  ") { |q| q.echo = "*" }
  end

  def print_wrong_credentials
    puts "Wrong credentials... /n Please try again"
  end

  def success(user)
    if user.admin?
      puts "\n"
      puts "*" * 43
      puts "*" + " " * 41 + "*" 
      puts "*   Welcome to your Christmas list BOSS   *"
      puts "*" + " " * 41 + "*" 
      puts "*" * 43
    else
      puts "\n"
      puts "*" * 40
      puts "*" + " " * 38 + "*" 
      puts "*    Welcome to your Xmas list #{user.username.upcase}   *"
      puts "*" + " " * 38 + "*" 
      puts "*" * 40
    end
  end

  def display(users)
    users.each_with_index do |user, index|
      puts "#{index + 1}. #{user.username}"
    end
  end
end
