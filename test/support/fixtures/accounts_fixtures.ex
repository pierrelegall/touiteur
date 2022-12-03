defmodule Touiteur.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Touiteur.Accounts` context.
  """

  def unique_user_identity do
    unique_integer = System.unique_integer([:positive])

    %{
      name: "User#{unique_integer}",
      email: "user#{unique_integer}@example.com"
    }
  end

  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    %{name: name, email: email} = unique_user_identity()

    Enum.into(attrs, %{
      name: name,
      email: email,
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Touiteur.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
