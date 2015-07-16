class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, default: 'New TODO', null: false
      t.integer :priority, default: 0, null: false
      t.references :user

      t.timestamps null: false
    end
    add_foreign_key :projects, :users
  end
end