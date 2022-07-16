# frozen_string_literal: true

require "roda"
require "multi_json"

#
# This is the main class of the server.
# It is responsible for handling the routes from different files.
#
class Server < Roda
  plugin :error_handler
  plugin :shared_vars
  plugin :multi_route
  plugin :status_handler
  plugin :request_headers
  plugin :caching
  plugin :json, serializer: ->(o) { MultiJson.dump(o) }
  plugin :json_parser, parser: ->(o) { MultiJson.load(o, symbolize_keys: true) }

  # Enabling routes to be used as separate files
  route(&:multi_route)

  require "./calculator/presentation/calculate_controller"

  status_handler 404 do
    { code: "404", message: "Route not found" }
  end

  status_handler 500 do
    { code: "500", message: "An error occured." }
  end
end
