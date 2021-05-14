require_relative "../views/ideas_view"
require_relative "../views/meals_view"
require_relative "../views/customers_view"
require_relative "../views/sessions_view"
require_relative "../views/orders_view"

class OrdersController
  def initialize(meal_repo, customer_repo, user_repo, order_repo, idea_repo)
    @meal_repo = meal_repo
    @customer_repo = customer_repo
    @user_repo = user_repo
    @order_repo = order_repo
    @idea_repo = idea_repo
    @meals_view = MealsView.new
    @customers_view = CustomersView.new
    @sessions_view = SessionsView.new
    @orders_view = OrdersView.new
    @ideas_view = IdeasView.new
  end

  def add
    meal = select_meal
    customer = select_customer
    user = select_user
    order = Order.new(meal: meal, customer: customer, user: user)
    @order_repo.create(order)
  end

  def list_undelivered_orders
    undelivered_orders = @order_repo.undelivered_orders
    @orders_view.display(undelivered_orders)
  end

  def list_my_orders(current_user)
    list_my_undelivered_orders(current_user)
  end

  def mark_as_delivered(current_user)
    list_my_undelivered_orders(current_user)
    index = @orders_view.ask_user_for_index
    my_orders = @order_repo.my_undelivered_orders(current_user)
    order = my_orders[index]
    @order_repo.mark_as_delivered(order)
  end

  private

  def select_meal
    meals = @meal_repo.all
    @meals_view.display(meals)
    puts ""
    puts "Choose a gift from your list...."
    index = @orders_view.ask_user_for_index
    return meals[index]
  end

  def select_customer
    customers = @customer_repo.all
    # meals = @meal_repo.all #######
    # index_meal = @orders_view.ask_user_for_index ######
    puts " "
    puts "Who is receiving that gift"
    @customers_view.display(customers)
    index = @orders_view.ask_user_for_index
    return customers[index]
  end

  def select_user
    users = @user_repo.all_users
    puts " "
    puts "Who is giving that gift"
    @sessions_view.display(users)
    index = @orders_view.ask_user_for_index
    return users[index]
  end

  def list_my_undelivered_orders(user)
    orders = @order_repo.my_undelivered_orders(user)
    @orders_view.display(orders)
  end
end
