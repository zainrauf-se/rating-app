require 'json'
require_relative '../json_api'
RSpec.describe JsonApi do

  let(:app) { JsonApi.new }

  describe '#add_feedback' do
    context 'with valid parameters' do
      let(:valid_params) { { user_id: 1, post_id: 1, comment: 'Great post!', owner_id: 2 } }

      it 'creates a new feedback and returns status 201' do
        env = { 'PATH_INFO' => '/add_feedback', 'REQUEST_METHOD' => 'POST', 'rack.input' => StringIO.new(valid_params.to_json) }
        status, headers, body = app.call(env)

        expect(status).to eq(201)
        expect(headers['Content-Type']).to eq('application/json')

        response_body = JSON.parse(body.first)
        expect(response_body['comment']).to eq(valid_params[:comment])
        expect(response_body['user_id']).to eq(valid_params[:user_id])
        expect(response_body['post_id']).to eq(valid_params[:post_id])
        expect(response_body['owner_id']).to eq(valid_params[:owner_id])
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user_id: nil, post_id: 1, comment: '', owner_id: 2 } }

      it 'returns status 422 and error messages' do
        env = { 'PATH_INFO' => '/add_feedback', 'REQUEST_METHOD' => 'POST', 'rack.input' => StringIO.new(invalid_params.to_json) }
        status, headers, body = app.call(env)

        expect(status).to eq(422)
        expect(headers['Content-Type']).to eq('application/json')

        response_body = JSON.parse(body.first)
        expect(response_body).to have_key('errors')
        expect(response_body['errors']).to include("Comment can't be blank")
      end
    end
  end
end