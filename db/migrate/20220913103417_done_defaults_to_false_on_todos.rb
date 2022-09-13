class DoneDefaultsToFalseOnTodos < ActiveRecord::Migration[7.0]
  def change
    change_column :todos, :done, :boolean, default: false
  end
end
