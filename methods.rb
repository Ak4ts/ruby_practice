require 'digest'

def get_subject_teacher(id, client)
  q = "select s.name subject, t.* from subjects_luiz s JOIN teachers_luiz t ON s.id = t.subject_id where s.id = #{id};"
  data = client.query(q).to_a
  if data.length != 0
    output = "Subject: #{data[0]['subject']}\nTeachers:"
    data.each do |teacher|
      output+="\n#{teacher['first_name']} #{teacher['middle_name']}. #{teacher['last_name']}"
    end
  else
    output="Can't find or teachers or subject."
  end
  output if output
end

def get_class_subjects(name, client)
  q = "select c.name class, concat(substring(t.first_name, 1, 1), '. ', substring(t.middle_name, 1, 1), '. ', t.last_name) teacher, s.name subject from classes_luiz c JOIN teachers_luiz t ON c.responsible_teacher_id = t.id JOIN subjects_luiz s ON t.subject_id = s.id where c.name = '#{name}';"
  data = client.query(q).to_a
  output="========================================================"
  if data.length != 0
    output += "\nClass: #{data[0]['class']}\n"
    data.each do |row|
      output+="\n#{row['subject']}, #{row['teacher']}"
    end
  else
    output+="Can't find any value."
  end
  output
end


def get_teachers_list_by_letter(l, client)
  letter = l.downcase
  output="========================================================"
  q = "select first_name, middle_name, last_name, subjects_luiz.name as subject from teachers_luiz join subjects_luiz ON teachers_luiz.subject_id = subjects_luiz.id"
  teachers = client.query(q).to_a
  teachers.each do |teacher|
    if teacher['first_name'].downcase.include?(letter) or teacher['last_name'].downcase.include?(letter)
      output += "\n#{teacher['first_name'][0,1]}. #{teacher['middle_name'][0,1]}. #{teacher['last_name']}, #{teacher['subject']}"
    end
  end
  output
end

def set_md5(client)
  q = "select id, concat(t.first_name, t.middle_name, t.last_name, t.birth_date, t.subject_id, t.current_age) as teacher from teachers_luiz t"
  teachers = client.query(q).to_a
  teachers.each do |teacher|
    md5 = Digest::MD5.hexdigest teacher['teacher']
    client.query("UPDATE teachers_luiz SET md5 = '#{md5}' WHERE id=#{teacher['id']}")
  end
end

def get_class_info(id, client)
  r = "SELECT c.name, concat(t.first_name, ' ', t.middle_name, ' ', t.last_name) as full_name, concat(t2.first_name, ' ', t2.middle_name, ' ', t2.last_name) as resp
  FROM teachers_classes_luiz tc
  JOIN teachers_luiz t 
    ON t.id=tc.teacher_id
  JOIN classes_luiz c
    ON c.id = #{id}
  JOIN teachers_luiz t2
    ON t2.id = c.responsible_teacher_id
  WHERE tc.class_id=#{id}"

  classt = client.query(r).to_a
  srt = "Class Name: #{classt[0]['name']}\nResponsible Teacher: #{classt[0]['resp']}\nInvolved teachers: "
  classt.each do |t|
    srt += "#{t['full_name']}; "
  end
  srt
end

def get_teachers_by_year(year, client)
  q = "SELECT CONCAT(t.first_name, ' ', t.middle_name, ' ', t.last_name) as full_name FROM teachers_luiz t WHERE YEAR(birth_date) = #{year}"
  teachers = client.query(q).to_a
  str = "Teachers born in #{year}: "
  teachers.each do |teacher|
    str+= "#{teacher['full_name']}; "
  end
  str
end


def random_date(begin_date, end_date)
  rand(Date.parse(date_begin)..Date.parse(date_end))
end

def random_last_names(n, client)
  lastnames = []
  q = "SELECT last_name FROM last_names ORDER BY RAND() LIMIT #{n}"
  client.query(q).each{ |l| lastnames.push l['last_name']}
  lastnames
end

def random_first_names(n, client)
  names = []
  q = "SELECT m.FirstName as names, f.names as names 
  FROM male_names m 
  JOIN female_names f
  ORDER BY RAND() 
  LIMIT #{n}"
  client.query(q).each{ |n| names.push n['names']; names.push n['names']}
  names
end

def generating_random_people(client)
  # 5,000 male names and 5,000 female names, totalizing 10,000
  fnames = random_first_names(5000, client)
  lnames = random_last_names(600, client)
  fnames.each do |fname|
    q = "INSERT INTO random_people_luiz (first_name, last_name, birth_date) VALUES ('#{fname}', '#{lnames[rand(1..600)]}', '#{rand(1920..2022)}-#{rand(1..12)}-#{rand(1..28)}') "
    client.query(q)
  end
end

def today(client)
  begin
    q = "CREATE TABLE hle_dev_test_luiz
        AS SELECT * FROM hle_dev_test_candidates;"
    client.query(q)
    q = "ALTER TABLE hle_dev_test_luiz ADD clean_name VARCHAR(255), ADD sentence VARCHAR(255)"
    client.query(q)
  rescue => exception
    puts "Table Already Exists"
    q = "SELECT * FROM hle_dev_test_luiz"
    result = client.query(q).to_a
    result.each do |candidate|
      slash = []
      id = candidate['id']
      clean_name = candidate['candidate_office_name'].gsub("County Clerk/Recorder/DeKalb County", "DeKalb County clerk and recorder").
      gsub("Twp", "Township").
      gsub("Hwy", "Highway").
      gsub(".", "").
      gsub("'", "''")

      yes = 0
      clean_name.split(" ").each do |name|
        if name.include? "/"
          obj = []
          name.split("/").each do |n|
            obj.push n
          end
          obj[0] = obj[0].downcase
          obj.reverse.each do |n|
            slash.push n
          end
        elsif name.include? ","
          yes += 1
          slash.push name.downcase
        elsif yes > 0
          slash.push name
        else
          slash.push name.downcase
        end

      end
      if( yes > 0)
        slash.push ")"
      end
      clean_name = slash.join(" ").gsub(", ", " (").gsub(" )", ")")

      sentence = "The candidate is running for the #{clean_name} office."
      q = "
        UPDATE hle_dev_test_luiz 
        SET clean_name = '#{clean_name}', sentence = '#{sentence}'
        WHERE id = #{id}
      "
      client.query(q)
    end
    puts "Done!!"
  else
    q = "SELECT * FROM hle_dev_test_luiz"
    result = client.query(q).to_a
    result.each do |candidate|
      slash = []
      id = candidate['id']
      clean_name = candidate['candidate_office_name'].gsub("County Clerk/Recorder/DeKalb County", "DeKalb County clerk and recorder").
      gsub("Twp", "Township").
      gsub("Hwy", "Highway").
      gsub(".", "").
      gsub("'", "''")

      yes = 0
      clean_name.split(" ").each do |name|
        if name.include? "/"
          obj = []
          name.split("/").each do |n|
            obj.push n
          end
          obj[0] = obj[0].downcase
          obj.reverse.each do |n|
            slash.push n
          end
        elsif name.include? ","
          yes += 1
          slash.push name.downcase
        elsif yes > 0
          slash.push name
        else
          slash.push name.downcase
        end

      end
      if( yes > 0)
        slash.push ")"
      end
      clean_name = slash.join(" ").gsub(", ", " (").gsub(" )", ")")

      sentence = "The candidate is running for the #{clean_name} office."
      q = "
        UPDATE hle_dev_test_luiz 
        SET clean_name = '#{clean_name}', sentence = '#{sentence}'
        WHERE id = #{id}
      "
      client.query(q)
    end
    puts "Done!!"
  end
end