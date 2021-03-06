class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    @all_ratings = get_ratings
    #initialize session ratings if it is not defined yet
    session[:ratings] = @all_ratings unless session.has_key?(:ratings)
    #get ratings from parameters if they are given
    if params.has_key?(:ratings) and !params[:ratings].empty?
      session[:ratings] = params[:ratings].keys
    else
      session[:ratings] = @all_ratings
    end
    @selected = session[:ratings]
    #get sortby if it is given
    session[:sortby] = params[:sortby] if params.has_key?(:sortby)
    if session.has_key?(:sortby)
      @movies = Movie.order(session[:sortby]).where(:rating => @selected)
    else
      @movies = Movie.where(:rating => @selected)
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

  def get_ratings
    Movie.select(:rating).map(&:rating).uniq
  end
end
