class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = Playlist.all
  end

  def lookup
    fz_playlist = Playlist.find_by(spotify_uri: params[:spotify_uri])
    if fz_playlist
      redirect_to fz_playlist
    end
    playlist_link = 'https://api.spotify.com/v1/users/' + params[:owner] + '/playlists/' + params[:spotify_uri]
    spotify_playlist_data = HTTParty.get(
        playlist_link,
        headers: {
          'Authorization' => 'Bearer ' + session[:access_token]
        }
      )
    @spotify_playlist = {
      name: spotify_playlist_data['name'],
      snapshot_id: spotify_playlist_data['snapshot_id'],
      spotify_uri: params[:spotify_uri],
      owner_id: params[:owner]
    }
    @songs = spotify_playlist_data['tracks']['items']

  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
    @fz_playlist = Playlist.find(params[:id])
    
    playlist_link = 'https://api.spotify.com/v1/users/' + @fz_playlist[:owner] + '/playlists/' + @fz_playlist[:spotify_uri]
    spotify_playlist_data = HTTParty.get(
        playlist_link,
        headers: {
          'Authorization' => 'Bearer ' + session[:access_token]
        }
      )
    @spotify_playlist = {
      name: spotify_playlist_data['name'],
      snapshot_id: spotify_playlist_data['snapshot_id'],
      spotify_uri: @fz_playlist[:spotify_uri],
      owner_id: @fz_playlist[:owner]
    }
    @songs = spotify_playlist_data['tracks']['items']
    binding.pry
  end

  # GET /playlists/new
  def new
    playlist_link = 'https://api.spotify.com/v1/users/' + params[:owner] + '/playlists/' + params[:id]
    spotify_playlist_data = HTTParty.get(
        playlist_link,
        headers: {
          'Authorization' => 'Bearer ' + session[:access_token]
        }
      )
    @playlist = Playlist.new({
      spotify_uri: params[:id],
      snapshot_id: spotify_playlist_data['snapshot_id'],
      user_id: session[:user_id],
      owner: params[:owner],
      repeats_allowed: false
    })
    binding.pry
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @playlist = Playlist.new(playlist_params)

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: 'Playlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find_by(spotify_uri: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:spotify_uri, :snapshot_id, :collaboration_name, :owner, :repeats_allowed, :rolloff_frequency)
    end
end
