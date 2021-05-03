class TracksController < ApplicationController
  #before_action :set_track, only: [:show, :update, :destroy]

  # GET /tracks
  def index
    #Si no tengo parametros muestro todos los tracks
    if params[:name].blank? && params[:duration].blank? && params[:album_id].blank? && params[:artist_id].blank?
       @tracks = Track.all
       return render json: @tracks, status: 200
    end 

    #Mostrar todos los tracks del artista
    if params[:artist_id].blank? == false

      if Artist.where(id: params[:artist_id]).exists? 
        array = []
        albums = Album.where(artist_id: params[:artist_id])
        albums.each do |album|
          tracks = Track.where(album_id: album.id)
          tracks.each do |track|
            track.save
            array << track
          end
        end
        return render json: array, status: 200

      #Artista no encontrado
      else
         return render status: 404
      end

    end

    if params[:album_id].blank? == false
      #Retorna todas las canciones del album <album_id>
      if Track.where(album_id: params[:album_id]).exists?
        @tracks = Track.where(album_id: params[:album_id])
        return render json: @tracks, status: 200

      # Retorna no encontrado si album id malo
      else
        return render status: 404
      end
    end 

  end


  # GET /tracks/1
  def show
    #Buscar id de track
    if Track.where(id:params[:id]).exists?
      @track = Track.find(params[:id])
      return render json: @track, status: 200
    #Si no existe
    else
      return render status: 404
    end
  end

  # POST /tracks
  def create

    #Que alguno de los parametros falte
    if params[:name].blank? || params[:duration].blank?
      return render status: 400
    end

    #Si el album no existe
    if Album.where(id: params[:album_id]).exists? == false
      return render status: 422
    end

    nam = params[:name]
    dur = params[:duration]
    id_album = params[:album_id]
    encoded = Base64.encode64("#{nam}:#{id_album}") 
    encoded = encoded[0...22].strip
    id_art = Album.find(params[:album_id]).artist_id

    #Si la cancion ya existe
    if Track.where(id: encoded, album_id: params[:album_id]).exists? 
      song = Track.find(encoded)
      return render json: song, status: 409
    end

    @track = Track.new(id: encoded, album_id: params[:album_id], name: nam, duration: dur, times_played: 0, artist_url: "https://afternoon-depths-40075.herokuapp.com/artists/#{id_art}",album_url: "https://afternoon-depths-40075.herokuapp.com/albums/#{id_album}", self_url: "https://afternoon-depths-40075.herokuapp.com/tracks/#{encoded}")

    if @track.save
      return render json: @track, status: 201

    else
      return render status:400
    end

  end

  # PATCH/PUT /tracks/1
  def update
    if @track.update(params)
      render json: @track
    else
      render json: @track.errors, status: :unprocessable_entity
    end
  end

  #PLAY Reproduce cancion <track_id>
  def play
    #Buscar si existe
    if Track.where(id:params[:id]).exists?
      track = Track.find(params[:id])
      track.times_played += 1
      track.save
      return render status:200
    #Si no existe ese track
    else
      return render status: 404
    end

  end


  # DELETE /tracks/1
  def destroy
    #Elimina la cancion <track_id>
    if Track.where(id:params[:id]).exists?
      @track = Track.find(params[:id])
      @track.destroy
      return render status: 204
    else
      return render status:404
    end
  end


end
