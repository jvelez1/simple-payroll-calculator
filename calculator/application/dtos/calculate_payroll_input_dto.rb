# frozen_string_literal: true

require "./calculator/types"
require "./calculator/domain/dtos/employee_dto"
require "./calculator/domain/dtos/incidence_dto"
require "./calculator/domain/dtos/payroll_group_dto"

module Calculator
  module Application
    module DTOS
      class EmployeeWithIncidencesDto < ::Calculator::Domain::DTOS::EmployeeDto
        attribute :incidences, Types::Array.of(::Calculator::Domain::DTOS::IncidenceDto)
      end

      class CalculatePayrollInputDto < ::Dry::Struct
        attribute :payroll_group, Calculator::Domain::DTOS::PayrollGroupDto
        attribute :employees, Types::Array.of(EmployeeWithIncidencesDto).constrained(filled: true)
      end
    end
  end
end
