defmodule Touiteur.Services.LanguageDetector do
  @moduledoc """
  Service of language detection.
  """

  defmodule Detection do
    @moduledoc """
    Module of the internal detection type.
    """

    @type t :: %__MODULE__{
            lang: String.t(),
            script: String.t(),
            confidence: float
          }

    defstruct [:lang, :script, :confidence]

    def convert_from_whatlangex_detection(whatlang_detection) do
      case whatlang_detection do
        :none -> :none
        {:ok, detection} -> {:ok, %{detection | __struct__: __MODULE__}}
      end
    end
  end

  @doc """
  Detect the language of the sentence.

  ## Examples

      iex> detect("This is a nice sentence.")
      %LanguageDetector.Detection{
        lang: "eng",
        script: "Latin",
        confidence: 0.3456
      }

      iex> detect("")
      :none

  """
  @spec detect(String.t()) :: {:ok, Detection.t()} | :not_found
  def detect(sentence) do
    Whatlangex.detect(sentence)
    |> Detection.convert_from_whatlangex_detection()
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
