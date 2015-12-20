module ReverbRecords
  class App
    def initialize
      @filenames = ['', '.html', 'index.html', '/index.html']
      @rack_static = ::Rack::Static.new(
        lambda { [404, {}, []] },
        root: File.expand_path('../../public', __FILE__),
        urls: ['/']
      )
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        run ReverbRecords::App.new
      end.to_app
    end

    def call(env)
      # Give the API first crack at the request
      response = ReverbRecords::API.call(env)

      # Have Rack check the request if the API passes on it
      if response[1]['X-Cascade'] == 'pass'
        request_path = env['PATH_INFO']
        @filenames.each do |path|
          response = @rack_static.call(env.merge('PATH_INFO' => request_path + path))
          return response if response[0] != 404
        end
      end

      # Serve error pages or respond with API response
      case response[0]
      when 404, 500, 405
        content = @rack_static.call(env.merge('PATH_INFO' => "/errors/#{response[0]}.html"))
        [response[0], content[1], content[2]]
      else
        response
      end
    end
  end
end
