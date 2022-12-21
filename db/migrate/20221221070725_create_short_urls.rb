class CreateShortUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :short_urls do |t|
      t.string :original_url, null: false
      t.string :code, null: false

      t.timestamps
    end

    add_index :short_urls, :code, unique: true
  end
end
