defmodule Touiteur.Services.LanguageDetectorTest do
  use ExUnit.Case, async: true

  import Touiteur.Services.LanguageDetector

  @sentences %{
    eng: "Start with a simple sentence, it's good enough for now.",
    fra: "Commence avec une phrase simple, ça suffit.",
    spa: "Comience con una oración simple, es lo suficientemente bueno por ahora."
  }

  describe "#detect" do
    test "returns a language code if not empty sentence" do
      assert detect(@sentences.eng) =~ ~r/.../
      assert detect(@sentences.fra) =~ ~r/.../
      assert detect(@sentences.spa) =~ ~r/.../
    end

    test "return ? if empty sentence" do
      assert detect("") == "?"
    end
  end

  describe "#code_to_name" do
    test "returns a humaized language string" do
      assert code_to_name("eng") == "English"
      assert code_to_name("fra") == "Français"
      assert code_to_name("spa") == "Español"
    end

    test "returns ? if unknown code" do
      assert code_to_name("abc") == "?"
    end
  end
end
