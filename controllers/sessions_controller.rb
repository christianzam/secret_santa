require_relative "../views/sessions_view"

class SessionsController
  def initialize(user_repository)
    @sessions_view = SessionsView.new
    @user_repository = user_repository
  end

  def login
    puts ""
    username = @sessions_view.ask_for(:username)
    password = @sessions_view.ask_user_password
    user = @user_repository.find_by_username(username)
    if user && user.password == password
      @sessions_view.success(user)
      return user
    else
      puts ""
      @sessions_view.print_wrong_credentials
      return login
    end
  end
end
