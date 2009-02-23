class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.belongs_to :user
      t.belongs_to :refactor
      t.integer :score

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
