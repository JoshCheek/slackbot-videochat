class AddTimestamp
  def initialize(app, time_class)
    @app, @time_class = app, time_class
  end

  def call(env)
    env[:timestamp] = @time_class.now
    @app.call(env)
  end
end
