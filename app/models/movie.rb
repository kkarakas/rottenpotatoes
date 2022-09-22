class Movie < ActiveRecord::Base

  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    
    #take array of rating
    #return activeRecord relation

    if ratings_list.length() == 0
      return Movie.all
    else
      mapp = ratings_list.map{ |rating | rating.upcase}
      return Movie.where(rating: mapp)
    end
  
  end
  
  def self.all_ratings
    ['G','PG','PG-13','R'] #ruby way of return
  end

end
