class Movie < ActiveRecord::Base
  
  def Movie.all_ratings
    ['G','PG','PG-13','R']
  end
  def Movie.with_ratings(ratings_to_show)
    display_rating1 = []
    ratings_to_show.each_with_index  do |val,index| 
      display_rating1[index] = val
     end
    unless display_rating1.length == 0
      where(rating:display_rating1)
    else
      where("")
    end
  end
end