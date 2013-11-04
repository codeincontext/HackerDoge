defmodule HackerDoge.Twitter do
  @doc """
  Get recent tweets from the account we're *cough* using.
  """
  def get_tweets do
    configuration = HackerDoge.configure("configuration.yml")
    consumer = create_consumer(configuration.consumer_key, configuration.consumer_secret)
    reqinfo = create_request_info(configuration.token, configuration.secret)

    {_ok, _headers, data} = get_user_timeline configuration.screen_name, configuration.count, consumer, reqinfo
    {_ok, decoded_data} = data |> String.from_char_list! |> JSEX.decode

    Enum.map decoded_data, &Dict.get(&1, "text")
  end

  @doc """
  Send a list of strings as doge tweets.
  """
  def send_tweets(tweets) do
    configuration = HackerDoge.configure("configuration.yml")
    consumer = create_consumer(configuration.consumer_key, configuration.consumer_secret)

    doge_tweets = Enum.map tweets, &HackerDoge.Doge.generate_message_from_tweet/1

    Enum.each doge_tweets, fn(tweet) ->
      reqinfo = create_request_info(configuration.token, configuration.secret)

      post_tweet tweet, configuration.count, consumer, reqinfo
      receive do
        other -> IO.inspect other
      end
    end
  end


  @doc """
  Creates an Oauth consumer instance.
  """
  defp create_consumer(consumer_key, consumer_secret) do
    Oauthex.Consumer.new(key: bin_to_list(consumer_key), secret: bin_to_list(consumer_secret))
  end

  @doc """
  Sets a reqinfo needed to get the user timeline.
  """
  defp create_request_info(token, secret) do
    Oauthex.ReqInfo.new(token: bin_to_list(token), secret: bin_to_list(secret))
  end

  defp get_user_timeline(screen_name, count, consumer, reqinfo) do
    Oauthex.get 'https://api.twitter.com/1.1/statuses/user_timeline.json', [{'screen_name', bin_to_list(screen_name)}, {'count', count}], consumer, reqinfo
  end

  defp post_tweet(text, count, consumer, reqinfo) do
    Oauthex.post 'https://api.twitter.com/1.1/statuses/update.json', [{'status', String.to_char_list!(text)}], consumer, reqinfo
  end

  defp bin_to_list(binary) do
    :binary.bin_to_list(binary)
  end

end
