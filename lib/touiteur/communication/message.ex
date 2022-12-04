defmodule Touiteur.Communication.Message do
  @moduledoc """
  Message schema.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Touiteur.Accounts.User

  schema "messages" do
    field :content, :string
    field :supposed_language, :string
    belongs_to :author, User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :supposed_language, :author_id])
    |> cast_assoc(:author)
    |> validate_required([:content])
  end
end
