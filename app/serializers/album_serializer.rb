class AlbumSerializer < ActiveModel::Serializer
  attributes :id,:artist_id, :name, :genre
  attribute :artist_url, key: :artist
  attribute :tracks_url, key: :tracks
  attribute :self_url, key: :self
end
