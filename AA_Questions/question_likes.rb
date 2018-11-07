class QuestionLikes
  def self.find_by_id(id)
    query = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      id = ?
    SQL
    QuestionLikes.new(query.first)
  end
  
  def self.find_by_user(user_id)
    queries = QuestionDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      user_id = ?
    SQL
    
    result = []
    queries.each { |query| result << QuestionLikes.new(query) }
    
    result
  end
  
  def self.find_by_question(question_id)
    queries = QuestionDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_id = ?
    SQL
    
    result = []
    queries.each { |query| result << QuestionLikes.new(query) }
    
    result
  end
  
  attr_accessor :question_id, :user_id
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
  def create
    raise "#{self} is aready in DB" if @id
    
    QuestionDatabase.instance.execute(<<-SQL, @question_id, @user_id)
    INSERT INTO
      question_likes (question_id, user_id)
    VALUES
      (?, ?)
    SQL
    @id = QuestionDatabase.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in database" unless @id
    
    QuestionDatabase.instance.execute(<<-SQL, @question_id, @user_id, @id)
    UPDATE
      question_likes
    SET
      question_id = ?, user_id = ?
    WHERE
      id = ?
    SQL
  end
  
  
end