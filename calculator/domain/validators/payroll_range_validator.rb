# frozen_string_literal: true

require "dry/validation"

module Calculator
  module Domain
    module Validators
      class PayrollRangeValidator < ::Dry::Validation::Contract
        params do
          required(:start_date).filled(:date)
          required(:end_date).filled(:date)
        end

        rule(:end_date, :start_date) do
          key.failure("Start date must be less than end date") if values[:end_date] < values[:start_date]
        end
      end
    end
  end
end
