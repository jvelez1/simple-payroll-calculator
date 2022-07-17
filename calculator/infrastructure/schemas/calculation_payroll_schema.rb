# frozen_string_literal: true

require "dry/schema"

module Calculator
  module Infrastructure
    module Schemas
      CalculationPayrollSchema = Dry::Schema.Params do
        required(:payroll_group_id).filled(:integer)
        required(:start_date).filled(:date)
        required(:end_date).filled(:date)
      end
    end
  end
end
