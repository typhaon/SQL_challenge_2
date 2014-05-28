
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

identifier = params[:id]
query ="SELECT movies.title, movies.id, cast_members.character
 FROM cast_members JOIN movies ON movies.id = cast_members.movie_id
 WHERE cast_members.actor_id = #{identifier}"

@results = db_connection do |conn|
  conn.exec(query)
end
binding.pry
  erb :'actors/show'
end




get '/movies' do

  erb :'movies/index'
end

get 'movies/:id' do

  erb
end
