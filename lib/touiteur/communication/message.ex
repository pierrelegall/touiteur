defmodule Touiteur.Communication.Message do
  @moduledoc """
  Message schema.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Touiteur.Accounts.User

  schema "messages" do
    field :content, :string
    belongs_to :author, User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :author_id])
    |> cast_assoc(:author)
    |> validate_required([:content])
  end
end
