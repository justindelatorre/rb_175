ENV['RACK_ENV'] = 'cms'

require 'minitest/autorun'
require 'rack/test'

require_relative '../cms'

class CmsTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get '/'

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, 'about.md'   
    assert_includes last_response.body, 'changes.txt'   
    assert_includes last_response.body, 'history.txt'   
  end

  def test_viewing_text_document
    filename = 'history.txt'
    get '/' + filename

    assert_equal 200, last_response.status
    assert_equal 'text/plain', last_response['Content-Type']
    assert_includes last_response.body, 'Ruby 0.95 released' 
  end

  def test_viewing_nonexistent_document
    filename = 'nonexistent.txt'
    get '/' + filename

    assert_equal 302, last_response.status

    get last_response['Location']

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'nonexistent.txt does not exist'
    
    get '/'
    refute_includes last_response.body, 'nonexistent.txt does not exist'
  end

  def test_viewing_markdown_document
    filename = 'about.md'
    get '/' + filename

    assert_equal 200, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response['Content-Type']
    assert_includes last_response.body, '<h1>The History of Ruby</h1>'    
  end
end
