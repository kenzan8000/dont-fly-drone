class CreatePolygons < ActiveRecord::Migration
  def change
    create_table :polygons do |t|
      t.integer :area_id

      t.timestamps null: false
    end
  end
end
