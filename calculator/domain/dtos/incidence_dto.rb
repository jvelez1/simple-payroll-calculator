# frozen_string_literal: true

require "./calculator/types"

module Calculator
  module Domain
    module DTOS
      class IncidenceDto < ::Dry::Struct
        attribute :id, Types::Strict::Integer
        attribute :type, Types::Strict::String
        attribute :start_date, Types::Nominal::Date
        attribute :end_date, Types::Nominal::Date
        attribute :employee_id, Types::Strict::Integer
      end
    end
  end
end
