require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

 def initialize(name:, grade:, id: nil)
   @id = id
   @name = name
   @grade = grade
 end

 def self.create_table
   sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
  SQL

  DB[:conn].execute(sql)
 end

 def self.drop_table
   sql = <<-SQL
    DROP TABLE IF EXISTS students
  SQL

  DB[:conn].execute(sql)
 end

 def save
  if self.id
    self.update
  else
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
  SQL

  DB[:conn].execute(sql, self.name, self.grade)

  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

  self
  end
  
 end

 def self.create(name:, grade:)
   student = Student.new(name: name, grade: grade)
   student.save
 end

 def self.new_from_db(row)
   self.new(id: row[0], name: row[1], grade: row[2])
 end

 def self.all
   sql = <<-SQL
    SELECT *
    FROM students
  SQL

  DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
  end
 end

 def self.find_by_name(name)
  sql = <<-SQL
  SELECT *
  FROM songs
  WHERE name = ?
  LIMIT 1
SQL

DB[:conn].execute(sql, name).map do |row|
  self.new_from_db(row)
end.first
 end


end
