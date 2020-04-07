require 'helper'

describe Twitter::REST::AccountActivity do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  context 'with enterpise API' do
    before do
      @client.enterprise_api = true
    end

    describe '#create_webhook' do
      context 'with a webhook url passed' do
        before do
          stub_post('/1.1/account_activity/webhooks.json').with(body: {url: 'url'}).to_return(body: fixture('account_activity_create_webhook.json'), headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request create webhook' do
          @client.create_webhook('url')
          expect(a_post('/1.1/account_activity/webhooks.json').with(body: {url: 'url'})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.create_webhook('url')
          expect(response).to be_a Hash
          expect(response[:id]).to eq('1234567890')
        end
      end
    end

    describe '#list_webhooks' do
      context 'list webhooks' do
        before do
          stub_get('/1.1/account_activity/webhooks.json').to_return(body: fixture('account_activity_list_webhook.json'), headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request list webhooks' do
          @client.list_webhooks('env_name')
          expect(a_get('/1.1/account_activity/webhooks.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.list_webhooks('env_name')
          expect(response).to be_a Hash
          expect(response[:environments]).to be_a Array
          expect(response[:environments][0][:webhooks]).to be_a Array
          expect(response[:environments][0][:webhooks][0][:id]).to eq('1234567890')
        end
      end
    end

    describe '#trigger_crc_check' do
      context 'trigger crc check' do
        before do
          stub_put('/1.1/account_activity/webhooks/1234567890.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request crc check' do
          @client.trigger_crc_check('1234567890')
          expect(a_put('/1.1/account_activity/webhooks/1234567890.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.trigger_crc_check('1234567890')
          expect(response).to eq('')
        end
      end
    end

    describe '#create_subscription' do
      context 'create subscription' do
        before do
          stub_post('/1.1/account_activity/webhooks/1234567890/subscriptions/all.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request create subscription' do
          @client.create_subscription('1234567890')
          expect(a_post('/1.1/account_activity/webhooks/1234567890/subscriptions/all.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.create_subscription('1234567890')
          expect(response).to eq('')
        end
      end
    end

    describe '#check_subscription' do
      context 'check subscription' do
        before do
          stub_get('/1.1/account_activity/webhooks/1234567890/subscriptions/all.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request check subscription' do
          @client.check_subscription('1234567890')
          expect(a_get('/1.1/account_activity/webhooks/1234567890/subscriptions/all.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.check_subscription('1234567890')
          expect(response).to eq('')
        end
      end
    end

    describe '#delete_webhook' do
      context 'delete webhook' do
        before do
          stub_delete('/1.1/account_activity/webhooks/1234567890.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request delete webhook' do
          @client.delete_webhook('1234567890')
          expect(a_delete('/1.1/account_activity/webhooks/1234567890.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.delete_webhook('1234567890')
          expect(response).to eq('')
        end
      end
    end

    describe '#deactivate_subscription' do
      context 'deactivate subscription' do
        before do
          @client.bearer_token = 'BT'
          stub_delete('/1.1/account_activity/webhooks/1234567890/subscriptions/0987654321/all.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request deactivate subscription' do
          @client.deactivate_subscription('1234567890', '0987654321')
          expect(a_delete('/1.1/account_activity/webhooks/1234567890/subscriptions/0987654321/all.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.deactivate_subscription('1234567890', '0987654321')
          expect(response).to eq('')
        end
      end
    end

    describe '#count_subscriptions' do
      before do
        stub_get('/1.1/account_activity/subscriptions/count.json').to_return(body: fixture('account_activity_count_subscriptions.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'request count subscriptions' do
        @client.count_subscriptions
        expect(a_get('/1.1/account_activity/subscriptions/count.json').with(body: {})).to have_been_made
      end

      it 'returns a webhook response' do
        response = @client.count_subscriptions
        expect(response).to be_a Hash
        expect(response[:account_name]).to be_a String
        expect(response[:subscriptions_count]).to be_a String
        expect(response[:provisioned_count]).to be_a String
      end
    end

    describe '#list_subscriptions' do
      before do
        stub_get('/1.1/account_activity/webhooks/1234567890/subscriptions/all/list.json').to_return(body: fixture('account_activity_list_subscriptions.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'request list of subscriptions' do
        @client.list_subscriptions('1234567890')
        expect(a_get('/1.1/account_activity/webhooks/1234567890/subscriptions/all/list.json').with(body: {})).to have_been_made
      end

      it 'returns a webhook response' do
        response = @client.list_subscriptions('1234567890')
        expect(response).to be_a Hash
        expect(response[:environment]).to be_a String
        expect(response[:application_id]).to be_a String
        expect(response[:subscriptions]).to be_a Array
      end
    end
  end

  context 'without enterpise API' do
    describe '#create_webhook' do
      context 'with a webhook url passed' do
        before do
          stub_post('/1.1/account_activity/all/env_name/webhooks.json').with(body: {url: 'url'}).to_return(body: fixture('account_activity_create_webhook.json'), headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request create webhook' do
          @client.create_webhook('url', 'env_name')
          expect(a_post('/1.1/account_activity/all/env_name/webhooks.json').with(body: {url: 'url'})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.create_webhook('url', 'env_name')
          expect(response).to be_a Hash
          expect(response[:id]).to eq('1234567890')
        end
      end
    end

    describe '#list_webhooks' do
      context 'list webhooks' do
        before do
          stub_get('/1.1/account_activity/all/env_name/webhooks.json').to_return(body: fixture('account_activity_list_webhook.json'), headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request list webhooks' do
          @client.list_webhooks('env_name')
          expect(a_get('/1.1/account_activity/all/env_name/webhooks.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.list_webhooks('env_name')
          expect(response).to be_a Hash
          expect(response[:environments]).to be_a Array
          expect(response[:environments][0][:webhooks]).to be_a Array
          expect(response[:environments][0][:webhooks][0][:id]).to eq('1234567890')
        end
      end
    end

    describe '#trigger_crc_check' do
      context 'trigger crc check' do
        before do
          stub_put('/1.1/account_activity/all/env_name/webhooks/1234567890.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request crc check' do
          @client.trigger_crc_check('1234567890', 'env_name')
          expect(a_put('/1.1/account_activity/all/env_name/webhooks/1234567890.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.trigger_crc_check('1234567890', 'env_name')
          expect(response).to eq('')
        end
      end
    end

    describe '#create_subscription' do
      context 'create subscription' do
        before do
          stub_post('/1.1/account_activity/all/env_name/subscriptions.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request create subscription' do
          @client.create_subscription('env_name')
          expect(a_post('/1.1/account_activity/all/env_name/subscriptions.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.create_subscription('env_name')
          expect(response).to eq('')
        end
      end
    end

    describe '#check_subscription' do
      context 'check subscription' do
        before do
          stub_get('/1.1/account_activity/all/env_name/subscriptions.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request check subscription' do
          @client.check_subscription('env_name')
          expect(a_get('/1.1/account_activity/all/env_name/subscriptions.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.check_subscription('env_name')
          expect(response).to eq('')
        end
      end
    end

    describe '#delete_webhook' do
      context 'delete webhook' do
        before do
          stub_delete('/1.1/account_activity/all/env_name/webhooks/1234567890.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request delete webhook' do
          @client.delete_webhook('1234567890', 'env_name')
          expect(a_delete('/1.1/account_activity/all/env_name/webhooks/1234567890.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.delete_webhook('1234567890', 'env_name')
          expect(response).to eq('')
        end
      end
    end

    describe '#deactivate_subscription' do
      context 'deactivate subscription' do
        before do
          allow(@client).to receive(:user_token?).and_return(false)
          @client.bearer_token = 'BT'
          stub_delete('/1.1/account_activity/all/1234567890/subscriptions/0987654321.json').to_return(status: 204, headers: {content_type: 'application/json; charset=utf-8'})
        end
        it 'request deactivate subscription' do
          @client.deactivate_subscription('1234567890', '0987654321')
          expect(a_delete('/1.1/account_activity/all/1234567890/subscriptions/0987654321.json').with(body: {})).to have_been_made
        end

        it 'returns a webhook response' do
          response = @client.deactivate_subscription('1234567890', '0987654321')
          expect(response).to eq('')
        end
      end
    end

    describe '#count_subscriptions' do
      before do
        stub_get('/1.1/account_activity/all/subscriptions/count.json').to_return(body: fixture('account_activity_count_subscriptions.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'request count subscriptions' do
        @client.count_subscriptions
        expect(a_get('/1.1/account_activity/all/subscriptions/count.json').with(body: {})).to have_been_made
      end

      it 'returns a webhook response' do
        response = @client.count_subscriptions
        expect(response).to be_a Hash
        expect(response[:account_name]).to be_a String
        expect(response[:subscriptions_count]).to be_a String
        expect(response[:provisioned_count]).to be_a String
      end
    end
  end
end
