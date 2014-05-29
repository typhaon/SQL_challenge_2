
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

  erb :'actors/show'
end




get '/movies' do

@results = db_connection do |conn|
  conn.exec('SELECT movies.title, movies.id, movies.year, movies.rating, genres.name AS genre,
    studios.name AS studio FROM movies JOIN genres ON genres.id = movies.genre_id
    JOIN studios ON studios.id = movies.studio_id ORDER BY movies.title ASC')
end
  erb :'movies/index'
end




get '/movies/:id' do

identifier = params[:id]

query = "SELECT movies.title, genres.name AS genre, studios.name AS studio, actors.name,
    cast_members.character, actors.id
    FROM movies
    JOIN genres ON genres.id = movies.genre_id
    JOIN studios ON studios.id = movies.studio_id
    JOIN cast_members ON cast_members.movie_id = movies.id
    JOIN actors ON actors.id = cast_members.actor_id
    WHERE movies.id = #{identifier}"

movie_info_query = "SELECT movies.title, genres.name AS genre, studios.name AS studio
    FROM movies
    JOIN genres ON genres.id = movies.genre_id
    JOIN studios ON studios.id = movies.studio_id
    WHERE movies.id = #{identifier}"

@results = db_connection do |conn|
  conn.exec(query)
end

@movie_results = db_connection do |conn|
  conn.exec(movie_info_query)[0]
end

  erb :'movies/show'
end
