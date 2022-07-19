# frozen_string_literal: true

module Calculator
  module Application
    module UseCases
      class CalculatePayrollUseCase
        class InvalidSchemaError < StandardError; end
        class ValidationError < StandardError; end
        class NoEmployeesError < StandardError; end

        def initialize(
          calculate_payroll_schema: Calculator::Infrastructure::Schemas::CalculationPayrollSchema,
          payroll_range_validator: Calculator::Domain::Validators::PayrollRangeValidator.new,
          payroll_group_repository: Calculator::Infrastructure::Repositories::PayrollGroupRepository.new,
          employee_repository: Calculator::Infrastructure::Repositories::EmployeeRepository.new,
          incidence_repository: Calculator::Infrastructure::Repositories::IncidenceRepository.new,
          payroll_calculation_input_builder: Calculator::Application::Builders::CalculationPayrollInputBuilder.new
        )
          @calculate_payroll_schema = calculate_payroll_schema
          @payroll_range_validator = payroll_range_validator
          @payroll_group_repository = payroll_group_repository
          @employee_repository = employee_repository
          @incidence_repository = incidence_repository
          @payroll_calculation_input_builder = payroll_calculation_input_builder
        end

        def call(params) # rubocop:disable Metrics/MethodLength
          validate_inputs_agains_schema(params)
          validate_dates(params)
          payroll_group = fetch_payroll_group(params[:payroll_group_id])
          employees = fetch_employees(payroll_group.id)
          incidences = fetch_incidences(employees)
          calculation_input = build_payroll_calculation_input(payroll_group, employees, incidences)
          payroll_aggregates = calculate_payroll(calculation_input)
          payroll = persis_payroll_data(payroll_aggregates)
          result(success: true, message: "Payroll calculated successfully", object: payroll)
        rescue InvalidSchemaError, ValidationError, NoEmployeesError => e
          result(success: false, message: e.message)
        end

        private

        attr_reader :calculate_payroll_schema,
                    :payroll_group_repository,
                    :employee_repository,
                    :incidence_repository,
                    :payroll_calculation_input_builder,
                    :payroll_range_validator

        def validate_inputs_agains_schema(params)
          errors = calculate_payroll_schema.call(params).errors.to_h
          raise InvalidSchemaError, errors if errors.any?
        end

        def validate_dates(params)
          dates = params.slice(:start_date, :end_date)
          errors = payroll_range_validator.call(**dates).errors.to_h
          raise ValidationError, errors if errors.any?
        end

        def fetch_payroll_group(payroll_group_id)
          payroll_group = payroll_group_repository.find_by_id(id: payroll_group_id)
          raise ValidationError, "Payroll Group not found" if payroll_group.nil?

          payroll_group
        end

        def fetch_employees(payroll_group_id)
          employees = employee_repository.by_payroll_group_id(payroll_group_id: payroll_group_id)
          raise NoEmployeesError, "No employees found" if employees.empty?

          employees
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

        # todo
        def calculate_payroll(_input)
          payroll_object
        end

        # todo
        def persis_payroll_data(_payroll_aggregates)
          payroll_object
        end

        def result(success:, message:, object: {})
          OpenStruct.new(success?: success, message: message, object: object)
        end

        def payroll_object
          OpenStruct.new(
            id: 1,
            name: "Payroll 1",
            total_perceptions: 10_000,
            total_deductions: 3_000,
            total: 7_000
          )
        end
      end
    end
  end
end
