defmodule Touiteur.Services.LanguageDetectorTest do
  alias Touiteur.Services.LanguageDetector
  use ExUnit.Case, async: true

  import Touiteur.Services.LanguageDetector

  @sentences %{
    eng: "Start with a simple sentence, it's good enough for now.",
    fra: "Commence avec une phrase simple, ça suffit.",
    spa: "Comience con una oración simple, es lo suficientemente bueno por ahora."
  }

  describe "#detect" do
    test "returns a language code if not empty sentence" do
      for {_, sentence} <- @sentences do
        {:ok, detection} = LanguageDetector.detect(sentence)
        assert detection.lang =~ ~r/^...$/
      end
    end

    test "returns a confidence code if not empty sentence" do
      for {_, sentence} <- @sentences do
        {:ok, detection} = LanguageDetector.detect(sentence)
        assert detection.confidence >= 0
        assert detection.confidence <= 1
      end
    end

    test "return :none if empty sentence" do
      assert detect("") == :none
    end
  end

  describe "#code_to_name" do
    test "returns a humaized language string" do
      assert code_to_name("eng") == {:ok, "English"}
      assert code_to_name("fra") == {:ok, "Français"}
      assert code_to_name("spa") == {:ok, "Español"}
    end

    test "returns :not_found if unknown code" do
      assert code_to_name("abc") == :not_found
    end
  end

  describe "#code_to_eng_name" do
    test "returns a humaized language string" do
      assert code_to_eng_name("eng") == {:ok, "English"}
      assert code_to_eng_name("fra") == {:ok, "French"}
      assert code_to_eng_name("spa") == {:ok, "Spanish"}
    end

    test "returns :not_found if unknown code" do
      assert code_to_eng_name("abc") == :not_found
    end
  end
end
