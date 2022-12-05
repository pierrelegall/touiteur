defmodule Touiteur.Services.StatsHolder do
  @moduledoc """
  Process setting the supposed language at new messages events.
  """

  use GenServer

  alias Touiteur.PubSub
  alias Touiteur.Services.StatsBuilder

  def start_link(args) do
    GenServer.start_link(__MODULE__, :ok, name: args[:name] || __MODULE__)
  end

  def get_stats(server \\ __MODULE__)  do
    GenServer.call(server, :get_stats)
  end

  @impl true
  def init(:ok) do
    stats = StatsBuilder.build_language_stats()
    Phoenix.PubSub.subscribe(PubSub, "language_detected")

    {:ok, stats}
  end

  @impl true
  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  @impl true
  def handle_info({:language_detected, message}, stats) do
    lang = message.supposed_language

    stats =
      if Map.has_key?(stats, lang) do
        Map.update!(stats, lang, fn count -> count + 1 end)
      else
        Map.put_new(stats, lang, 1)
      end

    Phoenix.PubSub.broadcast(Touiteur.PubSub, "stats_updated", {:stats_updated, stats})

    {:noreply, stats}
  end
end
