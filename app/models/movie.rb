class Movie < ActiveRecord::Base

  def Movie.with_ratings(ratings_to_show)
    display_rating1 = []
    ratings_to_show.each_with_index  do |val,index| 
      display_rating1[index] = val
     end
    if display_rating1.length == 0
      Movie.where("")
    else
      Movie.where(rating:display_rating1)
    end
  end
end