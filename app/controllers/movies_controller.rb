class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
    
      @all_ratings =  ['G','PG','PG-13','R']
      unless params[:ratings].nil?
        @param_ratings = params[:ratings]
        session[:ratings] = @param_ratings
        @ratings_to_show = params[:ratings].keys
      end
      
      unless params[:sort].nil?
        @sort = params[:sort]
        session[:sort] = @sort
      end

      if params[:sort].nil? && params[:ratings].  nil? && session[:ratings]
        @ratings_to_show = session[:ratings]
        @sort = session[:sort]
        flash.keep
        redirect_to movies_path({sort: session[:sort], ratings: session[:ratings]})
      end

      @movies = @all_ratings
      if session[:ratings].present?
        @movies = Movie.with_ratings(@ratings_to_show)
      end

      if session[:sort]
        @movies = @movies.order(@sort)
      end
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