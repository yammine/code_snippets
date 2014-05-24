require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/contractor.db")

class Snippet

  def self.number_of_kind(kind)
    x = 0
    self.all.each do |snip|
      if snip.kind.include?(kind)
        x += 1
      end
    end
    x
  end

  include DataMapper::Resource

  property :id,     Serial

  property :kind,   String
  property :title,  String
  property :work,   Text

end

DataMapper.finalize

Snippet.auto_upgrade!

get '/' do
  @snippets = Snippet.all 
  @ruby = Snippet.number_of_kind 'Ruby'
  @js = Snippet.number_of_kind 'JavaScript'
  @cs = Snippet.number_of_kind 'CoffeeScript'
  @html = Snippet.number_of_kind 'HTML'
  @css = Snippet.number_of_kind 'CSS'
  
  erb :index, layout: :default_layout
end

get '/add' do
  erb :add_snippet, layout: :default_layout
end

post '/add' do
  Snippet.create(params)

  redirect to('/')

end
