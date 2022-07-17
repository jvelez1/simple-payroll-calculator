# frozen_string_literal: true

module Calculator
  module Domain
    module Validators
      class PayrollRangeValidator
        def call(start_date:, end_date:)
          return if Date.parse(start_date) <= Date.parse(end_date)

          "Start date must be less than end date"
        end
      end
    end
  end
end
