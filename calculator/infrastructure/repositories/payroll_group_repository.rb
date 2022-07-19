# frozen_string_literal: true

module Calculator
  module Infrastructure
    module Repositories
      class PayrollGroupRepository
        FILE_PATH = "./calculator/infrastructure/data/payroll_groups.json"

        def find_by_id(id:, dto: Calculator::Domain::DTOS::PayrollGroupDto)
          payroll_groups = FileRepository.load_file(FILE_PATH)
          return nil unless payroll_groups.any?

          payroll_group = payroll_groups.find { |pg| pg["id"] == id }
          dto.new(**payroll_group.transform_keys(&:to_sym)) if payroll_group
        end
      end
    end
  end
end
