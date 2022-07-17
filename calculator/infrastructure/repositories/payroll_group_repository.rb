# frozen_string_literal: true

require "byebug"

module Calculator
  module Infrastructure
    module Repositories
      class PayrollGroupRepository
        FILE_PATH = "./calculator/infrastructure/data/payroll_groups.json"

        def find_by_id(id:, dto: Calculator::Domain::DTOS::PayrollGroupDto)
          payroll_groups = FileRepository.load_file(FILE_PATH)
          return nil unless payroll_groups.any?

          payroll_groups = payroll_groups.select { |payroll_group| payroll_group["id"] == id }
          payroll_groups.map { |payroll_group| dto.new(**payroll_group.transform_keys(&:to_sym)) }
        end
      end
    end
  end
end
