
require 'json'
require_relative '../json_api'
RSpec.describe JsonApi do
  let(:app) { JsonApi.new }

  describe '#create_post' do
    context 'with valid parameters' do
      let(:valid_params) { { email: 'test@example.com', title: 'Test Post', content: 'Test Content' } }

      it 'creates a new post and returns status 201' do
        env = { 'PATH_INFO' => '/create_post', 'REQUEST_METHOD' => 'POST', 'rack.input' => StringIO.new(valid_params.to_json) }
        status, headers, body = app.call(env)

        expect(status).to eq(201)
        expect(headers['Content-Type']).to eq('application/json')

        response_body = JSON.parse(body.first)
        expect(response_body['title']).to eq(valid_params[:title])
        expect(response_body['content']).to eq(valid_params[:content])
        expect(response_body['author_login']).to eq(valid_params[:email])
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { email: 'test@example.com', title: '', content: 'Test Content' } }

      it 'returns status 422 and error messages' do
        env = { 'PATH_INFO' => '/create_post', 'REQUEST_METHOD' => 'POST', 'rack.input' => StringIO.new(invalid_params.to_json) }
        status, headers, body = app.call(env)

        expect(status).to eq(422)
        expect(headers['Content-Type']).to eq('application/json')

        response_body = JSON.parse(body.first)
        expect(response_body).to have_key('errors')
        expect(response_body['errors']).to include("Title can't be blank")
      end
    end
  end
end
