
class QuestionFollows
  def self.find_by_id(id)
    query = QuestionDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      id = ?
    SQL
    QuestionFollows.new(query.first)
  end
  
  def self.followers_for_question(questions_id)
    users = QuestionDatabase.instance.execute(<<-SQL, questions_id)
    SELECT DISTINCT
      user.*
    FROM
      question_follows
    JOIN user
      ON question_follows.user_id = user.id
    WHERE
      question_follows.questions_id = ?
    SQL
    
    result = []
    users.each { |user| result << Users.new(user) }
    result
  end
  
  
  attr_accessor :question_id, :user_id
  
  def initialize(options)
    @id = options['id']
    @questions_id = options['questions_id']
    @user_id = options['user_id']
  end
  
  def create
    raise "#{self} is already in database" if @id
    QuestionDatabase.instance.execute(<<-SQL, @question_id, @user_id)
    INSERT INTO
      question_follow (question_id, user_id)
    VALUES
      (?, ?)  
    SQL
    @id = QuestionDatabase.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in database" unless @id
    QuestionDatabase.instance.execute(<<-SQL, @question_id, @user_id, @id)
    UPDATE
      question_follows
    SET 
      question_id = ?, user_id = ?
    WHERE
      id = ?
    SQL
  end
end