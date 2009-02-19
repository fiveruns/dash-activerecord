require File.dirname(__FILE__) << "/test_helper"

Fiveruns::Dash.logger.level = Logger::FATAL

class ActiverecordTest < Test::Unit::TestCase

  class TestModel < ActiveRecord::Base
  end

  class TestEngine
    def doit
      sleep 1
      2.times do
        t = TestModel.create!(:name => 'foo')
        t.destroy
      end
    end

    def conn
      TestModel.connection.execute("select sleep(1)")
    end

    def entry(meth)
      send(meth)
    end
  end
  

  context "Metric" do
    
    setup do
      ActiveRecord::Base.configurations = { 'test' => { 'database' => 'test', 'adapter' => 'mysql', 'user' => 'root', 'hostname' => 'localhost' }}
      ActiveRecord::Base.establish_connection('test')
      ActiveRecord::Base.connection.execute("create table if not exists test_models (id integer PRIMARY KEY, name varchar(32) not null)")
      ActiveRecord::Base.connection.execute("delete from test_models")
    end

    should "collect basic AR metrics" do
      ar_scenario do
        TestEngine.new.entry(:doit)

        data = Fiveruns::Dash.session.data
        # data.each do |hsh|
        #   puts "#{hsh[:name]}: #{hsh[:values].inspect}"
        # end

        assert metric('test_time', data) > 1.0
        assert metric('ar_util', data) > metric('db_util', data)
        assert metric('db_util', data) < 5
      end
    end

    should "collect DB metrics" do
      ar_scenario do
        TestEngine.new.entry(:conn)
        
        data = Fiveruns::Dash.session.data
        # data.each do |hsh|
        #   puts "#{hsh[:name]}: #{hsh[:values].inspect}"
        # end

        assert metric('test_time', data) > 1.0
        assert metric('test_time', data) < 1.1
        assert metric('db_time', data) > 1.0
        assert metric('db_time', data) < 1.1
        assert metric('db_util', data) > 90.0
        assert metric('db_util', data) < 100.0
      end
    end
  end

  def ar_scenario(&block)
    child = fork do
      mock_activerecord!
      yield
    end
    Process.wait
    assert_equal 0, $?.exitstatus
  end

  def metric(metric, data, context=[])
    hash = data.detect { |hash| hash[:name] == metric }
    assert hash, "No metric named #{metric} was found in metrics payload"
    vals = hash[:values]
    assert vals, "No values found for #{metric} in metrics payload"
    val = vals.detect { |val| val[:context] == context }
    assert val, "No value for #{metric} found for context #{context.inspect}"
    val[:value]
  end

  def mock_activerecord!
    
    eval <<-MOCK
      module Fiveruns::Dash
        class Reporter
          private
          def run
          end
        end
      end
    MOCK

    Fiveruns::Dash.register_recipe :tester, :url => 'http://dash.fiveruns.com' do |recipe|
      recipe.time :test_time, 'Test Time', :method => 'ActiverecordTest::TestEngine#entry',
                                           :mark => true
    end
    
    Fiveruns::Dash.start :app => '666' do |config|
      config.add_recipe :ruby
      config.add_recipe :tester
      config.add_recipe :activerecord, :total_time => 'test_time'
    end
    
  end
end