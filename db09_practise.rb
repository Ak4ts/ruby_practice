require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'], database: "applicant_tests")

puts get_subject_teacher('2', client)
puts get_class_subjects('Crases', client)
puts get_teachers_list_by_letter('a', client)

client.close