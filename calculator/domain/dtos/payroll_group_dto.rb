# frozen_string_literal: true

module Calculator
  module Domain
    module DTOS
      class PayrollGroupDto
        attr_accessor :id, :name, :frequency

        def initialize(id:, name:, frequency:)
          @id = id
          @name = name
          @frequency = frequency
        end

        def to_h
          {
            id: id,
            name: name,
            frequency: frequency
          }
        end
      end
    end
  end
end
