defmodule TouiteurWeb.MessageController do
  use TouiteurWeb, :controller

  alias Touiteur.Communication
  alias Touiteur.Communication.Message

  def index(conn, _params) do
    messages = Communication.list_messages()
    render(conn, :index, messages: messages)
  end

  def new(conn, _params) do
    changeset = Communication.change_message(%Message{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    case Communication.create_message(message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: ~p"/messages/#{message}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Communication.get_message!(id)
    render(conn, :show, message: message)
  end

  def edit(conn, %{"id" => id}) do
    message = Communication.get_message!(id)
    changeset = Communication.change_message(message)
    render(conn, :edit, message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Communication.get_message!(id)

    case Communication.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: ~p"/messages/#{message}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Communication.get_message!(id)
    {:ok, _message} = Communication.delete_message(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: ~p"/messages")
  end
end
