require 'rubygems'
require File.expand_path(File.dirname(__FILE__) + '/app/models/navigators/beco')

nav = Beco::Navigator.new

party_navs = nav.navigate_to_parties
puts "parties: #{party_navs.size}"

#party_navs.each do |party_nav|

party_nav = party_navs.first

  puts '=== PARTY ==='
  puts "NAME: #{party_nav.find_name}"

  list_nav = party_nav.navigate_to_list
  puts "LIST: #{!list_nav.nil?}"

  if(list_nav) then
    list_nav.fill_name 'Jairo Souza'
    list_nav.fill_email 'jjjsouza777@gmail.com'
    list_nav.fill_friends ['Gilda Mattos']
    response_nav = list_nav.submit

    puts "RESPONSE CODE: #{response_nav.code}"
    puts "RESPONSE MESS: #{response_nav.find_message}"
  end
#end

puts 'cabou.'

