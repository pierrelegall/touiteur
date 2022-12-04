defmodule Touiteur.Communication do
  @moduledoc """
  The Communication context.
  """

  import Ecto.Query, warn: false
  alias Touiteur.Repo
  alias Phoenix.PubSub

  alias Touiteur.Communication.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

      iex> list_messages([:author])
      [%Message{..., author: %User{}}, ...]

  """
  def list_messages(preloads \\ []) do
    query =
      from m in Message,
        order_by: [desc: m.inserted_at],
        preload: ^preloads

    Repo.all(query)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{...}

      iex> get_message!(123, [:author])
      %Message{..., author: %User{}}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id, preloads \\ []) do
    Message |> preload(^preloads) |> Repo.get!(id)
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, message} ->
        broadcast_new_message(message)
        {:ok, message}

      error ->
        error
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  defp broadcast_new_message(%Message{} = message) do
    PubSub.broadcast(Touiteur.PubSub, "new_message", {:new, message})
  end
end
