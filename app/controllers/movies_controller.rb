class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all #replace this
    
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    

    if params.has_key?(:ratings) #ratings
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = @ratings_to_show
      @hashed_ratings_to_show = Hash[@ratings_to_show.collect {|key| [key, '1']}]
    elsif ! params.has_key?(:ratings) && ! session.has_key?(:ratings)
      @ratings_to_show = []
      @hashed_ratings_to_show = Hash[@ratings_to_show.collect {|key| [key, '1']}]
    else
      @ratings_to_show = session[:ratings] #maybe inside if
      session[:ratings] = @ratings_to_show
      @hashed_ratings_to_show = Hash[@ratings_to_show.collect {|key| [key, '1']}]
    ######HEREEEEEE
    end
    @movies = Movie.with_ratings(@ratings_to_show)
    



    params[:sort_by] = session[:sort_by] #EEEPOJELINHERE
    @title_header = ""
    if params[:sort_by] == "title" #sorting based on title
      @title_header = "hilite bg-secondary"
      @movies = @movies.order(params[:sort_by])
      #update session
      session[:sort_by] = params[:sort_by]
    
    end
    
    @release_date_header = ""
    # puts params[:sort_by]
    if params[:sort_by] == "release_date" #sorting based on date
      @release_date_header = "hilite bg-secondary"
      @movies = @movies.order(params[:sort_by])
      #update session
      session[:sort_by] = params[:sort_by]
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
