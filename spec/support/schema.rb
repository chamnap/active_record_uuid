ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true, :id => false do |t|
    t.string :uuid, :limit => 36
    t.string :text
    t.timestamps
  end
end
