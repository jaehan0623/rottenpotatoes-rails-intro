class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings =  ['G','PG','PG-13','R']
      # if params[:ratings].nil?
      #   @ratings_to_show = session[:ratings]
      # elsif params[:ratings] == {}
      #   @ratings_to_show = Hash[@all_ratings.map {|r| [r, 1]}]
      # else
      #   @ratings_to_show = params[:ratings]
      # end
      # @param_ratings =  params[:ratings].nil? ? @all_ratings: params[:ratings]
      # @ratings_to_show = params[:ratings] || session[:ratings] || {}
      # @sort = params[:sort] || session[:sort] 
    #   if @ratings_to_show == {}
    #     @ratings_to_show = Hash[@all_ratings.map {|r| [r, 1]}]
    #   end

    #   if params[:sort] != session[:sort] 
    #     session[:sort] = @sort
    #     redirect_to :sort => @sort, :ratings => @ratings_to_show and return
    #   end

    #   if params[:ratings] != session[:ratings]
    #     session[:sort] = @sort
    #     session[:ratings] = @ratings_to_show
    #     redirect_to :sort => @sort, :ratings => @ratings_to_show and return
    #   end

    #   @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
    # end
      if params[:ratings] = {}
        params[:ratings] = @all_ratings
      end 
      # Update session selected ratings if the ratings query is updated.
      if session[:ratings] != params[:ratings] && params[:ratings] != nil
        session[:ratings] = params[:ratings] 
      end
      # Update session sort if the sort query is updated.
      if session[:sort] != params[:sort] && params[:sort] != nil
        session[:sort] = params[:sort]
      end

      # If anythings is missing from query params and is available in session, get it from session.
      if params[:ratings] == nil && params[:sort] == nil && session[:ratings] != nil
        redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
      elsif params[:ratings] == nil && session[:ratings] != nil
        redirect_to movies_path(:sort => params[:sort], :ratings => session[:ratings])
      elsif params[:sort] == nil && session[:sort] != nil
        redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
      end
      @ratings_to_show = params[:ratings] == nil ? @all_ratings : params[:ratings].keys

      @movies = Movie.order(params[:sort]).where({rating: @ratings_to_show})
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