defmodule Touiteur.Services.StatsBuilder do
  @moduledoc """
  Stats builder service.
  """

  alias Touiteur.Repo
  alias Touiteur.Communication.Message

  import Ecto.Query

  def build_language_stats do
    query =
      from m in Message,
        group_by: m.supposed_language,
        select: [m.supposed_language, count(m.id)]

    result = Repo.all(query)

    result
    |> Enum.map(fn [lang, count] -> {lang, count} end)
    |> Enum.filter(fn {lang, _count} -> lang != "nil" end)
    |> Enum.into(%{})
  end
end
