require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      @request.params.merge!(@request.env['simpler.params'])
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      set_headers('Content-Type', 'text/html')
    end

    def set_headers(type, value)
      @response[type] = value
    end

    def status(value)
      @response.status = value
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      renderer = View.render(@request.env)
      renderer.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
      set_headers('Content-Type', 'text/plain') if template.is_a?(Hash)
    end
  end
end
