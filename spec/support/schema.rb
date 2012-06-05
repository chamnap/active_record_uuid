ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true, :id => false do |t|
    t.string :uuid, :limit => 36
    t.string :text
    t.timestamps
  end
  
  create_table :comments, :force => true, :id => false do |t|
    t.string :uuid, :limit => 36
    t.string :text
    t.string :post_uuid
    
    t.timestamps
  end
  
  create_table :authors, :force => true, :id => false do |t|
    t.string :uuid, :limit => 36
    t.string :name
    
    t.timestamps
  end
  
  create_table :authors_posts, :force => true, :id => false do |t|
    t.string :post_uuid, :limit => 36
    t.string :author_uuid, :limit => 36
  end
end
