class CreateWebMotorsScrapedData < ActiveRecord::Migration[7.2]
  def change
    create_table :web_motors_scraped_data do |t|
      t.string :brand
      t.string :model
      t.float :price
      t.integer :web_scraping_task_id

      t.timestamps
    end
  end
end
