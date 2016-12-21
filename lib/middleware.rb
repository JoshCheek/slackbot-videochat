module Middleware
  class AddToEnv
    def initialize(app, to_add)
      @app, @to_add = app, to_add
    end
    def call(env)
      env.merge! @to_add
      @app.call(env)
    end
  end
end
