
class Replies
  def self.find_by_id(id)
    query = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL
    Replies.new(query.first)
  end
  
  def self.find_by_user(user_id)
    queries = QuestionDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
    
    result = []
    queries.each { |query| result << Replies.new(query) }
    
    result
  end
  
  def self.find_by_question(question_id)
    queries = QuestionDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    
    result = []
    queries.each { |query| result << Replies.new(query) }
    
    result
  end
  
  attr_accessor :question_id, :user_id, :parent_id, :body
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
  
  def create
    raise "#{self} is aready in DB" if @id
    
    QuestionDatabase.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body)
    INSERT INTO
      replies (question_id, parent_id, user_id, body)
    VALUES
      (?, ?, ?, ?)
    SQL
    @id = QuestionDatabase.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in database" unless @id
    
    QuestionDatabase.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body, @id)
    UPDATE
      replies
    SET
      question_id = ?, parent_id = ?, user_id = ?, body = ?
    WHERE
      id = ?
    SQL
  end
  
  def author
    queries = QuestionDatabase.instance.execute(<<-SQL, @user_id)
    SELECT
      *
    FROM
      user
    WHERE
      user.id = ?
    SQL
    
    Users.new(queries.first)
  end
  
  def question
    queries = QuestionDatabase.instance.execute(<<-SQL, @question_id)
    SELECT
      *
    FROM
      question
    WHERE
      question.id = ?
    SQL
    
    Question.new(queries.first)
  end
  
  def parent_reply
    queries = QuestionDatabase.instance.execute(<<-SQL, @parent_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.id = ?
    SQL
    
    Replies.new(queries.first)
  end
  
  def child_reply
    queries = QuestionDatabase.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.parent_id = ?
    SQL
    
    result = []
    queries.each { |query| result << Replies.new(query) }
    
    result
  end
  
  
end