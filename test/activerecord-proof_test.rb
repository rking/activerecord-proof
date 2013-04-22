require './test/test_helper'

class Author < ActiveRecord::Base
  has_many :books
end

class Book < ActiveRecord::Base
  belongs_to :author
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', database: 'db/test.sqlite3')

class ArTraceTest < MiniTest::Unit::TestCase
  def test_basic
    ActiveRecordProof.guard 'author-all' do
      Author.all
    end
    assert_raises ActiveRecordProof::Diff do
      ActiveRecordProof.guard 'author-all' do
        Author.first # totally not the query above, just an example for testing
      end
    end
  end
end
