defmodule TouiteurWeb.StatsIndexLiveTest do
  use TouiteurWeb.ConnCase

  import Phoenix.LiveViewTest
  import Touiteur.CommunicationFixtures
  import Touiteur.AccountsFixtures

  @eng_sentence "This is a nice sentence in English."

  describe "on new message" do
    setup [:log_in_user]

    test "update the stats", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/")

      refute render(view) =~ "English"

      create_message(%{content: @eng_sentence})

      assert render(view) =~ "English"
      assert render(view) =~ "1"
    end
  end

  defp create_message(attrs) do
    message = message_fixture(attrs)
    %{message: message}
  end

  defp log_in_user(%{conn: conn}) do
    %{conn: log_in_user(conn, user_fixture())}
  end
end
