require 'pg'

class Database
  def self.connect
    begin
      PG.connect(
        dbname: ENV.fetch('DB_NAME', 'payroll_system'),
        user: ENV.fetch('DB_USER', 'postgres'),
        password: ENV.fetch('DB_PASSWORD', 'rubyfinals'),
        host: ENV.fetch('DB_HOST', 'localhost')
      )
    rescue PG::Error => e
      puts "❌ Database Connection Failed: #{e.message}"
      exit 1  # Stop execution if database connection fails
    end
  end

  def self.setup
    conn = connect
    begin
      conn.exec <<-SQL
        CREATE TABLE IF NOT EXISTS employees (
          id SERIAL PRIMARY KEY,
          name TEXT NOT NULL,
          date_hired DATE NOT NULL,
          department TEXT NOT NULL,
          position TEXT NOT NULL,
          designation TEXT NOT NULL,
          status TEXT NOT NULL,
          hours_worked NUMERIC(10,2) NOT NULL CHECK (hours_worked >= 0),
          rate_per_hour NUMERIC(10,2) NOT NULL CHECK (rate_per_hour >= 0),
          deductions NUMERIC(10,2) NOT NULL CHECK (deductions >= 0)
        );
      SQL
      puts "✅ Database setup complete."
    rescue PG::Error => e
      puts "❌ Error in database setup: #{e.message}"
    ensure
      conn.close
    end
  end
end

Database.setup  # Create the table when the script runs
