# frozen_string_literal: true

require "byebug"

module Calculator
  class CalculatePayrollUseCase
    def initialize(
      calculate_payroll_schema: Calculator::Infrastructure::Schemas::CALCULATE_PAYROLL_SCHEMA
    )
      @calculate_payroll_schema = calculate_payroll_schema
    end

    def call(request_params)
      message = validate_input_params(request_params)
      return result(success: false, message: message) if message.any?

      result(success: true, message: "")
    end

    private

    attr_reader :calculate_payroll_schema

    # Validate the input data agains schema validator
    def validate_input_params(payload)
      JSON::Validator.fully_validate(
        calculate_payroll_schema,
        payload,
        errors_as_objects: true,
        strict: true
      )
    end

    # Fetch required data for payroll calculation.
    def fetch_payroll_data(input); end

    # validate payroll data.
    def validate_payroll_data(input); end

    # Build payroll inital data structure to be calculated
    def build_payroll_calculation_input(input); end

    # Calculate payroll.
    def calculate_payroll(input); end

    # Process payroll result.
    def persis_payroll_data(output); end

    def result(success:, message:)
      OpenStruct.new(success?: success, message: message)
    end
  end
end
