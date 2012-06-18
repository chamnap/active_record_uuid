namespace :db do
  task :add_primary_keys => :environment do
    Dir["#{Rails.root}/app/models/**/*.rb"].each { |path| require path }
    ActiveRecord::Base.descendants.each do |model|
      next if model.abstract_class
      
      add_primary_key(model.table_name, model.primary_key)
    end
  end
  
  task :add_primary_key, [:model_name] => :environment do |t, args|
    model = Object.const_get(args.model_name)
    
    add_primary_key(model.table_name, model.primary_key)
  end
  
  private
  def add_primary_key(table_name, primary_key)
    begin
      ActiveRecord::Base.connection.execute "ALTER TABLE #{table_name} ADD PRIMARY KEY (#{primary_key});"
    rescue => e
      p e
    end
  end
end
