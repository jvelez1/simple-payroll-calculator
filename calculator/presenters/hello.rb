# frozen_string_literal: true

Server.route "/hello" do |r|
  r.get do
    response.status = 200
    { message: "Hello World!" }
  end
end
