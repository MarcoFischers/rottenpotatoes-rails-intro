class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    ratings = params[:ratings]
    ratings_arr = []
    ratings.each_key { |k| ratings_arr << k} unless ratings.nil?
    
    sort_by = params[:sort_by]
    sort_by = sort_by.to_sym unless sort_by.nil?

    # retrieve movies filtered by ratings and sorted as required
    @movies = Movie.retrieve(ratings_arr, sort_by)

    # keep track of sorting criteria
    if sort_by == :title
      @sorted = :title
    elsif sort_by == :date
      @sorted = :date
    else
      @sorted = nil
    end

    # retrieve rating values
    @all_ratings = Movie.get_ratings
    
    # activate ratings
    @active_ratings = Hash.new()
    if ratings.nil?
      @all_ratings.each { |r| @active_ratings[r] = true }
    else
      @all_ratings.each { |r| @active_ratings[r] = false }
      ratings_arr.each { |r| @active_ratings[r] = true }
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
