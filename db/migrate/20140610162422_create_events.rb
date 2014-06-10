class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :location, null: false
    end
  end
end
