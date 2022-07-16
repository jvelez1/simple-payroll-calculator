# frozen_string_literal: true

Server.route "/calculate" do |r|
  r.post do
    request_params = JSON.parse(r.body.read)

    if ::Calculator::CalculatePayrollUseCase.new.call(request_params)
      response.status = 200
      { message: "Calculated" }
    else
      response.status = 400
      { message: "Some error here" }
    end
  end
end
