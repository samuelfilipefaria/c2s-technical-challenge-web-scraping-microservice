class CreateDataScrapings < ActiveRecord::Migration[7.2]
  def change
    create_table :data_scrapings do |t|
      t.string :task_id
      t.string :url_for_scraping
      t.string :scraped_data

      t.timestamps
    end
  end
end
