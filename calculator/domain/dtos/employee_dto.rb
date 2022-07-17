# frozen_string_literal: true

module Calculator
  module Domain
    module DTOS
      class EmployeeDto
        attr_accessor :id, :name, :last_name, :payroll_group_id, :daily_salary

        def initialize(id:, name:, last_name:, payroll_group_id:, daily_salary:)
          @id = id
          @name = name
          @last_name = last_name
          @payroll_group_id = payroll_group_id
          @daily_salary = daily_salary
        end

        def to_h
          {
            id: id,
            name: name,
            last_name: last_name,
            payroll_group_id: payroll_group_id,
            daily_salary: daily_salary
          }
        end
      end
    end
  end
end
