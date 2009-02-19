gem 'fiveruns-dash-ruby'
require 'fiveruns/dash'

require 'fiveruns/dash/recipes/activerecord'

module Fiveruns::Dash::ActiveRecord
      
  CLASS_METHODS = %w(
    find find_by_sql 
    create create! 
    update_all 
    destroy destroy_all 
    delete delete_all
    calculate
  )      
  INSTANCE_METHODS = %w(
    update
    save save!
    destroy
  )

  TARGETS = CLASS_METHODS.map { |m| "ActiveRecord::Base.#{m}" } + \
            INSTANCE_METHODS.map { |m| "ActiveRecord::Base##{m}"}

end