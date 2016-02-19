require 'slim'
require 'awesome_print'

Person = Struct.new(:name, :salary, :dept) do
  def minute_salary 
    self.salary.to_f / (2000 * 60)
  end
end
    
data = {}
File.open('salaries.tsv').each do |line|
  (name, salary, dept) = line.chomp.split(/\t/).map(&:strip)
  data[dept] ||= []
  data[dept] << Person.new(name, salary, dept)
end
data.values.each {|x| x.sort! {|a,b| a.name <=> b.name}}

template = Slim::Template.new('meeting_clock.html.slim')
puts template.render(Object.new, data: data)
  