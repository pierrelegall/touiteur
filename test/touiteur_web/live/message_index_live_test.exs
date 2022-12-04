defmodule TouiteurWeb.MessageIndexLiveTest do
  use TouiteurWeb.ConnCase

  import Phoenix.LiveViewTest
  import Touiteur.CommunicationFixtures
  import Touiteur.AccountsFixtures

  describe "on new message" do
    setup [:log_in_user]

    test "update the list", %{conn: conn} do
      user = user_fixture()
      {:ok, view, _html} = live(conn, ~p"/")

      refute render(view) =~ "@#{user.name}: Hello"

      create_message(%{content: "Hello", author_id: user.id})

      assert render(view) =~ "@#{user.name}: Hello"
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
