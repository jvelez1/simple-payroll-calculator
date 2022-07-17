# frozen_string_literal: true

Server.route "/calculate" do |r|
  r.post do
    request_params = JSON.parse(r.body.read)
    response = Calculator::Application::UseCases::CalculatePayrollUseCase.new.call(
      request_params.transform_keys(&:to_sym)
    )
    if response.success?
      response.status = 200
      { message: "Calculated" }
    else
      response.status = 400
      { message: response.message }
    end
  end
end
