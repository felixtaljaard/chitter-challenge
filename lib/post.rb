require 'pg'

class Post

  attr_reader :id, :content, :posted_at

  def initialize(id:, content:, posted_at:)
    @id = id
    @content = content
    @posted_at = posted_at
  end

  def self.all
    connect_database_environment
    result = @connection.exec('SELECT * FROM post;')
    result.map do |post| 
      Post.new(id: post['id'], content: post['content'], posted_at: post['posted_at'])
    end
  end

  def self.create(content:, posted_at:)
    connect_database_environment
    r = @connection.exec_params("INSERT INTO post (content, posted_at) VALUES($1, $2) RETURNING id, content, posted_at", [content, posted_at])
    Post.new(id: r[0]['id'], content: r[0]['content'], posted_at: r[0]['posted_at'])
  end

  def self.connect_database_environment
    if ENV['ENV'] == 'test'
      @connection = PG.connect(dbname: 'chitter_test')
    else
      @connection = PG.connect(dbname: 'chitter')     
    end
  end

end