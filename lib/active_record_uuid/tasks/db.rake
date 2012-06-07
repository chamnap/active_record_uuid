namespace :db do
  task :update_schema do
    system "sed -i '/:primary_key => \"uuid\"/ a\
    t.string   \"uuid\",         :limit => 36,  :default => \"\",   :null => false
' db/schema.rb"
    system "sed -i 's/:primary_key => \"uuid\"/:id => false/' db/schema.rb"
  end
  
  # Append behavior to rails rake task to correct db/schema.rb, so that the test would work correctly
  Rake::Task["db:schema:dump"].enhance do
    Rake::Task["db:update_schema"].invoke
  end
  
  task :add_primary_keys => :environment do
    Dir["#{Rails.root}/app/models/**/*.rb"].each { |path| require path }
    ActiveRecord::Base.descendants.each do |model|
      next if model.abstract_class
      
      begin
        ActiveRecord::Base.connection.execute "ALTER TABLE #{model.table_name} ADD PRIMARY KEY (#{model.primary_key});"
      rescue => e
        p e
      end
    end
  end
end
