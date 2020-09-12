class ChangeStatusColumnToString < ActiveRecord::Migration[6.0]
  def change
    reversible do |d|
      change_table :tasks do |t|
        d.up { t.change :status, :string, default: 'uncompleted' }
        d.down { t.change :status, :integer }
      end
    end
  end
end
