class AlbumsController < ApplicationController

  # GET /albums
  def index
    #Si no tengo parametros muestro todos los albums
    if params[:name].blank? && params[:genre].blank? && params[:artist_id].blank? 
      @albums = Album.all
      render json: @albums, status: 200
    end

    if params[:artist_id].blank? == false
      # Retornar todos los albums del artista <artist_id> si existe
      if Album.where(artist_id: params[:artist_id]).exists?
        @albums = Album.where(artist_id: params[:artist_id])
        render json: @albums, status: 200
      # Si el <artist_id> no existe
      else
        render status: 404
      end
    end
  end

  # GET /albums/1
  def show
    #Encontrar album
    if Album.where(id:params[:id]).exists?
      @album = Album.find(params[:id])
      return render json: @album, status: 200
    #Album no encontrado
    else
      return render status: 404
    end
  end

  # POST /albums
  def create

    #Si alguno de los parametros viene vacio
    if (params[:name].blank? || params[:genre].blank?)
      return render status: 400
    end

    string = params[:name]
    genre = params[:genre]
    id_art = params[:artist_id]
    encoded = Base64.encode64("#{string}:#{id_art}") 
    encoded = encoded[0...22].strip
    
    #Si el artista no existe
    if Artist.where(id: params[:artist_id]).exists? == false
      return render status: 422
    end

    #Si el album ya existe
    if Album.where(id: encoded).exists?
      album  = Album.find(encoded)
      return render json: album, status: 409
    end

    @encoded_album = Album.new(id: encoded,artist_id: id_art , name: string, genre: genre, artist_url:"https://afternoon-depths-40075.herokuapp.com/artists/#{encoded}", tracks_url: "https://afternoon-depths-40075.herokuapp.com/#{encoded}/tracks" , self_url:"https://afternoon-depths-40075.herokuapp.com/albums/#{encoded}")

    # Si viene todo completo
    if @encoded_album.save
      return render json: @encoded_album, status: 201

    else 
      return render status: 400
    end

  end

  # PATCH/PUT /albums/1
  def update
    if @album.update(params)
      render json: @album
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end 

  # PLAY Reproduce todas las canciones de un album <album_id>
  def play
    #Si el album id existe
    if Album.where(id:params[:id]).exists?
      albums = Album.find(params[:id])
      id_album = albums.id
      tracks = Track.where(album_id: id_album)

      tracks.each do |track|
        track.times_played += 1
        track.save
      end
      return render status: 200

    else
      return render status:404
    end
  end

  # DELETE /albums/1
  def destroy
    #Elimina el album <album_id> y todos sus albums
    if Album.where(id:params[:id]).exists?
      @album = Album.find(params[:id])
      @album.destroy
      return render status: 204
    #Album no encontrado
    else
      return render status:404
    end

  end

end

