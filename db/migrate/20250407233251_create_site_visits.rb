class CreateSiteVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :site_visits do |t|
      t.string :session_id
      t.datetime :visit_time
      t.string :path

      t.timestamps
    end
  end
end
