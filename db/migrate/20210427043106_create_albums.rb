class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums, id: false do |t|
      t.references :artist, null: false, foreign_key: true, type: :string
      t.string :id, primary_key: true
      t.string :name
      t.string :genre
      t.string :artist_url
      t.string :tracks_url
      t.string :self_url
      t.timestamps
    end
  end
end
