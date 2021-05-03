class TrackSerializer < ActiveModel::Serializer
  attributes :id,:album_id, :name, :duration, :times_played
  attribute :artist_url, key: :artist
  attribute :album_url, key: :album
  attribute :self_url, key: :self
end
