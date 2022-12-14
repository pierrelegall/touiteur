defmodule Touiteur.Services.MessageSupposedLanguageSetter do
  @moduledoc """
  Process setting the supposed language at new messages events.
  """

  use GenServer

  @repo Application.compile_env(:touiteur, :repo, Touiteur.Repo)

  alias Touiteur.PubSub
  alias Touiteur.Services.LanguageDetector
  alias Touiteur.Communication.Message

  def start_link(args) do
    GenServer.start_link(__MODULE__, :ok, name: args[:name] || __MODULE__)
  end

  def get_state(server \\ __MODULE__) do
    GenServer.call(server, :get_state)
  end

  @impl true
  def init(:ok) do
    Phoenix.PubSub.subscribe(PubSub, "new_message")
    {:ok, nil}
  end

  @impl true
  def handle_call(:get_state, _from, last_updated_message) do
    {:reply, last_updated_message, last_updated_message}
  end

  @impl true
  def handle_info({:new, message}, _state) do
    {:ok, detection} = LanguageDetector.detect(message.content)

    Message.changeset(message, %{supposed_language: detection.lang})
    |> @repo.update!()

    updated_message = %{message | supposed_language: detection.lang}

    Phoenix.PubSub.broadcast(
      Touiteur.PubSub,
      "language_detected",
      {:language_detected, updated_message}
    )

    {:noreply, updated_message}
  end
end
