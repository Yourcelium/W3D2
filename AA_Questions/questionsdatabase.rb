require 'sqlite3'
require 'singleton'
require_relative 'users'
require_relative 'question'
require_relative 'question_follows'
require_relative 'replies'
require_relative 'question_likes'


class QuestionDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
  
end




