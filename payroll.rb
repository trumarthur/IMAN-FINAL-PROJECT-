require_relative 'database'
require_relative 'employee'

class PayrollSystem
  def initialize
    @conn = Database.connect
  end

  def add_employee
    print "Enter Employee ID: "
    id = gets.chomp.to_i
  
    # Check if ID already exists
    result = @conn.exec_params("SELECT id FROM employees WHERE id = $1", [id])
    if result.ntuples > 0
      puts "Error: Employee ID already exists! Please enter a unique ID."
      return
    end
  
    print "Enter Name: "
    name = gets.chomp
    print "Enter Date Hired (YYYY-MM-DD): "
    date_hired = gets.chomp
    print "Enter Department: "
    department = gets.chomp
    print "Enter Position: "
    position = gets.chomp
    print "Enter Designation: "
    designation = gets.chomp
    print "Enter Status (Full-Time/Part-Time): "
    status = gets.chomp
    print "Enter Hours Worked: "
    hours_worked = gets.chomp.to_f
    print "Enter Rate per Hour: "
    rate_per_hour = gets.chomp.to_f
    print "Enter Deductions: "
    deductions = gets.chomp.to_f
  
    # Insert employee with manually entered ID
    @conn.exec_params(
      "INSERT INTO employees (id, name, date_hired, department, position, designation, status, hours_worked, rate_per_hour, deductions) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
      [id, name, date_hired, department, position, designation, status, hours_worked, rate_per_hour, deductions]
    )
  
    puts "Employee added successfully with ID: #{id}"
  end
  
  def edit_employee
    print "Enter Employee ID to edit: "
    id = gets.chomp.to_i

    result = @conn.exec_params("SELECT * FROM employees WHERE id = $1", [id])
    return puts "Error: Employee not found!" if result.ntuples.zero?

    emp = result[0]

    print "Enter new Hours Worked (leave blank to keep current: #{emp['hours_worked']}): "
    new_hours = gets.chomp
    new_hours = new_hours.empty? ? emp['hours_worked'].to_f : new_hours.to_f

    print "Enter new Rate per Hour (leave blank to keep current: #{emp['rate_per_hour']}): "
    new_rate = gets.chomp
    new_rate = new_rate.empty? ? emp['rate_per_hour'].to_f : new_rate.to_f

    print "Enter new Deductions (leave blank to keep current: #{emp['deductions']}): "
    new_deductions = gets.chomp
    new_deductions = new_deductions.empty? ? emp['deductions'].to_f : new_deductions.to_f

    @conn.exec_params("UPDATE employees SET hours_worked = $1, rate_per_hour = $2, deductions = $3 WHERE id = $4",
                      [new_hours, new_rate, new_deductions, id])

    puts "Employee updated successfully!"
  end

  def delete_employee
    print "Enter Employee ID to delete: "
    id = gets.chomp.to_i

    result = @conn.exec_params("DELETE FROM employees WHERE id = $1", [id])
    puts result.cmd_tuples.zero? ? "Error: Employee not found!" : "Employee deleted successfully!"
  end

  def display_employee
    print "Enter Employee ID: "
    id = gets.chomp.to_i

    result = @conn.exec_params("SELECT * FROM employees WHERE id = $1", [id])
    return puts "Error: Employee not found!" if result.ntuples.zero?

    emp = Employee.new(*result[0].values)
    emp.display_info
  end

  def menu
    loop do
      puts "\n1. Add Employee\n2. Edit Employee\n3. Delete Employee\n4. View Employee\n5. Exit"
      print "Enter choice: "
      case gets.chomp
      when "1" then add_employee
      when "2" then edit_employee
      when "3" then delete_employee
      when "4" then display_employee
      when "5" then break
      else puts "Invalid choice!"
      end
    end
  end
end

PayrollSystem.new.menu
