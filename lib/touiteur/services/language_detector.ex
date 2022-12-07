defmodule Touiteur.Services.LanguageDetector do
  @moduledoc """
  Service of language detection.
  """

  @detection_engine Application.compile_env(:touiteur, :language_detection_engine, Whatlangex)

  @doc """
  Detect the language of the sentence.

  ## Examples

      iex> detect("This is a nice sentence.")
      "eng"

      iex> detect("")
      "?"

  """
  @spec detect(String.t()) :: {:ok, Whatlangex.Detection.t()} | :not_found
  def detect(sentence) do
    @detection_engine.detect(sentence)
  end

  @doc """
  Get the humanized language name by code.

  ## Examples

      iex> code_to_name("eng")
      "English"

      iex> code_to_name("abc")
      "?"

  """
  @spec code_to_name(String.t()) :: {:ok, String.t()} | :none
  def code_to_name(code) do
    @detection_engine.code_to_name(code)
  end
end
