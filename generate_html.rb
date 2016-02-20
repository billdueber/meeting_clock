require 'slim'
require 'awesome_print'


class Person

  WEEKS_PER_YEAR = 52
  RAW_WORKDAYS_PER_YEAR = WEEKS_PER_YEAR * 5

  # https://hr.umich.edu/working-u-m/my-employment/u-m-holidays-season-days
  HOLIDAYS = 11
  VACATION_DAYS = 24

  ACTUAL_WORKDAYS_PER_YEAR = RAW_WORKDAYS_PER_YEAR - HOLIDAYS - VACATION_DAYS
  SECONDS_PER_WORKDAY = 8 * 3600 # eight hours
  WORK_SECONDS_PER_YEAR = ACTUAL_WORKDAYS_PER_YEAR * SECONDS_PER_WORKDAY



  attr_accessor :name, :second_salary, :dept
  def initialize(name, salary, dept)
    @name = name
    @second_salary = raw_salary_to_dollars_per_second(salary)
    @dept = dept
  end

  def raw_salary_to_dollars_per_second(annual_salary)
    Float(annual_salary) / WORK_SECONDS_PER_YEAR
  end
end

data = {}
File.open('salaries.tsv').each do |line|
  (name, salary, dept) = line.chomp.split(/\t/).map(&:strip)
  dept = dept.strip.gsub('Library Info Tech - ', '')
  data[dept] ||= []
  data[dept] << Person.new(name, salary, dept)
end
data.values.each {|x| x.sort! {|a,b| a.name <=> b.name}}

template = Slim::Template.new('meeting_clock.html.slim')
puts template.render(Object.new, data: data)
