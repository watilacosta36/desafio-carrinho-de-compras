class AddLastInteractionAt < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :last_interaction_at, :datetime, null: true
  end
end
