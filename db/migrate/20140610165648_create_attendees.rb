class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.belongs_to :events
      t.belongs_to :users
    end
  end
end
