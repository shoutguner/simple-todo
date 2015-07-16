class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :text, null: false
      t.integer :priority, default: 0, null: false
      t.datetime :deadline, null: true
      t.boolean :done, default: false, null: false
      t.references :project

      t.timestamps null: false
    end
    add_foreign_key :tasks, :projects
  end
end