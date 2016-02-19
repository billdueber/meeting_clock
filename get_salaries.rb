# LIT Salary URLs

require 'nokogiri'
require 'httpclient'

urls = %w[
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+Core+Svcs&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+DLPS&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+DSS&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+General&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+Lib+Sys&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech+-+Web+Sys&Year=0&Campus=1
http://www.umsalary.info/deptsearch.php?Dept=Library+Info+Tech-+LTIG&Year=0&Campus=1
]


def getem(url)
  doc = Nokogiri::HTML(HTTPClient.new.get_content(url))
  salary_table =  doc.css('table')[2]
  salary_table.css('tr').each do |row|
    first_cell = row.css('td').first
    next unless first_cell # must be a header
    next if first_cell.css('a').empty?
    name = first_cell.css('a').text.strip
    raw_salary = row.css('td')[-2].text.strip
    salary = raw_salary.gsub(/[^\d\.]/, '').to_f
    puts [name, salary.to_s, row.css('td')[-3].text.strip].join("\t")
  end
end

urls.each do |url|
  getem(url)
end