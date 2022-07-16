# frozen_string_literal: true

module Calculator
  module Infrastructure
    module Repositories
      class IncidenceRepository
        FILE_PATH = "./calculator/infrastructure/data/incidences.json"

        def where(filters)
          incidences = FileRepository.load_file(FILE_PATH)
          if filters[:employee_ids].any?
            incidences = incidences.select { |incidence| filters[:employee_ids].include?(incidence["employee_id"]) }
          end
          incidences
        end
      end
    end
  end
end
