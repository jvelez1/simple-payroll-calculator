# frozen_string_literal: true

module Calculator
  module Application
    module DTOS
      class CalculatePayrollInputDto
        attr_accessor :payroll_group, :employees

        def initialize(payroll_group:, employees:)
          @payroll_group = payroll_group
          @employees = employees
        end

        def to_h
          {
            payroll_group: payroll_group.to_h,
            employees: employees.map(&:to_h)
          }
        end
      end
    end
  end
end
