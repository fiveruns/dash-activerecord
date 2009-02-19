Fiveruns::Dash.register_recipe :activerecord, :url => 'http://dash.fiveruns.com' do |recipe|

  recipe.time :db_time, 'Database Time', :methods => %w(ActiveRecord::ConnectionAdapters::AbstractAdapter#log)  
  recipe.time :ar_time, 'ActiveRecord Time', :methods => Fiveruns::Dash::ActiveRecord::TARGETS,
                                             :reentrant => true
  recipe.added do |settings|

    # We need a way to get the total time for a request/operation so that we can
    # calculate the relative percentage used by AR/DB.    
    if settings[:total_time]
      
      total_time = settings[:total_time].to_s

      Fiveruns::Dash.logger.debug "Set FiveRuns Dash `activerecord' :total_time setting to #{total_time}"
      # Limit timing
      recipe.metrics.each do |metric|
        if %w(db_time ar_time).include?(metric.name) && metric.recipe.url == 'http://dash.fiveruns.com'
          metric.options[:only_within] = total_time
        end
      end

      recipe.percentage :ar_util, 'ActiveRecord Utilization', :sources => ["ar_time", total_time] do |ar_time, all_time|
        all_time == 0 ? 0 : (ar_time / all_time) * 100.0
      end
      recipe.percentage :db_util, 'Database Utilization', :sources => ["db_time", total_time] do |db_time, all_time|
        all_time == 0 ? 0 : (db_time / all_time) * 100.0
      end
    
    else
      
      Fiveruns::Dash.logger.error [
        "Could not add some metrics from the FiveRuns Dash `activerecord' recipe to the configuration;",
        "Please provide a :total_time metric name setting when adding the recipe.",
        "For more information, see the fiveruns-dash-activerecord README"
      ].join("\n")
      
    end
    
  end

end
