defmodule Touiteur.RepoMock do
  @moduledoc """
  Minimal mock of an Ecto.Repo to disable uses of a
  real repo. Useful to avoid asynchronous Repo calls
  in a test environment.
  """

  def update!(_changeset, _opts \\ []) do
    nil
  end
end
