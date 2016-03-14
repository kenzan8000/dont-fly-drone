class CreatePolygons < ActiveRecord::Migration
  def change
    create_table :polygons do |t|
      t.integer :area_id
      t.float :min_lat
      t.float :min_lng
      t.float :max_lat
      t.float :max_lng

      t.timestamps null: false
    end
  end
end
