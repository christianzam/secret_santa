class User
  attr_accessor :id
  attr_reader :username, :password, :role

  def initialize(attributes = {})
    @id = attributes[:id]
    @username = attributes[:username]
    @password = attributes[:password]
    @role = attributes[:role]
  end

  def admin?
    @role == "admin"
  end

  def user?
    @role == "user"
  end

  def name
    @username
  end
end
