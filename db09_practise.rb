require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'], database: "applicant_tests")

# puts get_subject_teacher('2', client)
# puts get_class_subjects('Crases', client)
# puts get_teachers_list_by_letter('a', client)

# set_md5(client)
# puts get_class_info(2, client)
# puts get_teachers_by_year(2000, client)

# puts random_date("1000-20-30", "1500-10-20")
# puts random_last_names(10, client)
# puts random_first_names(10, client)

client.close