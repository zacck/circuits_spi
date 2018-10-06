defmodule SPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :spi,
      version: "0.1.0",
      elixir: "~> 1.6",
      name: "spi",
      description: description(),
      package: package(),
      source_url: "https://github.com/ElixirCircuits/spi",
      compilers: [:elixir_make | Mix.compilers()],
      make_clean: ["clean"],
      docs: [extras: ["README.md"]],
      aliases: [docs: ["docs", &copy_images/1], format: ["format", &format_c/1]],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: []

  defp description do
    "Elixir access to the hardware SPI interfaces."
  end

  defp package do
    %{
      files: [
        "lib",
        "src/*.[ch]",
        "mix.exs",
        "README.md",
        "LICENSE",
        "Makefile"
      ],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/ElixirCircuits/spi"}
    }
  end

  defp deps do
    [
      {:elixir_make, "~> 0.4", runtime: false},
      {:ex_doc, "~> 0.11", only: :dev, runtime: false}
    ]
  end

  # Copy the images referenced by docs, since ex_doc doesn't do this.
  defp copy_images(_) do
    File.cp_r("assets", "doc/assets")
  end

  defp format_c([]) do
    astyle =
      System.find_executable("astyle") ||
        Mix.raise("""
        Could not format C code since astyle is not available.
        """)

    System.cmd(astyle, ["-n", "src/*.c", "src/*.h"], into: IO.stream(:stdio, :line))
  end

  defp format_c(_args), do: true
end