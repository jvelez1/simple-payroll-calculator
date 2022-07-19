# frozen_string_literal: true

require "dry-container"
require "dry-auto_inject"

module Calculator
  module Infrastructure
    module DependencyInjections
      class CalculatePayrollContainer
        extend Dry::Container::Mixin

        register(:employee_repository) do
          Calculator::Infrastructure::Repositories::EmployeeRepository.new
        end
        register(:payroll_group_repository) do
          Calculator::Infrastructure::Repositories::PayrollGroupRepository.new
        end
        register(:incidence_repository) do
          Calculator::Infrastructure::Repositories::IncidenceRepository.new
        end
        register("operations.payroll_range_validator") do
          Calculator::Domain::Validators::PayrollRangeValidator.new
        end
        register("operations.payroll_calculation_input_builder") do
          Calculator::Application::Builders::CalculationPayrollInputBuilder.new
        end
        register("operations.calculate_payroll_schema_validator") do
          Calculator::Infrastructure::Schemas::CalculationPayrollSchema
        end
      end

      CalculatePayrollDeps = Dry::AutoInject(
        Calculator::Infrastructure::DependencyInjections::CalculatePayrollContainer
      )
    end
  end
end
