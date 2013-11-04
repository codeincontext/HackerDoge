defmodule HackerDoge.Mixfile do
  use Mix.Project

  def project do
    [ app: :hacker_doge,
      version: "0.0.1",
      elixir: "~> 0.10.3",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:sasl, :oauth, :crypto,
    :ssl, :public_key, :inets],
      mod: { HackerDoge, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      { :oauthex, "0.0.1", [github: "marcelog/oauthex", tag: "0.0.1"] },
      { :jsex, "0.2", github: "talentdeficit/jsex" }
    ]
  end
end
