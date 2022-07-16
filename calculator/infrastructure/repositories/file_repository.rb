# frozen_string_literal: true

require "json"

module Calculator
  module Infrastructure
    module Repositories
      module FileRepository
        def load_file(path)
          file = File.read(path)
          JSON.parse(file)
        rescue StandardError => _e
          {}
        end

        module_function :load_file
      end
    end
  end
end
