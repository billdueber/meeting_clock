# LIT Salary URLs

require 'nokogiri'
require 'open-uri'

urls = %w[
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+Core+Svcs&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+DLPS&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+DSS&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+General&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+Lib+Sys&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+Web+Sys&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech-+LTIG&Year=0&Campus=1
]





def get_url(url)
  getem(open(url).read)
end

def getem(fh)
  doc = Nokogiri::HTML(fh.read)
  salary_table =  doc.css('table.index')
  salary_table.css('tr').each do |row|
    first_cell = row.css('td').first
    next unless first_cell # must be a header
    next if first_cell.css('a').empty?
    name = first_cell.css('a').text.strip.gsub(/ ,/, ', ')
    raw_salary = row.css('td')[-2].text.strip
    salary = raw_salary.gsub(/[^\d\.]/, '').to_f
    dept = row.css('td')[2].text.gsub(/Library\s*Info\s*Tech\s*\-\s*/, '')
    puts [name, salary.to_s, dept].join("\t")
  end
end


u1 = "http://www.umsalary.info/deptsearch.php?Dept=Library+Info%25&Year=0&Campus=1"
u2 = "http://www.umsalary.info/deptsearch.php?Dept=LibraryInfo%25&Year=0&Campus=1"
u3 = "http://www.umsalary.info/deptsearch.php?Dept=Library+Dean+-+General&Year=0&Campus=1"
getem open(u1)
getem open(u2)
getem open(u3)

