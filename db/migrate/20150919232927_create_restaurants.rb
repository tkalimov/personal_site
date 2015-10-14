class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :neighborhood
      t.string :formatted_address
      t.string :blog_post_url
      t.float :location_latitude
      t.float :location_longitude

      t.timestamps
    end
  end
end
