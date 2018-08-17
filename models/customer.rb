require_relative('../db/sql_runner.rb')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(info)
    @id = info['id'].to_i if info['id']
    @name = info['name']
    @funds = info['funds'].to_i
  end

  def save
    sql = "INSERT INTO customers
    (name, funds)
    VALUES
    ($1, $2)
    RETURNING *"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE customers
    SET title = $1, genre = $2
    WHERE id = $3 "
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)

  end

  def delete()
    sql = "DELETE FROM customers
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # def movies()
  #   sql = "SELECT films.* FROM films
  #   INNER JOIN tickets
  #   ON films.id = tickets.film_id
  #   WHERE customer_id = $1"
  #   values = [@id]
  #   result = SqlRunner.run(sql, values)
  #   return Movie.map_items(result)
  # end

  def self.map_items(customer_data)
    customer_data.map { |customer| Customer.new(customer)  }
  end

  def self.all
    sql = "SELECT * FROM customers"
    result = SqlRunner.run(sql)
    return self.map_items(result)
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM customers
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    if result.count > 0
      Customer.map_items(result)
    else
      return nil
    end
  end

end
