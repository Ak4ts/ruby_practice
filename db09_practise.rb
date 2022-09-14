require 'mysql2'
require 'dotenv/load'
require_relative 'methods.rb'
require_relative 'cleaning.rb'
require_relative 'scraping.rb'

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

# t = Time.now
# 1.times do
#   puts t
#   generating_random_people(client)
#   puts "Done!!"
# end
# puts Time.now - t

# cleaning_montana_district_report_card(client)

# hle_dev_test_candidates(client)

scraping('https://www.cdc.gov/coronavirus/2019-ncov/covid-data/covidview/01152021/specimens-tested.html', client)

client.close