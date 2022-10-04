class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings =  {'G' : 1,'PG' : 1,'PG-13' : 1,'R' : 1}
      if(!params.has_key?(:sort) && !params.has_key?(:ratings))
        if(session.has_key?(:sort) || session.has_key?(:ratings))
          redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
        end
      end

      @sort = params.has_key?(:sort) ? (session[:sort] = params[:sort]) : session[:sort]
      @ratings_to_show = params[:ratings]
      if(@ratings_to_show != nil)
        ratings = @ratings_to_show.keys
        session[:ratings] = @ratings_to_show
      else
        if(!params.has_key?(:commit) && !params.has_key?(:sort))
          ratings = Movie.all_ratings.keys
          session[:ratings] = Movie.all_ratings
        else
          ratings = session[:ratings].keys
        end
      end
      @movies = Movie.order(@sort).find_all_by_rating(ratings)
      @mark  = ratings

      # @ratings_to_show = params[:ratings] || session[:ratings] || {}
      # @sort = params[:sort] || session[:sort] 

      # if @ratings_to_show == {}
      #   @ratings_to_show = Hash[@all_ratings.map {|r| [r, 1]}]
      # end

      # if params[:sort] != session[:sort] 
      #   session[:sort] = @sort
      #   redirect_to :sort => @sort, :ratings => @ratings_to_show and return
      # end

      # if params[:ratings] != session[:ratings]
      #   session[:sort] = @sort
      #   session[:ratings] = @ratings_to_show
      #   redirect_to :sort => @sort, :ratings => @ratings_to_show and return
      # end

      # @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
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