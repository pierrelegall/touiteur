defmodule Touiteur.CommunicationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Touiteur.Communication` context.
  """

  alias Touiteur.AccountsFixtures

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    %{id: author_id} = AccountsFixtures.user_fixture()

    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        supposed_language: nil,
        author_id: author_id
      })
      |> Touiteur.Communication.create_message()

    message
  end
end
