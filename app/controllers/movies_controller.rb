class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all #replace this
    # session.clear()
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    @redirect = false

    if params.has_key?(:ratings) #param has it
      # puts "inside 17"
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = params[:ratings]
      @hashed_ratings_to_show = Hash[@ratings_to_show.collect {|key| [key, '1']}]
    elsif ! params.has_key?(:ratings) && ! session.has_key?(:ratings) #both doesnt have it 
      # puts "inside 21"
      @ratings_to_show = @all_ratings
      @hashed_ratings_to_show = Hash[@ratings_to_show.collect {|key| [key, '1']}]
    else #param doesnt have it but session does
      # puts "inside 26"
      @redirect = true
      # puts session[:ratings] # TEMPS
      #this is stupid right now CHANGE IT
      @ratings_to_show = session[:ratings].keys#added
      # session[:ratings] = @ratings_to_show
      @hashed_ratings_to_show = Hash[@ratings_to_show.collect {|key| [key, '1']}]
    
      params[:ratings] = session[:ratings] 
      ######HEREEEEEE

    end
    @movies = Movie.with_ratings(@ratings_to_show)
    


    @title_header = ""
    @release_date_header = ""
    if params[:sort_by] == "title" #sorting based on title
      # puts "inside 44"
      @title_header = "hilite bg-secondary"
      @movies = @movies.order(params[:sort_by])
      #update session
      session[:sort_by] = params[:sort_by]
      
    
    # puts params[:sort_by]
    elsif params[:sort_by] == "release_date" #sorting based on date
      # puts "inside 53"
      @release_date_header = "hilite bg-secondary"
      @movies = @movies.order(params[:sort_by])
      #update session
      session[:sort_by] = params[:sort_by]
    
    elsif ! params.has_key?(:sort_by) && ! session.has_key?(:sort_by) #both doesnt have it 
      # puts "inside 60"
      
    else #not sorting???
      # puts "inside 64"
      @redirect = true
      params[:sort_by] = session[:sort_by] #EEEPOJELINHERE
      @release_date_header = "hilite bg-secondary"
      @movies = @movies.order(params[:sort_by])
      #update session

    end

    if @redirect
      @redirect = false
      redirect_to movies_path( :sort_by => params[:sort_by], :ratings => params[:ratings])
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
