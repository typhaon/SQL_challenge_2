
require 'sinatra'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'movies')

    yield(connection)

  ensure
    connection.close
  end
end















get '/actors' do


@results = db_connection do |conn|
  conn.exec('SELECT actors.name, actors.id FROM actors ORDER BY actors.name ASC')
end




  erb :'actors/index'

end











get '/actors/:id' do

  erb
end


get '/movies' do

  erb :'movies/index'
end

get 'movies/:id' do

  erb
end
