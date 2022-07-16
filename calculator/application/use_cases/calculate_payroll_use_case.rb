# frozen_string_literal: true

require "byebug"

module Calculator
  module Application
    module UseCases
      class CalculatePayrollUseCase
        def initialize(
          calculate_payroll_schema: Calculator::Infrastructure::Schemas::CALCULATE_PAYROLL_SCHEMA,
          payroll_group_repository: Calculator::Infrastructure::Repositories::PayrollGroupRepository.new,
          employee_repository: Calculator::Infrastructure::Repositories::EmployeeRepository.new,
          incidence_repository: Calculator::Infrastructure::Repositories::IncidenceRepository.new
        )
          @calculate_payroll_schema = calculate_payroll_schema
          @payroll_group_repository = payroll_group_repository
          @employee_repository = employee_repository
          @incidence_repository = incidence_repository
        end

        def call(request_params)
          message = validate_input_params(request_params)
          return result(success: false, message: message) if message.any?

          payroll_group_id = request_params["payroll_group_id"]
          payroll_group = fetch_payroll_group(payroll_group_id)
          return result(success: false, message: "Invalid Payroll Group") if payroll_group.empty?

          employees = fetch_employees(payroll_group_id)
          return result(success: false, message: "No employees") if employees.empty?

          _incidences = fetch_incidences(employees)
          result(success: true, message: "")
        end

        private

        attr_reader :calculate_payroll_schema,
                    :payroll_group_repository,
                    :employee_repository,
                    :incidence_repository

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
        def fetch_payroll_group(payroll_group_id)
          payroll_group_repository.find_by_id(payroll_group_id)
        end

        def fetch_employees(payroll_group_id)
          employee_repository.by_payroll_group_id(payroll_group_id)
        end

        def fetch_incidences(employees)
          incidence_repository.where(
            employee_ids: employees.map { |employee| employee["id"] }
          )
        end

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
  end
end
