require "csv"
require_relative "../models/user"

class UserRepository
  def initialize(csv_file)
    @csv_file = csv_file
    @users = []
    load_csv if File.exist?(@csv_file)
  end

  def all_users
    @users.select { |user| user.user? }
  end

  def find(id)
    @users.find { |user| user.id == id }
  end

  def find_by_username(username)
    @users.find { |user| user.username == username }
  end
 
  private

  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
    CSV.foreach(@csv_file, csv_options) do |row|
      row[:id] = row[:id].to_i
      @users << User.new(row)
    end
  end
end
