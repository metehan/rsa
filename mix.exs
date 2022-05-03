defmodule Rsa.MixProject do
  use Mix.Project

  def project do
    [
      app: :rsa,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/metehan/rsa",
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :public_key]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp description() do
    "An ergonomic RSA encrypting decryting library."
  end

  defp package() do
    [
      name: "pk_rsa",
      files: ~w(lib test mix.exs README.md),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/metehan/rsa"}
    ]
  end
end
