require "mysql2"

def cleaning(client)
  client.query("select id, lastname, email, email2 from people_luiz;").each do |hash|
    lastname = hash['lastname'].to_s.count("editted") > 0 ? lastname = hash['lastname'].to_s.delete("editted ") : lastname = "#{hash['lastname'].to_s} editted"
    email = hash['email'].downcase.gsub("'", "")
    email2 = hash['email2'].downcase.gsub("'", "")
    
    client.query("UPDATE people_luiz SET lastname='#{lastname}', email='#{email}', email2='#{email2}' WHERE id = #{hash['id']};")
  end
end



client = Mysql2::Client.new(:host =>"127.0.0.1", 
                        :username => "luizz",
                        :password => "luiz",
                        :database => "class")

cleaning(client)
client.close
