require 'rails/generators/named_base'
require 'rails/generators/active_record'
require 'forwardable'

module ClosureTree
  module Generators # :nodoc:
    class MigrationGenerator < ::Rails::Generators::NamedBase # :nodoc:
      include ActiveRecord::Generators::Migration
      extend Forwardable
      def_delegators :ct, :hierarchy_table_name, :primary_key_type

      def self.default_generator_root
        File.dirname(__FILE__)
      end

      def create_migration_file
        migration_template 'create_hierarchies_table.rb.erb', "db/migrate/create_#{ct.hierarchy_table_name}.rb"
      end

      def migration_class_name
        "Create#{ct.hierarchy_table_name.camelize}"
      end

      def target_class
        @target_class ||= class_name.constantize
      end

      def ct
        @ct ||= if target_class.respond_to?(:_ct)
          target_class._ct
        else
          fail "Please RTFM and add the `has_closure_tree` (or `acts_as_tree`) annotation to #{class_name} before creating the migration."
        end
      end
    end
  end
end
