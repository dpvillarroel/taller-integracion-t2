class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :name, :age
  attribute :albums_url, key: :albums
  attribute :tracks_url, key: :tracks
  attribute :self_url, key: :self
end
