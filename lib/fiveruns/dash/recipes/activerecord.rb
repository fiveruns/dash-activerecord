require 'fiveruns/dash'

module Fiveruns::Dash
  module Recipes
    module ActiveRecord
      
      def self.all_methods
        methods_for_class.map { |m| "ActiveRecord::Base.#{m}" } + \
        methods_for_instance.map { |m| "ActiveRecord::Base##{m}"}
      end
      
      def self.methods_for_class
        %w(find find_by_sql calculate create create! update_all destroy destroy_all delete delete_all)
      end
      
      def self.methods_for_instance
        %w(update save save! destroy)
      end
      
    end
  end
end

Fiveruns::Dash.register_recipe :activerecord, :url => 'http://dash.fiveruns.com' do |recipe|
  
  # We need a way to get the total time for a request/operation so that we can
  # calculate the relative percentage used by AR/DB.  Default to "response_time" 
  # but daemons can set this constant to provide their own total time metric.
  total_time = recipe.options[:ar_total_time] ? recipe.options[:ar_total_time] : "response_time"

  recipe.time :ar_time, 'ActiveRecord Time', :methods => Fiveruns::Dash::Recipes::ActiveRecord.all_methods, :reentrant => true, :only_within => total_time
  recipe.time :db_time, 'Database Time', :methods => %w(ActiveRecord::ConnectionAdapters::AbstractAdapter#log), :only_within => total_time

  recipe.percentage :ar_util, 'ActiveRecord Utilization', :sources => ["ar_time", total_time] do |ar_time, all_time|
    all_time == 0 ? 0 : (ar_time / all_time) * 100.0
  end
  recipe.percentage :db_util, 'Database Utilization', :sources => ["db_time", total_time] do |db_time, all_time|
    all_time == 0 ? 0 : (db_time / all_time) * 100.0
  end

end
