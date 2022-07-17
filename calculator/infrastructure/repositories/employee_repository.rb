# frozen_string_literal: true

module Calculator
  module Infrastructure
    module Repositories
      class EmployeeRepository
        FILE_PATH = "./calculator/infrastructure/data/employees.json"

        def by_payroll_group_id(
          payroll_group_id:,
          dto: Calculator::Domain::DTOS::EmployeeDto
        )
          employees = FileRepository.load_file(FILE_PATH)
          employees = employees.select { |employee| employee["payroll_group_id"] == payroll_group_id } if employees.any?
          return [] unless employees.any?

          employees.map { |employee| dto.new(**employee.transform_keys(&:to_sym)) }
        end
      end
    end
  end
end
