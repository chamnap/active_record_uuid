ActiveRecord::Schema.define do
  self.verbose = false

  create_table :blogs, :force => true, :id => false do |t|
    t.binary :uuid, :limit => 16
    t.string :name
    t.timestamps
  end

  create_table :articles, :force => true do |t|
    t.string :title
    t.string :uuid, :limit => 36
    t.binary :blog_uuid, :limit => 16
  end
  
  create_table :post_binaries, :force => true, :id => false do |t|
    t.binary :uuid, :limit => 16
    t.string :text
    t.timestamps
  end
  
  create_table :post_base64s, :force => true, :id => false do |t|
    t.string :uuid, :limit => 24
    t.string :text
    t.timestamps
  end
  
  create_table :post_hex_digests, :force => true, :id => false do |t|
    t.string :uuid, :limit => 32
    t.string :text
    t.timestamps
  end
  
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
