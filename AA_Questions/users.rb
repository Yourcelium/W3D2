
class Users
  def self.find_by_id(id)
    query = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM
        user
      WHERE
        id = ?
      SQL
    Users.new(query.first)
  end
  
  def self.find_by_name(fname, lname)
    queries = QuestionDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      user
    WHERE
      fname = ?
      AND lname = ?
    SQL
    
    result = []
    queries.each { |query| result << Replies.new(query) }
    
    result
    
  end

  
  attr_accessor :fname, :lname, :id
  
  def initialize(options)
    @fname = options['fname']
    @lname = options['lname']
    @id = options['id']
  end
  
  def create
    raise "#{self} already in database" if @id
    
    QuestionDatabase.instance.execute(<<-SQL, @fname, @lname)
    INSERT INTO
      user (fname, lname)
    VALUES
      (?, ?)
    SQL
    @id = QuestionDatabase.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in database" unless @id
    QuestionDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    UPDATE
      user
    SET
      fname = ?, lname = ?
    WHERE
      id = ?
    SQL
  end

  
  def authored_questions
    raise "#{self} not yet in database" unless @id
    Question::find_by_author_id(@id)
  end
  
  def authored_replies
    raise "#{self} not yet in database" unless @id
    Replies::find_by_user(@id)
  end
end