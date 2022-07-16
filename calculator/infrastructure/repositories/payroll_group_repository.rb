# frozen_string_literal: true

require "byebug"

module Calculator
  module Infrastructure
    module Repositories
      class PayrollGroupRepository
        FILE_PATH = "./calculator/infrastructure/data/payroll_groups.json"

        def find_by_id(payroll_group_id)
          payroll_groups = FileRepository.load_file(FILE_PATH)
          if payroll_groups.any?
            payroll_groups.select { |payroll_group| payroll_group["id"] == payroll_group_id } 
          end
        end
      end
    end
  end
end
