class AddKeys
  def initialize(app, keys)
    @app  = app
    @keys = keys
  end

  def call(env)
    env[:keys] = @keys
    @app.call(env)
  end
end
