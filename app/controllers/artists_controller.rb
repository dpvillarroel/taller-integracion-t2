require "base64"
class ArtistsController < ApplicationController
  #before_action :set_artist, only: [:show,:index,:create, :update, :destroy]

  # GET /artists
  def index
    #if que
    @artists = Artist.all

    return render json: @artists
  end

  # GET /artists/1
  def show
    if Artist.where(id:params[:id]).exists?
      @artist = Artist.find(params[:id])
      return render json: @artist, status: 200
    else
      return render status: 404
    end
  end

  # POST /artists
  def create

    if params[:name].blank? || params[:age].blank?
      return render status: 400
    end

    str = params[:name]
    age = params[:age]
    encoded = Base64.encode64(str) 
    encoded = encoded[0...22].strip

      #Si el artista ya existe
    if Artist.where(id: encoded).exists?
      artist = Artist.find(encoded)
      return render json: artist, status:409
    end
    
    if (params[:name].blank? && params[:age].blank?) == false && (Artist.where(id:params[:id]).exists? == false)
      @encoded_artist = Artist.new(id: encoded, name: str, age: age, albums_url:"https://afternoon-depths-40075.herokuapp.com/artists/#{encoded}/albums", 
        tracks_url: "https://afternoon-depths-40075.herokuapp.com/#{encoded}/tracks" , self_url:"https://afternoon-depths-40075.herokuapp.com/artists/#{encoded}")

      if @encoded_artist.save
        return render json: @encoded_artist, status: 201

      else
        return render status: 400

      end

    end

  end

  # PATCH/PUT /artists/1
  def update
    if @artist.update(params)
      render json: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  # ARTISTS#PLAY 
  #Reproduce todas las canciones de un artista <artist_id>
  def play
    if Artist.where(id: params[:id]).exists?
      albums = Album.where(artist_id: params[:id])
      albums.each do |album|
        tracks = Track.where(album_id: album.id)
        tracks.each do |track|
          track.times_played += 1
          track.save
        end
      end 
      return render status: 200
    else
      return render status: 404
    end
  end

  # DELETE /artists/1
  def destroy
    if Artist.where(id:params[:id]).exists?
      @artist = Artist.find(params[:id])
      @artist.destroy
      render status: 204
    else
      render status:404
    end
  end




  #private
    # Use callbacks to share common setup or constraints between actions.
    #def set_artist
      #@artist = Artist.find(params[:id])
    #end

    # Only allow a trusted parameter "white list" through.
    #def artist_params
      #params.require(:artist).permit(:name, :age, :albums, :tracks, :self_url)
    #end
end
