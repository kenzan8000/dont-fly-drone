class CreatePolygons < ActiveRecord::Migration
  def change
    create_table :polygons do |t|
      t.string :area_id

      t.timestamps null: false
    end
  end
end
