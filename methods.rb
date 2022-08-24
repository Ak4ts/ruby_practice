def get_subject_teacher(id, client)
  q = "select s.name subject, t.* from subjects_luiz s JOIN teachers_luiz t ON s.id = t.subject_id where s.id = #{id};"
  data = client.query(q).to_a
  if data.length != 0
    output = "Subject: #{data[0]['subject']}\nTeachers:"
    data.each do |teacher|
      output+="\n#{teacher['first_name']} #{teacher['middle_name'][0]}. #{teacher['last_name']}"
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