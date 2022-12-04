defmodule Touiteur.Services.MessageSupposedLanguageSetterTest do
  use ExUnit.Case, async: true

  alias Touiteur.Services.MessageSupposedLanguageSetter
  alias Touiteur.Communication.Message

  setup do
    detector = start_supervised!(MessageSupposedLanguageSetter)
    %{detector: detector}
  end

  test "detect language", %{detector: detector} do
    assert MessageSupposedLanguageSetter.get_state(detector) == nil

    message = %Message{content: "This is a nice sentence."}
    Phoenix.PubSub.broadcast(Touiteur.PubSub, "new_message", {:new, message})

    assert %Message{supposed_language: "eng"} = MessageSupposedLanguageSetter.get_state(detector)
  end
end
