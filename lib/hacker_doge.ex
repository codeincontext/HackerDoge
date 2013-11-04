defmodule HackerDoge do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  # I nicked a lot of stuff from https://github.com/yortz/twitterproxy/blob/master/lib/twitterproxy.ex

  @doc """
  The application callback used to start the application.
  """

  defrecord CONFIGURATION, consumer_key: nil, consumer_secret: nil, token: nil, secret: nil, url: nil, screen_name: nil, count: nil

  def start(_type, _args) do
    # HackerDoge.Supervisor.start_link
    :random.seed(:erlang.now) # wow, yea, we need this
    HackerDoge.Twitter.get_tweets |> HackerDoge.Twitter.send_tweets
    {:ok, self}
  end



  @doc """
  Reads the values from the configuration.yml file.
  """
  def read_configuration(yml) do
    contents        = File.read!(yml)
    values          = String.replace(contents, "configuration:\n", "") |> String.strip #String.strip(String.replace(contents, "configuration:\n", ""))
    values_list     = String.split(values, "\n")
  end

  @doc """
  it creates a keyword list for the values (properly formatted)
  previously extrcted from the configuration.yml file.
  """
  def extract_values(values_list) do
    << "consumer_key:", consumer_key :: binary >>       = Enum.at values_list, 0
    << "consumer_secret:", consumer_secret :: binary >> = String.strip(Enum.at values_list, 1)
    << "token:", token :: binary >>                     = String.strip(Enum.at values_list, 2)
    << "secret:", secret :: binary >>                   = String.strip(Enum.at values_list, 3)
    << "url:", url :: binary >>                         = String.strip(Enum.at values_list, 4)
    << "screen_name:", screen_name :: binary >>         = String.strip(Enum.at values_list, 5)
    << "count:", count :: binary >>                     = String.strip(Enum.at values_list, 6)
    [ consumer_key: format(consumer_key), consumer_secret: format(consumer_secret), token: format(token), secret: format(secret), url: bin_to_list(format(url)), screen_name: format(screen_name), count: to_integer(String.strip(count))]
  end

  defp format(value) do
    << 32, 34, rest :: binary >> = value
    rest_list = bin_to_list(rest)
    :erlang.list_to_binary(List.delete(rest_list, List.last(rest_list)))
  end

  @doc """
  formats a string by removing the \" char.
  """
  defp to_integer(string) do
    {integer, string } = String.to_integer(string)
    integer
  end

  defp bin_to_list(binary) do
    :binary.bin_to_list(binary)
  end
  @doc """
  it creates a new CONFIGURATION record with values
  extracted from the configuration keyword list.
  """
  def write_configuration(keyword_list) do
    consumer_key    = Keyword.get keyword_list, :consumer_key
    consumer_secret = Keyword.get keyword_list, :consumer_secret
    token           = Keyword.get keyword_list, :token
    secret          = Keyword.get keyword_list, :secret
    url             = Keyword.get keyword_list, :url
    screen_name     = Keyword.get keyword_list, :screen_name
    count           = Keyword.get keyword_list, :count
    CONFIGURATION.new consumer_key: consumer_key, consumer_secret: consumer_secret, token: token, secret: secret, url: url, screen_name: screen_name, count: count
  end

  def configure(yml) do
    read_configuration(yml) |> extract_values |> write_configuration
  end
end
