defmodule Touiteur.Services.LanguageDetectionEngineMock do
  @moduledoc """
  Mock of the LanguageDetectionEngine service.
  """

  def detect("") do
    :none
  end

  def detect(_sentence) do
    {:ok,
     %Whatlangex.Detection{
       lang: "eng",
       script: "Latin",
       confidence: 0.54321
     }}
  end

  def code_to_name(code) do
    case code do
      "eng" -> {:ok, "English"}
      "fra" -> {:ok, "Français"}
      "spa" -> {:ok, "Español"}
      _ -> :not_found
    end
  end

  def code_to_eng_name(code) do
    case code do
      "eng" -> {:ok, "English"}
      "fra" -> {:ok, "French"}
      "spa" -> {:ok, "Spanish"}
      _ -> :not_found
    end
  end
end
