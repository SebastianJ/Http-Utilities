module HttpUtilities
  module Generators
    class InstallGenerator < Rails::Generators::Base
      namespace "http_utilities"
      
      source_root File.expand_path("../../templates", __FILE__)

      hook_for :orm
      class_option :orm
      
      desc "Copies an initializer, a .yml-file containing user-agents as well as a proxy model."
      
      def copy_initializer
        template "http_utilities.rb", "config/initializers/http_utilities.rb"
      end
      
      def copy_user_agents
        template "user_agents.yml", "config/http_utilities/user_agents.yml"
      end
      
    end
  end
end