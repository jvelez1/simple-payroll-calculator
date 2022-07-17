# frozen_string_literal: true

module Calculator
  module Application
    module Builders
      class CalculationPayrollInputBuilder
        def initialize(dto: Calculator::Application::DTOS::CalculatePayrollInputDto)
          @dto = dto
        end

        def build(payroll_group:, employees:, incidences:) # rubocop:disable Metrics/MethodLength
          grouped_incidences = incidences.group_by(&:employee_id)
          employees_with_incidences = employees.map do |employee|
            {
              employee: employee,
              incidences: grouped_incidences[employee.id] || []
            }
          end
          dto.new(
            payroll_group: payroll_group,
            employees: employees_with_incidences
          )
        end

        private

        attr_reader :dto
      end
    end
  end
end
