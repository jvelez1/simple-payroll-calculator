# frozen_string_literal: true

module Calculator
  #
  # This is the main class of the calculator.
  # It is responsible for calculating a payroll.
  #
  class CalculatePayrollUseCase
    def initialize; end

    def call(_request_params)
      true
    end

    private

    # Validate the input data agains schema validator
    def validate_input_params(request_params); end

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
  end
end
