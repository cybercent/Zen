class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :client
      t.float :exact_value
      t.integer :estimate_value
      t.string :aasm_state
      t.integer :user_id
      t.timestamps
    end
  end
end
