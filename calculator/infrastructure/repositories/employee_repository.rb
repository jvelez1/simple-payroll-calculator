# frozen_string_literal: true

module Calculator
  module Infrastructure
    module Repositories
      class EmployeeRepository
        FILE_PATH = "./calculator/infrastructure/data/employees.json"

        def by_payroll_group_id(payroll_group_id)
          employees = FileRepository.load_file(FILE_PATH)
          employees.select { |employee| employee["payroll_group_id"] == payroll_group_id }
        end
      end
    end
  end
end
