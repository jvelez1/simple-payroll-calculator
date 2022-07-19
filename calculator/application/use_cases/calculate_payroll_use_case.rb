# frozen_string_literal: true

require "dry/monads"
require "dry/monads/list"
require "./calculator/infrastructure/dependency_injections/container"

module Calculator
  module Application
    module UseCases
      class CalculatePayrollUseCase
        include Dry::Monads[:result, :do]
        M = Dry::Monads
        include Calculator::Infrastructure::DependencyInjections::CalculatePayrollDeps[
          input_payroll_schema_validator: "operations.calculate_payroll_schema_validator",
          payroll_range_validator: "operations.payroll_range_validator",
          payroll_calculation_input_builder: "operations.payroll_calculation_input_builder",
          employee_repository: "employee_repository",
          payroll_group_repository: "payroll_group_repository",
          incidence_repository: "incidence_repository"
        ]

        def call(params) # rubocop:disable Metrics/AbcSize
          yield validate_inputs_against_schema(params)
          yield validate_dates(params)
          payroll_group = yield fetch_payroll_group(params[:payroll_group_id])
          employees = yield fetch_employees(payroll_group.id)
          incidences = yield fetch_incidences(employees)
          calculation_input = yield build_payroll_calculation_input(payroll_group, employees, incidences)
          payroll_aggregates = yield calculate_payroll(calculation_input)
          payroll = yield persis_payroll_data(payroll_aggregates)
          Success(payroll)
        end

        private

        def validate_inputs_against_schema(params)
          errors = input_payroll_schema_validator.call(params).errors.to_h
          errors.any? ? Failure(errors) : Success()
        end

        def validate_dates(params)
          dates = params.slice(:start_date, :end_date)
          errors = payroll_range_validator.call(**dates).errors.to_h
          errors.any? ? Failure(errors) : Success()
        end

        def fetch_payroll_group(payroll_group_id)
          payroll_group = payroll_group_repository.find_by_id(id: payroll_group_id)
          return Failure(payroll_group_not_found: "Payroll Group not found") if payroll_group.nil?

          Success(payroll_group)
        end

        def fetch_employees(payroll_group_id)
          employees = employee_repository.by_payroll_group_id(payroll_group_id: payroll_group_id)
          return Failure(employees_not_found: "Employees not found") if employees.empty?

          traverse_result(employees)
        end

        def fetch_incidences(employees)
          incidences = incidence_repository.where(
            filters: { employee_ids: employees.value.map(&:id) }
          )
          traverse_result(incidences)
        end

        def build_payroll_calculation_input(payroll_group, employees, incidences)
          input = payroll_calculation_input_builder.build(
            payroll_group: payroll_group,
            employees: employees.value,
            incidences: incidences.value
          )
          Success(input)
        end

        # todo
        def calculate_payroll(_input)
          Success(payroll_object)
        end

        # todo
        def persis_payroll_data(_payroll_aggregates)
          Success(payroll_object)
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

        def traverse_result(elements)
          M::List[*elements].fmap { |x| M::Success(x) }.typed(M::Result).traverse
        end
      end
    end
  end
end
