# frozen_string_literal: true

module Calculator
  module Domain
    module DTOS
      class IncidenceDto
        attr_accessor :id, :type, :start_date, :end_date, :employee_id

        def initialize(id:, type:, start_date:, end_date:, employee_id:)
          @id = id
          @type = type
          @start_date = start_date
          @end_date = end_date
          @employee_id = employee_id
        end

        def to_h
          {
            id: id,
            type: type,
            start_date: start_date,
            end_date: end_date,
            employee_id: employee_id
          }
        end
      end
    end
  end
end
