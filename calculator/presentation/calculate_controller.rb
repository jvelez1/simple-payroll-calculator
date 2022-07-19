# frozen_string_literal: true

Server.route "/calculate" do |r|
  r.post do
    request_params = JSON.parse(r.body.read)
    calculator_response = Calculator::Application::UseCases::CalculatePayrollUseCase.new.call(
      request_params.transform_keys(&:to_sym)
    )
    response.status = calculator_response.success? ? 200 : 422
    { message: calculator_response.message, object: calculator_response.object.to_h }.compact.to_json
  end
end
