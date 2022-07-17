# frozen_string_literal: true

require "./calculator/types"

module Calculator
  module Domain
    module DTOS
      class PayrollGroupDto < ::Dry::Struct
        attribute :id, Types::Strict::Integer
        attribute :name, Types::Strict::String
        attribute :frequency, Types::Strict::String
      end
    end
  end
end
