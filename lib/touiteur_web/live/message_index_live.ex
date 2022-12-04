defmodule TouiteurWeb.MessageIndexLive do
  @moduledoc false

  use TouiteurWeb, :live_view

  alias Touiteur.Communication
  alias Phoenix.PubSub

  on_mount Touiteur.UserAuthLive

  def render(assigns) do
    ~H"""
    <.header>
      Listing Messages
      <:actions>
        <%= if @current_user do %>
          <.link href={~p"/messages/new"}>
            <.button>New Message</.button>
          </.link>
        <% end %>
      </:actions>
    </.header>

    <.table id="messages" rows={@messages} row_click={&JS.navigate(~p"/messages/#{&1}")}>
      <:col :let={message} label="Content">@<%= message.author.name %>: <%= message.content %></:col>

      <:action :let={message}>
        <%= if @current_user do %>
          <div class="sr-only">
            <.link navigate={~p"/messages/#{message}"}>Show</.link>
          </div>
          <.link navigate={~p"/messages/#{message}/edit"}>Edit</.link>
        <% end %>
      </:action>
      <:action :let={message}>
        <%= if @current_user do %>
          <.link href={~p"/messages/#{message}"} method="delete" data-confirm="Are you sure?">
            Delete
          </.link>
        <% end %>
      </:action>
    </.table>
    """
  end

  def mount(_params, _session, socket) do
    PubSub.subscribe(Touiteur.PubSub, "new_message")

    messages = Communication.list_messages([:author])

    {:ok, assign(socket, messages: messages)}
  end

  def handle_info({:new, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> [message | messages] end)}
  end
end
