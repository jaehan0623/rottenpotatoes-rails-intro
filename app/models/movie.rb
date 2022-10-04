class Movie < ActiveRecord::Base

  def Movie.with_ratings(ratings_to_show)
    ratings = []
    ratings_to_show.each_with_index  do |val,index| 
      ratings[index] = val
     end
    if display_rating1.length == 0
      Movie.where("")
    else
      Movie.where(rating:ratings)
    end
  end
end