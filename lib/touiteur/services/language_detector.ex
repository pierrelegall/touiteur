defmodule Touiteur.Services.LanguageDetector do
  @moduledoc """
  Service of language detection.
  """

  alias Whatlangex

  def detect(sentence) do
    Whatlangex.detect(sentence)
  end

  def code_to_name(code) do
    Whatlangex.code_to_name(code)
  end
end
