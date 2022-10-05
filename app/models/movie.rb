class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    
    if ratings_list.length() > 0
      formatted_ratings_list = ratings_list.map { |rating| rating.upcase }
      Movie.where(rating: formatted_ratings_list)
    else
      Movie.all
    end
  end
end
#   def Movie.with_ratings(ratings_to_show)
#     ratings = []
#     ratings_to_show.each_with_index  do |val,index| 
#       ratings[index] = val
#      end
#     if ratings.length == 0
#       Movie.where("")
#     else
#       Movie.where(rating:ratings)
#     end
#   end
# end