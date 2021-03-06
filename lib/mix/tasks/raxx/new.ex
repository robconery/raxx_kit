defmodule Mix.Tasks.Raxx.New do
  use Mix.Task

  require Mix.Generator

  @shortdoc "Creates a new Raxx project for browsers"
  @switches [
    api: :boolean,
    docker: :boolean,
    module: :string,
    node_assets: :boolean,
    no_exsync: :boolean,
    ecto: :boolean
  ]

  @moduledoc """
  Creates a new Raxx project for browsers.

  It expects the name of the project as the argument.

      mix raxx.new NAME [--ecto] [--node-assets] [--docker] [--module ModuleName]
        [--no-exsync]

  ## Options

  - `--api`:  Creates a JSON API project, instead of HTML pages.

  - `--ecto`: Adds Ecto as a dependency and configures project to use
    a Postgres database. If used with `--docker` flag, a docker-compose service
    with the database will get generated.

  - `--node-assets`: Add JavaScript compilation as part of a generated project.
    Works with or without docker.

  - `--docker`: Create `Dockerfile` and `docker-compose.yml` in template.
    This allows local development to be conducted completly in docker.

  - `--module`: Used to name the top level module used in the generated project.
    Without this option the module name will be generated from path option.

  ```sh
  $ mix raxx.new my_app

  # Is equivalent to
  $ mix raxx.new my_app --module MyApp
  ```

  - `--no-exsync`: Doesn't include exsync in the generated project. Changed
    files won't be rebuilt on the fly when the app is running.

  """

  @impl Mix.Task
  def run([]) do
    Mix.Tasks.Help.run(["raxx.new"])
  end

  def run(options) do
    case OptionParser.parse!(options, strict: @switches) do
      {_, []} ->
        Mix.raise("raxx.new must be given a name `mix raxx.new <name>`")

      {switches, [name]} ->
        {:ok, message} = Raxx.Kit.generate([{:name, name} | switches])

        Mix.shell().info(message)
    end
  end
end
