defmodule TouiteurWeb.MessageControllerTest do
  defmodule LoggedIn do
    use TouiteurWeb.ConnCase

    import Touiteur.CommunicationFixtures
    alias Touiteur.AccountsFixtures

    @create_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil, author_id: nil}

    describe "index" do
      setup [:log_in_user]

      test "lists all messages", %{conn: conn} do
        conn = get(conn, ~p"/")
        html = html_response(conn, 200)

        assert html =~ "Listing Messages"
        assert html =~ "New Message"
      end
    end

    describe "new message" do
      setup [:log_in_user]

      test "renders form", %{conn: conn} do
        conn = get(conn, ~p"/messages/new")

        assert html_response(conn, 200) =~ "New Message"
      end
    end

    describe "show message" do
      setup [:log_in_user, :create_message]

      test "render message", %{conn: conn, message: message} do
        conn = get(conn, ~p"/messages/#{message.id}")

        assert html_response(conn, 200) =~ "Message #{message.id}"
      end
    end

    describe "create message" do
      setup [:log_in_user]

      test "redirects to show when data is valid", %{conn: conn} do
        %{id: author_id} = AccountsFixtures.user_fixture()
        message = Map.put(@create_attrs, :author_id, author_id)

        conn = post(conn, ~p"/messages", message: message)

        assert %{id: id} = redirected_params(conn)
        assert redirected_to(conn) == ~p"/messages/#{id}"

        conn = get(conn, ~p"/messages/#{id}")
        assert html_response(conn, 200) =~ "Message #{id}"
      end

      test "renders errors when data is invalid", %{conn: conn} do
        conn = post(conn, ~p"/messages", message: @invalid_attrs)
        assert html_response(conn, 200) =~ "New Message"
      end
    end

    describe "edit message" do
      setup [:log_in_user, :create_message]

      test "renders form for editing chosen message", %{conn: conn, message: message} do
        conn = get(conn, ~p"/messages/#{message}/edit")
        assert html_response(conn, 200) =~ "Edit Message"
      end
    end

    describe "update message" do
      setup [:log_in_user, :create_message]

      test "redirects when data is valid", %{conn: conn, message: message} do
        conn = put(conn, ~p"/messages/#{message}", message: @update_attrs)
        assert redirected_to(conn) == ~p"/messages/#{message}"

        conn = get(conn, ~p"/messages/#{message}")
        assert html_response(conn, 200) =~ "some updated content"
      end

      test "renders errors when data is invalid", %{conn: conn, message: message} do
        conn = put(conn, ~p"/messages/#{message}", message: @invalid_attrs)
        assert html_response(conn, 200) =~ "Edit Message"
      end
    end

    describe "delete message" do
      setup [:log_in_user, :create_message]

      test "deletes chosen message", %{conn: conn, message: message} do
        conn = delete(conn, ~p"/messages/#{message}")
        assert redirected_to(conn) == ~p"/messages"

        assert_error_sent 404, fn ->
          get(conn, ~p"/messages/#{message}")
        end
      end
    end

    defp create_message(_) do
      message = message_fixture()
      %{message: message}
    end

    defp log_in_user(%{conn: conn}) do
      %{conn: log_in_user(conn, AccountsFixtures.user_fixture())}
    end
  end

  defmodule NotLoggedIn do
    use TouiteurWeb.ConnCase

    import Touiteur.CommunicationFixtures
    alias Touiteur.AccountsFixtures

    @create_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil, author_id: nil}

    describe "index" do
      test "lists all messages", %{conn: conn} do
        conn = get(conn, ~p"/")
        html = html_response(conn, 200)

        assert html =~ "Listing Messages"
        refute html =~ "New Message"
      end
    end

    describe "new message" do
      test "renders form", %{conn: conn} do
        conn = get(conn, ~p"/messages/new")

        assert redirected_to(conn) == ~p"/users/log_in"
      end
    end

    describe "show message" do
      setup [:create_message]

      test "render message", %{conn: conn, message: message} do
        conn = get(conn, ~p"/messages/#{message.id}")

        assert html_response(conn, 200) =~ "Message #{message.id}"
      end
    end

    describe "create message" do
      test "redirects to show when data is valid", %{conn: conn} do
        %{id: author_id} = AccountsFixtures.user_fixture()
        message = Map.put(@create_attrs, :author_id, author_id)

        conn = post(conn, ~p"/messages", message: message)

        assert redirected_to(conn) == ~p"/users/log_in"
      end

      test "renders errors when data is invalid", %{conn: conn} do
        conn = post(conn, ~p"/messages", message: @invalid_attrs)

        assert redirected_to(conn) == ~p"/users/log_in"
      end
    end

    describe "edit message" do
      setup [:create_message]

      test "renders form for editing chosen message", %{conn: conn, message: message} do
        conn = get(conn, ~p"/messages/#{message}/edit")

        assert redirected_to(conn) == ~p"/users/log_in"
      end
    end

    describe "update message" do
      setup [:create_message]

      test "redirects when data is valid", %{conn: conn, message: message} do
        conn = put(conn, ~p"/messages/#{message}", message: @update_attrs)

        assert redirected_to(conn) == ~p"/users/log_in"
      end

      test "renders errors when data is invalid", %{conn: conn, message: message} do
        conn = put(conn, ~p"/messages/#{message}", message: @invalid_attrs)

        assert redirected_to(conn) == ~p"/users/log_in"
      end
    end

    describe "delete message" do
      setup [:create_message]

      test "deletes chosen message", %{conn: conn, message: message} do
        conn = delete(conn, ~p"/messages/#{message}")

        assert redirected_to(conn) == ~p"/users/log_in"
      end
    end

    defp create_message(_) do
      message = message_fixture()
      %{message: message}
    end
  end
end
