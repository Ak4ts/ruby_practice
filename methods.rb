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


def random_date(date_begin, date_end)
  db = date_begin.split("-")
  de = date_end.split("-")
  year = rand(db[0].to_i..de[0].to_i)
  month = rand(1..12)
  day = rand(1..31)
  if month == 2
    while day >28 
      day-=1 
    end
  elsif month == 4 or month == 6 or month == 9 or month == 11 
    while day >30 
      day-=1 
    end
  end
  puts rand(db[1].to_i..de[1].to_i)
  str = "#{year}-#{month}-#{day}"
end

def random_last_names(n, client)
  q = "SELECT last_name FROM last_names ORDER BY RAND() LIMIT #{n}"
  lastnames = client.query(q).to_a
end

def random_first_names(n, client)
  q = "SELECT m.FirstName as males, f.names as females 
  FROM male_names m 
  JOIN female_names f
  ORDER BY RAND() 
  LIMIT #{n}"
  names = client.query(q).to_a
end
