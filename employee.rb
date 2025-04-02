require_relative 'database'

class Employee
  attr_accessor :id, :name, :date_hired, :department, :position, :designation, :status, :hours_worked, :rate_per_hour, :deductions

  def initialize(id, name, date_hired, department, position, designation, status, hours_worked, rate_per_hour, deductions)
    @id = id
    @name = name
    @date_hired = date_hired
    @department = department
    @position = position
    @designation = designation
    @status = status
    @hours_worked = [hours_worked.to_f, 0].max  # Ensures non-negative hours
    @rate_per_hour = [rate_per_hour.to_f, 0].max  # Ensures non-negative rate
    @deductions = [deductions.to_f, 0].max  # Ensures non-negative deductions
  end

  def calculate_salary
    regular_hours = [@hours_worked, 40].min
    overtime_hours = [@hours_worked - 40, 0].max
    regular_pay = regular_hours * @rate_per_hour
    overtime_pay = overtime_hours * (@rate_per_hour * 1.5)  # 1.5x for OT
    gross_salary = regular_pay + overtime_pay
    net_salary = [gross_salary - @deductions, 0].max  # Ensures non-negative net salary

    { 
      regular_pay: regular_pay.round(2), 
      overtime_pay: overtime_pay.round(2), 
      gross_salary: gross_salary.round(2),
      deductions: @deductions.round(2),
      net_salary: net_salary.round(2)
    }
  end

  def display_info
    salary = calculate_salary
    puts "\n==========================="
    puts "   Employee Payroll System"
    puts "===========================\n"
    puts "Employee ID: #{@id}"
    puts "Name: #{@name}"
    puts "Date Hired: #{@date_hired}"
    puts "Department: #{@department}"
    puts "Position: #{@position}"
    puts "Designation: #{@designation}"
    puts "Status: #{@status}"
    puts "Hours Worked: #{@hours_worked}"
    puts "Rate per Hour: PHP #{@rate_per_hour}"
    puts "Regular Pay: PHP #{salary[:regular_pay]}"
    puts "Overtime Pay: PHP #{salary[:overtime_pay]}"
    puts "Gross Salary: PHP #{salary[:gross_salary]}"
    puts "Deductions: PHP #{salary[:deductions]}"
    puts "Net Salary: PHP #{salary[:net_salary]}"
    puts "===========================\n"
  end
end
