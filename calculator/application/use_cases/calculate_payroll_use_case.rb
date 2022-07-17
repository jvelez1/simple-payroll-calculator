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
          incidence_repository: Calculator::Infrastructure::Repositories::IncidenceRepository.new,
          payroll_calculation_input_builder: Calculator::Application::Builders::CalculationPayrollInputBuilder.new
        )
          @calculate_payroll_schema = calculate_payroll_schema
          @payroll_group_repository = payroll_group_repository
          @employee_repository = employee_repository
          @incidence_repository = incidence_repository
          @payroll_calculation_input_builder = payroll_calculation_input_builder
        end

        def call(request_params) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          message = validate_input_params(request_params)
          return result(success: false, message: message) if message.any?

          payroll_group_id = request_params["payroll_group_id"]
          payroll_group = fetch_payroll_group(payroll_group_id)
          return result(success: false, message: "Invalid Payroll Group") unless payroll_group

          employees = fetch_employees(payroll_group_id)
          return result(success: false, message: "No employees") if employees.empty?

          incidences = fetch_incidences(employees)
          calculation_input = build_payroll_calculation_input(payroll_group, employees, incidences)
          payroll_aggregates = calculate_payroll(calculation_input)
          if persis_payroll_data(payroll_aggregates)
            result(success: true, message: "Payroll calculated successfully")
          else
            result(success: false, message: "Error calculating payroll")
          end
        end

        private

        attr_reader :calculate_payroll_schema,
                    :payroll_group_repository,
                    :employee_repository,
                    :incidence_repository,
                    :payroll_calculation_input_builder

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
          payroll_group_repository.find_by_id(id: payroll_group_id)
        end

        def fetch_employees(payroll_group_id)
          employee_repository.by_payroll_group_id(payroll_group_id: payroll_group_id)
        end

        def fetch_incidences(employees)
          incidence_repository.where(
            filters: { employee_ids: employees.map(&:id) }
          )
        end

        def build_payroll_calculation_input(payroll_group, employees, incidences)
          payroll_calculation_input_builder.build(
            payroll_group: payroll_group,
            employees: employees,
            incidences: incidences
          )
        end

        # Calculate payroll.
        def calculate_payroll(_input)
          true
        end

        # Process payroll result.
        def persis_payroll_data(_payroll_aggregates)
          true
        end

        def result(success:, message:)
          OpenStruct.new(success?: success, message: message)
        end
      end
    end
  end
end
