# frozen_string_literal: true

Server.route "/calculate" do |r|
  r.post do
    request_params = JSON.parse(r.body.read)
    calculator_response = Calculator::Application::UseCases::CalculatePayrollUseCase.new.call(
      request_params.transform_keys(&:to_sym)
    )

    if calculator_response.success?
      response.status = 200
      { payroll: calculator_response.value!.to_h }.to_json
    else
      response.status = 400
      { errors: calculator_response.failure.to_h }.to_json
    end
  end
end
