defmodule Touiteur.UserAuthLive do
  import Phoenix.LiveView.Utils

  alias Touiteur.Accounts

  def on_mount(:default, _params, %{"user_token" => user_token}, socket) do
    socket = assign(socket, :current_user, Accounts.get_user_by_session_token(user_token))

    {:cont, socket}
  end

  def on_mount(:default, _params, _session, socket) do
    socket = assign(socket, :current_user, nil)

    {:cont, socket}
  end
end
