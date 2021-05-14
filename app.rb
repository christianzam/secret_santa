
require_relative "./repositories/idea_repository"
require_relative "./controllers/ideas_controller"

require_relative "./repositories/meal_repository"
require_relative "./controllers/meals_controller"
require_relative "./repositories/customer_repository"
require_relative "./controllers/customers_controller"
require_relative "./repositories/user_repository"
require_relative "./controllers/sessions_controller"
require_relative "./repositories/order_repository"
require_relative "./controllers/orders_controller"
require_relative "router"

GIFTS_CSV_FILE = File.join(__dir__, "data/gifts.csv")
IDEAS_CSV_FILE = File.join(__dir__, "data/ideas.csv")
CUSTOMERS_CSV_FILE = File.join(__dir__, "data/customers.csv")
USERS_CSV_FILE = File.join(__dir__, "data/users.csv")
ORDERS_CSV_FILE = File.join(__dir__, "data/orders.csv")

idea_repository = IdeaRepository.new(IDEAS_CSV_FILE)
ideas_controller = IdeasController.new(idea_repository)

meal_repository = MealRepository.new(GIFTS_CSV_FILE)
meals_controller = MealsController.new(meal_repository)

customer_repository = CustomerRepository.new(CUSTOMERS_CSV_FILE)
customers_controller = CustomersController.new(customer_repository)

user_repository = UserRepository.new(USERS_CSV_FILE)
sessions_controller = SessionsController.new(user_repository)

order_repository = OrderRepository.new(ORDERS_CSV_FILE, meal_repository, customer_repository, user_repository, idea_repository)
orders_controller = OrdersController.new(meal_repository, customer_repository, user_repository, order_repository, idea_repository)

router = Router.new(meals_controller, customers_controller, sessions_controller, orders_controller, ideas_controller)
router.run
