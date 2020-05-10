defmodule Hangman.Application do
  use Application

  @impl true
  def start(_type, _args) do
    options = [
      name: Hangman.Supervisor,
      strategy: :one_for_one
    ]

    DynamicSupervisor.start_link(options)
  end
end
