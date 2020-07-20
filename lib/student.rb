require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
attr_accessor :name, :grade, :id

def initialize(id = nil, name, grade)
  @name, @grade, @id = name, grade, id
end

def self.create_table 
  sql =  <<-SQL 
  CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY, 
    name TEXT, 
    grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
end

def self.drop_table
  sql =  <<-SQL 
 DROP TABLE STUDENTS
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
    end
  end

  def self.create(name, grade)
     student = Student.new(name, grade)
     student.save
     student
  end

  def self.new_from_db(row)
    student_new = self.new(row[0], row[1], row[2])
    student_new
  end

  def self.find_by_name(name)
    sql = <<-SQL
          SELECT * FROM students
          WHERE name = ?
    SQL
    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
   end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
  
