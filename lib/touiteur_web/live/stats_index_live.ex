defmodule TouiteurWeb.StatsIndexLive do
  @moduledoc """
  Stats live view (realtime update).
  """

  use TouiteurWeb, :live_view

  alias Touiteur.Services.StatsHolder
  alias Touiteur.Services.LanguageDetector

  on_mount Touiteur.UserAuthLive

  def render(assigns) do
    ~H"""
    <.header>
      Language statistics
    </.header>

    <.table id="messages" rows={@stats}>
      <:col :let={stat} label="Language"><%= stat.language %></:col>
      <:col :let={stat} label="Count"><%= stat.count %></:col>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    stats = StatsHolder.get_stats()
    Phoenix.PubSub.subscribe(Touiteur.PubSub, "stats_updated")

    {:ok, assign(socket, stats: format_stats(stats))}
  end

  def handle_info({:stats_updated, stats}, socket) do
    {:noreply, update(socket, :stats, fn _ -> format_stats(stats) end)}
  end

  defmodule Stat do
    defstruct id: nil, language: nil, count: nil
  end

  defp format_stats(stats) do
    for {lang, count} <- stats do
      {:ok, lang_fullname} = LanguageDetector.code_to_eng_name(lang)

      %Stat{
        id: lang,
        language: lang_fullname,
        count: count
      }
    end
  end
end
