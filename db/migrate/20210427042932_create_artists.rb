class CreateArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :artists, id: false do |t|
      t.string :id, primary_key: true
      t.string :name
      t.integer :age
      t.string :albums_url
      t.string :tracks_url
      t.string :self_url
      t.timestamps
    end
  end
end
