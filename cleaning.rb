def cleaning_montana_district_report_card(client)
  begin
    q = "CREATE TABLE montana_public_district_report_card__uniq_dist_luiz (
      id INT PRIMARY KEY AUTO_INCREMENT,
      name VARCHAR(255), 
      clean_name VARCHAR(255), 
      address VARCHAR(255), 
      city VARCHAR(255), 
      state VARCHAR(255), 
      zip VARCHAR(255));"
    client.query(q)
  rescue => exception
    q = " INSERT INTO montana_public_district_report_card__uniq_dist_luiz (name, address, city, state, zip)
        select distinct school_name, address, city, state, zip from montana_public_district_report_card"
    client.query(q)

    toUpdate = client.query("SELECT * FROM montana_public_district_report_card__uniq_dist_luiz").to_a
    toUpdate.each do |district|
      name = district['name'].
        gsub(' Elem', ' Elementary School').
        gsub(' H S', ' High School').
        gsub(' K-12 Schools', ' Public School').
        gsub(' K-12', ' Public School') + " District"
      client.query("UPDATE montana_public_district_report_card__uniq_dist_luiz SET clean_name = '#{name}' WHERE id=#{district['id']}")
    end
  else
    q = " INSERT INTO montana_public_district_report_card__uniq_dist_luiz (name, address, city, state, zip)
        select distinct school_name, address, city, state, zip from montana_public_district_report_card"
    client.query(q)

    toUpdate = client.query("SELECT * FROM montana_public_district_report_card__uniq_dist_luiz").to_a
    toUpdate.each do |district|
      name = district['name'].
        gsub(' Elem', ' Elementary School').
        gsub(' H S', ' High School').
        gsub(' K-12 Schools', ' Public School').
        gsub(' K-12', ' Public School') + " District"
      client.query("UPDATE montana_public_district_report_card__uniq_dist_luiz SET clean_name = '#{name}' WHERE id=#{district['id']}")
    end
  end
end