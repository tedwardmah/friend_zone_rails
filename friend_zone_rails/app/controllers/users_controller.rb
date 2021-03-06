class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /
  def login_page
  end

  def login
    scope = 'user-read-private user-read-email playlist-read-collaborative playlist-modify-private playlist-modify-public'
    client_id = ENV['FRIEND_ZONE_CLIENT_ID']
    client_secret = ENV['FRIEND_ZONE_CLIENT_SECRET']
    redirect_uri = 'http://localhost:3000/callback'
    state = 'ABCDEFGHabcdefgh' #this needs to be randomized and use session
    redirect_string = 'https://accounts.spotify.com/authorize?' + 'response_type=code' + '&client_id=' + client_id + '&scope=' + scope + '&redirect_uri=' + redirect_uri + '&state=' + state
    redirect_to redirect_string
  end

  def spotify_callback
    ### consume spotify authorization response ###
    code = params['code']
    state = params['state']
    # storedState = req.cookies ? req.cookies[stateKey] : null

    ### Token request preparation ###
    client_id = ENV['FRIEND_ZONE_CLIENT_ID']
    client_secret = ENV['FRIEND_ZONE_CLIENT_SECRET']
    redirect_uri = 'http://localhost:3000/callback'
    auth_body = {
      'code'=> code,
      'redirect_uri'=> redirect_uri,
      'grant_type'=> 'authorization_code',
      'client_id'=> client_id,
      'client_secret'=> client_secret
    }
    auth_headers = {
      'Authorization' => "Basic #{Base64.strict_encode64(client_id + ':' + client_secret)}"
    }
    
    ### Request and consume tokens ###
    auth_response = HTTParty.post(
      'https://accounts.spotify.com/api/token', 
      body: auth_body, 
      headers: auth_headers
    )
    reset_session
    access_token = auth_response['access_token']
    refresh_token = auth_response['refresh_token']
    session[:access_token] = access_token
    session[:refresh_token] = refresh_token

    ### User Data request preparation ###
    user_data_headers = {
      'Authorization' => 'Bearer ' + access_token
    }
    spotify_user_data = HTTParty.get('https://api.spotify.com/v1/me',
      headers: user_data_headers
    )
    user = User.find_by(spotify_user_id: spotify_user_data['id'])
    if user != nil
      set_session_user(user.id)
      redirect_to "/users/#{user.id}"
    else
      session[:spotify_user_id] = spotify_user_data['id']
      session[:name] = spotify_user_data['display_name']

      redirect_to "/users/new"
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    spotify_user_id = User.find(session[:user_id]).spotify_user_id
    user_playlists_headers = {
      'Authorization' => 'Bearer ' + session[:access_token]
    }
    spotify_playlists_response = HTTParty.get(
        "https://api.spotify.com/v1/users/#{spotify_user_id}/playlists?limit=50",
        headers: user_playlists_headers
      )
    @playlists = spotify_playlists_response['items']
  end

  # GET /users/new
  def new
    @user = User.new({
        access_token: session[:access_token],
        refresh_token: session[:refresh_token],
        spotify_user_id: session[:spotify_user_id],
        name: session[:name]
      })
    delete session[:name]
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        set_session_user(@user.id)
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      if session[:user_id] != @user.id
        reset_session
        redirect_to '/'
      end
    end

    def get_new_refresh_token
      client_id = ENV['FRIEND_ZONE_CLIENT_ID']
      client_secret = ENV['FRIEND_ZONE_CLIENT_SECRET']
      token_refresh_headers = {
        'Authorization' => "Basic #{Base64.strict_encode64(client_id + ':' + client_secret)}"
      }
      token_refresh_body = {
        'grant_type' => 'refresh_token',
        'refresh_token' => session[:refresh_token]
      }
      spotify_token_response = HTTParty.post(
        'https://accounts.spotify.com/api/token',
        body: token_refresh_body,
        headers: token_refresh_headers
        )
      binding.pry
      session[:access_token] = spotify_token_response[:access_token]
      binding.pry
    end

    def set_session_user(id)
      session[:user_id] = id || nil
      session[:spotify_user_id] = id ? User.find(id).spotify_user_id : nil
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:spotify_user_id, :access_token, :refresh_token, :name, :state, :error)
    end
end
