class Movie < ActiveRecord::Base
    def Movie.get_ratings
      result = []
      Movie.select(:rating).distinct.order('rating asc').each { |rec| result << rec.rating }
      return result
    end
    
    def Movie.retrieve(ratings, sort_by)
      rating_list = ''
      ratings.each { |r| rating_list << "'#{r}'," }
      if rating_list == ''
        where_cond = '1 = 1'
      else
        where_cond = 'rating in (' + rating_list.chop + ')'
      end
      
      if sort_by == :title
        Movie.where(where_cond).order('title asc')
      elsif sort_by == :date
        Movie.where(where_cond).order('release_date asc')
      else
        Movie.where(where_cond)
      end
    end
end
