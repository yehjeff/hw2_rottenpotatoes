class MoviesController < ApplicationController

  def show
    session[:prev] = true
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @checked_ratings = []
    s_by = params[:s_type]
    if session[:prev] == true
      s_by = session[:s_type] #new
    end
    session[:s_type] = s_by ###
    if (s_by == nil)
      s_by = params[:ps_type]
      if session[:prev] == true
        s_by = session[:ps_type] #new
      end
      session[:ps_type] = s_by ###
    end
    ordered_movies = Movie.order(s_by)
    filtered_movies = []
    movie_final = []
    if session[:prev] == true
      @checked_ratings = session[:checked_ratings] #new
    end   
    if (params[:ratings] == nil)
      if params[:checked_ratings] != nil
        @checked_ratings = params[:checked_ratings]
        if params[:checked_ratings] == nil
          @checked_ratings = []
        end
        session[:checked_ratings] = @checked_ratings #######
        @checked_ratings.each{|rating|
          filtered_movies += Movie.where("Rating='"+rating+"'")
        }
      end
    end
    
    if session[:prev] == true
      @checked_ratings = session[:ratings] #new
    end
    if params[:ratings] != nil
      @checked_ratings = params[:ratings].keys
      session[:ratings] = @checked_ratings ########
      @checked_ratings.each{|rating|
        filtered_movies += Movie.where("Rating='"+rating+"'")
      }
    end

    ordered_movies.each{|mov|
      if filtered_movies.index(mov) != nil
        movie_final << mov
      end
    }
    
    @movies = movie_final
       
    @t_HL = false
    @r_HL = false
    if(s_by=="title")
      @t_HL = true
    end
    if(s_by=="release_date")
      @r_HL = true
    end
    
    #session[:ratings] = @checked_ratings
    #session[:checked_ratings] = @checked_ratings
    #session[:ps_type] = s_by
    #session[:s_type] = s_by
    session[:prev] = false
    
  end

  def new
    # default: render 'new' template
  end

  def create
    session[:prev] = true
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    session[:prev] = true
    @movie = Movie.find params[:id]
  end

  def update
    session[:prev] = true
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    session[:prev] = true
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
