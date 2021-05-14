require_relative "../views/customers_view"
require_relative "../models/customer"

class CustomersController
  def initialize(customer_repository)
    @customer_repository = customer_repository
    @customers_view = CustomersView.new
  end

  def add
    name = @customers_view.ask_user_for(:name)
    birthday = @customers_view.ask_user_for(:birthday)
    notes = @customers_view.ask_user_for(:notes)
    customer = Customer.new(name: name, birthday: birthday, notes: notes)
    @customer_repository.create(customer)
    display_customers
  end

  def list
    display_customers
  end

  private

  def display_customers
    customers = @customer_repository.all
    @customers_view.display(customers)
  end
end
