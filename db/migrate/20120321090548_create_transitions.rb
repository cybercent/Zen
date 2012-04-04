class CreateTransitions < ActiveRecord::Migration
  def change
    create_table :transitions do |t|
        t.string :enter_state
        t.string :exit_state
        t.text :comment
        t.integer :project_id
        t.integer :user_id
      t.timestamps
    end
  end
end
