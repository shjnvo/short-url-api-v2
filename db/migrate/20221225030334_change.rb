class Change < ActiveRecord::Migration[6.1]
  def change
    change_column :short_urls, :id, :bigint
  end
end
