defmodule TTS.PhonemeMap do
  @json_file "priv/static/models/en_en_US_ryan_high_en_US-ryan-high.onnx.json"

  def load_phoneme_map do
    @json_file
    |> File.read!()
    |> Jason.decode!()
    |> Map.get("phoneme_id_map")
    |> Enum.into(%{}, fn {k, v} -> {k, List.first(v)} end)
  end

  def text_to_phoneme_ids(text, phoneme_map) do
    text
    |> String.downcase()
    |> String.graphemes()
    |> Enum.map(&Map.get(phoneme_map, &1, 0))
    |> adjust_phoneme_ids()
    |> prepend_and_append_ids()
  end

  def adjust_phoneme_ids(phoneme_ids) do
    Enum.reduce(phoneme_ids, [], fn x, acc -> [x, 0 | acc] end)
    |> Enum.reverse()
  end

  defp prepend_and_append_ids(ids) do
    [1 | ids ++ [0, 2]]
  end

  def text_to_phonemes(text) do
    {phonemes, 0} = System.cmd("espeak", ["--ipa", "-v", "en-us", "-q", text])
    phonemes |> String.trim()
  end
end
