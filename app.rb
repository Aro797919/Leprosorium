require'rubygems'
require'sinatra'
require'sinatra/reloader'
require'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

#добавление таблиц
configure do               #пишется для того,чтобы каждый раз таблица не пересоздавалось
init_db
@db.execute 'CREATE TABLE  IF NOT EXISTS Posts (id integer PRIMARY KEY AUTOINCREMENT,created_date date,content text)'
	end

get'/' do 
 erb :index
	end
 
 get'/new' do
 	erb :new
 end

 post'/new' do
  content = params[:content] 
   if content.length <= 0 
   	@error = 'Type post text'
   	return erb :new
   end
   erb "You typed  #{content}"

   #сохранение данных в БД
 @db.execute 'insert into Posts (created_date, content) values ( datetime(), ? )', [content]

 end
