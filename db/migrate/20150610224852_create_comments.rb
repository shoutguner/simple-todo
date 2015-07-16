class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text
      t.json :attachments
      t.references :task

      t.timestamps null: false
    end
    add_foreign_key :comments, :tasks
  end
end