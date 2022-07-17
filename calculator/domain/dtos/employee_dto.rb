# frozen_string_literal: true

require "./calculator/types"

module Calculator
  module Domain
    module DTOS
      class EmployeeDto < ::Dry::Struct
        attribute :id, Types::Strict::Integer
        attribute :name, Types::Strict::String
        attribute :last_name, Types::Strict::String
        attribute :payroll_group_id, Types::Strict::Integer
        attribute :daily_salary, Types::Strict::Float
      end
    end
  end
end
