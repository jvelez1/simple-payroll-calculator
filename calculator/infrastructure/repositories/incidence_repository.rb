# frozen_string_literal: true

module Calculator
  module Infrastructure
    module Repositories
      class IncidenceRepository
        FILE_PATH = "./calculator/infrastructure/data/incidences.json"

        def where(filters:, dto: Calculator::Domain::DTOS::IncidenceDto)
          incidences = FileRepository.load_file(FILE_PATH)
          return [] unless incidences.any?

          if filters[:employee_ids].any?
            incidences = incidences.select { |incidence| filters[:employee_ids].include?(incidence["employee_id"]) }
          end
          incidences.map { |incidence| dto.new(**incidence.transform_keys(&:to_sym)) }
        end
      end
    end
  end
end
