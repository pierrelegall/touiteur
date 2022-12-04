defmodule Touiteur.Services.LanguageDetectionEngineMock do
  @moduledoc """
  Mock of the LanguageDetectionEngine service.
  """

  def detect("") do
    "?"
  end

  def detect(_sentence) do
    "eng"
  end

  def code_to_name(code) do
    case code do
      "eng" -> "English"
      "fra" -> "Français"
      "spa" -> "Español"
      _ -> "?"
    end
  end
end
