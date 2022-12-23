class AddIndexOriginalUrlToShortUrls < ActiveRecord::Migration[6.1]
  def change
    add_index :short_urls, :original_url
  end
end
