defmodule Touiteur.Services.StatsBuilderTest do
  use Touiteur.DataCase

  import Touiteur.Services.StatsBuilder
  import Touiteur.CommunicationFixtures

  describe "build stats" do
    test "from database messages" do
      message_fixture(%{supposed_language: "eng"})
      message_fixture(%{supposed_language: "eng"})
      message_fixture(%{supposed_language: "fra"})
      message_fixture(%{supposed_language: "spa"})
      message_fixture(%{supposed_language: nil})

      assert build_language_stats() == %{
               "eng" => 2,
               "fra" => 1,
               "spa" => 1
             }
    end
  end
end
