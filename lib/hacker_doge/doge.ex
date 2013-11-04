defmodule HackerDoge.Doge do
  def generate_message_from_tweet(tweet) do
    [_, title, link] = split_tweet(tweet)

    String.split(title)
      |> filter_by_longest(4)
      |> Enum.shuffle
      |> Enum.map(&dogeify/1)
      |> Enum.map(&random_padding/1)
      |> Enum.concat([link])
      |> Enum.join("\n ")
  end

  defp split_tweet(tweet) do
    Regex.run(%r/(.*) (http.*)$/, tweet)
  end

  defp filter_by_longest(words, count // 3) do
    Enum.sort(words, &(String.length(&1) > String.length(&2))) |> Enum.take(count)
  end

  defp random_padding(string) do
    pad_amount = String.length(string) + :random.uniform(35)
    String.rjust(string, pad_amount)
  end

  defp dogeify(string) do
    prefixes = [
      "such ",
      "wow",
      "so ",
      "much ",
      "vry ",
      "nice "
    ]

    random_prefix = Enum.shuffle(prefixes) |> Enum.first

    case random_prefix do
      "wow" -> "wow"
      other -> other <> String.downcase(string)
    end
  end
end

