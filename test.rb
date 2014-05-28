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



@results = db_connection do |conn|
  conn.exec('SELECT actors.name FROM actors ORDER BY actors.name ASC')
end
@results = @results.to_a
binding.pry

