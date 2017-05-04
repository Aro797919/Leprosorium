require'rubygems'
require'sinatra'
require'sinatra/reloader'

get'/' do 
 erb"Hello Aro"
	
end
 get'/new' do
 	erb "Hello"
 end