require 'twitter/rest/request'
require 'twitter/rest/utils'
require 'twitter/utils'

module Twitter
  module REST
    module AccountActivity
      include Twitter::REST::Utils
      include Twitter::Utils

      # Registers a webhook URL for all event types. The URL will be validated via CRC request before saving. In case the validation failed, returns comprehensive error message to the requester.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#post-account-activity-all-env-name-webhooks
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#post-account-activity-all-env-name-webhooks
      # @note Create a webhook
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Hash]
      # @param env_name [String] Environment Name.
      # @param url [String] Encoded URL for the callback endpoint.
      def create_webhook(url, env_name = nil)
        if enterprise_api
          perform_request(:post, '/1.1/account_activity/webhooks.json', url: url)
        else
          perform_request(:post, "/1.1/account_activity/all/#{env_name}/webhooks.json", url: url)
        end
      end

      # Returns all environments, webhook URLs and their statuses for the authenticating app. Currently, only one webhook URL can be registered to each environment.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-webhooks
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#get-account-activity-all-webhooks
      # @note List webhooks
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Hash]
      # @param env_name [String] Environment Name.
      def list_webhooks(env_name = nil)
        if enterprise_api
          perform_request(:get, '/1.1/account_activity/webhooks.json')
        else
          perform_request(:get, "/1.1/account_activity/all/#{env_name}/webhooks.json")
        end
      end

      # Removes the webhook from the provided application's all activities configuration. The webhook ID can be accessed by making a call to GET /1.1/account_activity/all/webhooks.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#delete-account-activity-all-env-name-webhooks-webhook-id
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#delete-account-activity-all-env-name-webhooks-webhook-id
      # @note Delete a webhook
      # @authentication Requires user context - all consumer and access tokens
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [nil]
      # @param env_name [String] Environment Name.
      # @param webhook_id [String] Webhook ID.
      def delete_webhook(webhook_id, env_name = nil)
        if enterprise_api
          perform_request(:delete, "/1.1/account_activity/webhooks/#{webhook_id}.json")
        else
          perform_request(:delete, "/1.1/account_activity/all/#{env_name}/webhooks/#{webhook_id}.json")
        end
      end

      # Triggers the challenge response check (CRC) for the given enviroments webhook for all activites. If the check is successful, returns 204 and reenables the webhook by setting its status to valid.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#put-account-activity-all-env-name-webhooks-webhook-id
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#put-account-activity-all-env-name-webhooks-webhook-id
      # @note Trigger CRC check to a webhook
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [nil]
      # @param env_name [String] Environment Name.
      # @param webhook_id [String] Webhook ID.
      def trigger_crc_check(webhook_id, env_name = nil)
        if enterprise_api
          perform_request(:json_put, "/1.1/account_activity/webhooks/#{webhook_id}.json")
        else
          perform_request(:json_put, "/1.1/account_activity/all/#{env_name}/webhooks/#{webhook_id}.json")
        end
      end

      # Subscribes the provided application to all events for the provided environment for all message types. After activation, all events for the requesting user will be sent to the application's webhook via POST request.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#post-account-activity-all-env-name-subscriptions
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#post-account-activity-all-env-name-subscriptions
      # @note Subscribe the user(whose credentials are provided) to the app so that the webhook can receive all types of events from user
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [nil]
      # @param env_name_or_webhook_id [String] Environment Name or Webhook Id
      def create_subscription(env_name_or_webhook_id)
        if enterprise_api
          perform_request(:json_post, "/1.1/account_activity/webhooks/#{env_name_or_webhook_id}/subscriptions/all.json")
        else
          perform_request(:json_post, "/1.1/account_activity/all/#{env_name_or_webhook_id}/subscriptions.json")
        end
      end

      # Provides a way to determine if a webhook configuration is subscribed to the provided user's events. If the provided user context has an active subscription with provided application, returns 204 OK.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-env-name-subscriptions
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#get-account-activity-all-env-name-subscriptions
      # @note Check if the user is subscribed to the given app
      # @rate_limited Yes
      # @authentication Requires user context - all consumer and access tokens
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [nil]
      # @param env_name_or_webhook_id [String] Environment Name or Webhook Id
      def check_subscription(env_name_or_webhook_id)
        if enterprise_api
          perform_request(:get, "/1.1/account_activity/webhooks/#{env_name_or_webhook_id}/subscriptions/all.json")
        else
          perform_request(:get, "/1.1/account_activity/all/#{env_name_or_webhook_id}/subscriptions.json")
        end
      end

      # Deactivates subscription(s) for the provided user context and application for all activities. After deactivation, all events for the requesting user will no longer be sent to the webhook URL.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#delete-account-activity-all-env-name-subscriptions
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#delete-account-activity-all-env-name-subscriptions
      # @note Deactivate a subscription, Users events will not be sent to the app
      # @rate_limited Yes
      # @authentication Requires application context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [nil]
      # @param env_name_or_webhook_id [String] Environment Name or Webhook Id
      # @param user_id [String] Id of the user to unsubscribe
      def deactivate_subscription(env_name_or_webhook_id, user_id)
        if enterprise_api
          perform_request(:delete, "/1.1/account_activity/webhooks/#{env_name_or_webhook_id}/subscriptions/#{user_id}/all.json")
        else
          perform_request(:delete, "/1.1/account_activity/all/#{env_name_or_webhook_id}/subscriptions/#{user_id}.json")
        end
      end

      # Returns the count of subscriptions that are currently active on your account for all activities.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-subscriptions-count
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#get-account-activity-all-subscriptions-count
      # @note Gives the number of subscriptions to an app
      # @rate_limited yes
      # @authentication Requires application context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Hash]
      def count_subscriptions
        if enterprise_api
          perform_request(:get, '/1.1/account_activity/subscriptions/count.json')
        else
          perform_request(:get, '/1.1/account_activity/all/subscriptions/count.json')
        end
      end

      # Returns a list of the current All Activity type subscriptions.
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-premium#get-account-activity-all-env-name-subscriptions-list
      # @see https://developer.twitter.com/en/docs/accounts-and-users/subscribe-account-activity/api-reference/aaa-enterprise#get-account-activity-all-env-name-subscriptions-list
      # @note Gives list of subscriptions to an app
      # @rate_limited yes
      # @authentication Requires application context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Hash]
      # @param env_name_or_webhook_id [String] Environment Name or Webhook Id
      def list_subscriptions(env_name_or_webhook_id)
        if enterprise_api
          perform_request(:get, "/1.1/account_activity/webhooks/#{env_name_or_webhook_id}/subscriptions/all/list.json")
        else
          perform_request(:get, "/1.1/account_activity/all/#{env_name_or_webhook_id}/subscriptions/list.json")
        end
      end
    end
  end
end
