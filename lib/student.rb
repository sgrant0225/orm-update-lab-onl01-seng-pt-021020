require_relative "../config/environment.rb"
require 'pry'

class Student
 attr_accessor :name, :grade
 attr_reader :id
 
 def initialize(id=nil, name, grade)
   @id = id
   @name = name 
   @grade = grade
 end   
 
 def self.create_table
  sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students (
  id INTEGER PRIMARY KEY,
  name TEXT,
  grade INTEGER
  )
  SQL
  DB[:conn].execute(sql)
 end
 
 def self.drop_table
  sql = <<-SQL
  DROP TABLE students;
  SQL
  DB[:conn].execute(sql)
 end 
  
  def save #inserts a new row ino the db using the attibutes of the given onject
    if self.id
       self.update
    else
    sql = <<-SQL 
    INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
   # binding.pry
    end
  end  
  
  def self.create(name, grade)
     students = Student.new(name, grade)
     students.save
     students
  end 
  
  def self.new_from_db(row) #use this method to create all the Ruby objects.
    new_students = Student.new
    new_students.id = row[0]
    new_students.name = row[1]
    new_students.grade = row[2]
    new_students
  end  
   
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
