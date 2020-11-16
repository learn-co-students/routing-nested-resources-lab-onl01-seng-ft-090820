class SongsController < ApplicationController
  
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist
        @songs = @artist.songs
      else
        # flash[:alert] = "Artist not found"
        redirect_to artists_path, flash: { alert: "Artist not found" }
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      # binding.pry
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist
        # binding.pry
        @song = @artist.songs.find_by(id: params[:id])
        if !@song
          redirect_to artist_songs_path, flash: { alert: "Song not found"}
        end
      else
        redirect_to artists_path, flash: { alert: "Artist not found" }
      end
    else
      # binding.pry
      set_song
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    set_song
  end

  def update
    set_song

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    set_song
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def set_song
    @song = Song.find_by(id: params[:id])
  end

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end

