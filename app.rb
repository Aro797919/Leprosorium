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
@db.execute 'CREATE TABLE  IF NOT EXISTS Posts (id integer PRIMARY KEY AUTOINCREMENT,created_date date,content text,author text)'
@db.execute 'CREATE TABLE  IF NOT EXISTS Comments (id integer PRIMARY KEY AUTOINCREMENT,created_date date,content text,post_id integer)'
	end

get'/' do 
 @results = @db.execute'select * from Posts order by id desc'
 erb :index
	end
 
 get'/new' do
 	erb :new
 end

 post'/new' do
  content = params[:content] 
   author = params[:author] 
   if content.length <= 0 
   	@error = 'Type post text'
   	return erb :new
   end
  

   #сохранение данных в БД
 @db.execute 'insert into Posts (created_date, content, author) values ( datetime(), ?, ? )', [content,author]
redirect to('/')

 end

 get'/details/:post_id' do
 	#получаем переменную из url
post_id = params[:post_id]
#получаем список постов
 @results = @db.execute'select * from Posts where id = ?',[post_id]
 #выбираем этот один пост в переменную @row
 @row = @results[0]
 #выбираем  комментарий для поста
 @comments = @db.execute 'select * from Comments where post_id = ? order by id',[post_id]
erb :details
end

post'/details/:post_id' do
	post_id = params[:post_id]
	content = params[:content]
	if content.length <= 0 
   	@error = 'Type post text'
   	return erb :details/:post_id
   end
   @db.execute 'insert into Comments (created_date, content,post_id) values ( datetime(), ?, ? )', [content, post_id]
   redirect to('/details/' + post_id)
  
	end