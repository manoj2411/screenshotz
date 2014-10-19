class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.string :substitute_id
      t.string :name
      t.integer :views_count, default: 0
      t.string :url
      t.belongs_to :user, index: true

      t.timestamps
    end
    add_index :screenshots, :substitute_id
  end
end
