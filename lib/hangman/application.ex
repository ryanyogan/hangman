defmodule Hangman.Application do
  use Application
  use DynamicSupervisor

  def start(_type, _args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(_opts) do
    spec = {Hangman.Server, start: {Hangman.Server, :start_link, []}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
