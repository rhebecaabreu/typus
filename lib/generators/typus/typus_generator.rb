require 'rails/generators/migration'

class TypusGenerator < Rails::Generators::Base

  include Rails::Generators::Migration

  class_option :app_name, :default => Rails.root.basename
  class_option :user_class_name, :default => "TypusUser"
  class_option :user_fk, :default => "typus_user_id"

  def self.source_root
    @source_root ||= File.join(Typus.root, "generators", "typus", "templates")
  end

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def generate_configuration_files
    %w( README typus.yml typus_roles.yml ).each do |file|
      from = to = "config/typus/#{file}"
      template from, to
    end
  end

  def copy_initializer_file
    template "initializer.rb", "config/initializers/typus.rb"
  end

  def copy_assets
    Dir["#{templates_path}/public/**/*.*"].each do |file|
      copy_file file.split("#{templates_path}/").last
    end
  end

  def copy_migration_template
    migration_template "migration.rb", "db/migrate/create_#{table_name}"
  end

  def add_typus_routes
    route "Typus::Routes.draw(map)"
  end

  private

  def templates_path
    File.join(Typus.root, "generators", "typus", "templates")
  end

  def table_name
    options[:user_class_name].tableize
  end

  def migration_name
    "Create#{options[:user_class_name]}s"
  end

end
