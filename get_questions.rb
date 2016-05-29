require 'csv'
require 'net/http'
require 'json'

puts "Enter name of file"
file = gets.chomp

f = CSV.open(file,"w+")

c_id = [2,780,7,105,4]
v = [100,200,300,400,500]

c_id.each do |id|
	v.each do |value|
		url = "http://jservice.io/api/clues?value=#{value}&category=#{id}"
		uri = URI(url)
		resp = Net::HTTP.get(uri)
		p = JSON.parse resp
		f.add_row([p[0]['answer'],p[0]['question'], value, p[0]["category"]["title"]])
	end
end
f.close