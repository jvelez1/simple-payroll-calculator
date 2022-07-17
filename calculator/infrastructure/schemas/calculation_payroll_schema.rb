# frozen_string_literal: true

require "json-schema"
require "byebug"

module Calculator
  module Infrastructure
    module Schemas
      class CalculationPayrollSchema
        CALCULATE_PAYROLL_SCHEMA = {
          "type" => "object",
          "required" => %w[payroll_group_id start_date end_date],
          "properties" => {
            "payroll_group_id" => { "type" => "integer" },
            "start_date" => { "type" => "string" },
            "end_date" => { "type" => "string" }
          }
        }.freeze

        def schema
          CALCULATE_PAYROLL_SCHEMA
        end

        private_constant :CALCULATE_PAYROLL_SCHEMA
      end
    end
  end
end
