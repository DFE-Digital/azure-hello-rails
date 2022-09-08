class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :body
      t.boolean :done, default: true

      t.timestamps
    end
  end
end
