def get_teacher(id, client)
  f = "select first_name, middle_name, last_name, birth_date from teachers_luiz where ID = #{id}"
  results = client.query(f).to_a
  if results.count.zero?
    puts "Teacher with ID #{id} was not found."
  else
    puts "Teacher #{results[0]['first_name']} #{results[0]['middle_name']} #{results[0]['last_name']} was born on #{(results[0]['birth_date']).strftime("%d %b %Y (%A)")}"
  end
end

def get_subject_teacher(id, client)
  q = "select * from subjects_luiz where id = #{id}"
  r = "select * from teachers_luiz where subject_id = #{id}"
  subjects = client.query(q).to_a
  teachers = client.query(r).to_a
  if subjects.length != 0 and teachers.length != 0
    puts "Subject: #{subjects[0]['name']}"
    puts "Teachers:"
    teachers.each do |teacher|
      puts"#{teacher['first_name']} #{teacher['middle_name'][0,1]}. #{teacher['last_name']}"
    end
  else
    "Can't find or teachers or subject."
  end
end

def get_teachers_list_by_letter(l, client)
  letter = l.downcase
  q = "select first_name, middle_name, last_name, subjects_luiz.name as subject from teachers_luiz join subjects_luiz ON teachers_luiz.subject_id = subjects_luiz.id"
  teachers = client.query(q).to_a
  teachers.each do |teacher|
    if teacher['first_name'].downcase.include?(letter) or teacher['last_name'].downcase.include?(letter)
      puts "#{teacher['first_name'][0,1]}. #{teacher['middle_name'][0,1]}. #{teacher['last_name']}, #{teacher['subject']}"
    end
  end
end