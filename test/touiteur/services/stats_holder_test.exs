defmodule Touiteur.Services.StatsHolderTest do
  use Touiteur.DataCase

  alias Touiteur.Services.StatsHolder
  alias Touiteur.Communication.Message

  setup do
    stats_holder = start_supervised!(StatsHolder)
    %{stats_holder: stats_holder}
  end

  describe "hold stats" do
    test "for languages", %{stats_holder: stats_holder} do
      assert StatsHolder.get_stats(stats_holder) == %{}

      broadcast(%Message{supposed_language: "eng"})
      assert StatsHolder.get_stats(stats_holder) == %{"eng" => 1}

      broadcast(%Message{supposed_language: "eng"})
      broadcast(%Message{supposed_language: "fra"})
      broadcast(%Message{supposed_language: "spa"})

      assert StatsHolder.get_stats(stats_holder) == %{
               "eng" => 2,
               "fra" => 1,
               "spa" => 1
             }
    end
  end

  defp broadcast(message) do
    Phoenix.PubSub.broadcast(
      Touiteur.PubSub,
      "language_detected",
      {:language_detected, message}
    )
  end
end
