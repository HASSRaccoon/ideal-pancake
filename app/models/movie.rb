class Movie < ActiveRecord::Base
  
  # attr_accessor :all_ratings
  
  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all movies with those ratings
    if ratings_list.nil?
      return @all_ratings
    # if ratings_list is nil, retrieve ALL movies
    else
      return ratings_list
    end
  end


end
