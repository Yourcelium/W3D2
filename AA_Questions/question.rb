
class Question
  
  def self.find_by_id(id)
    query = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM 
      questions
    WHERE
      id = ?
    SQL
    Question.new(query.first)
  end
  
  attr_accessor :title, :body, :author_id
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def create
    raise "#{self} already in database" if @id
    QuestionDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
    INSERT INTO
      questions (title, body, author_id)
    VALUES
        (?, ?, ?)
    SQL
    @id = QuestionDatabase.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in database" unless @id
    QuestionDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
    UPDATE
      questions
    SET
      title = ?, body = ?, author_id = ?
    WHERE
      id = ?
    SQL
  end
  
  
  def self.find_by_author_id(author_id)
    queries = QuestionDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM 
      questions
    WHERE
      author_id = ?
    SQL
    results = []
    queries.each {|query| results << Question.new(query)}
    results
  end
  
  def author
    queries = QuestionDatabase.instance.execute(<<-SQL, author_id)
    SELECT 
      *
    FROM 
      user
    WHERE
      user.id = ?
    SQL
    Users.new(queries.first)
  end
  
  def replies
    Replies::find_by_question(@id)
  end
  
end
