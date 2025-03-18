defmodule TTS.Runner do
  alias TTS.PhonemeMap
  alias TTS.Model
  alias Nx
  alias Ortex

  def run(text, output_path) do
    #Application.put_env(:ortex, :priv_path, "/home/tiago/Projects/flash_cards_voice_generator/deps/ortex/priv")

    phonemes_text = PhonemeMap.text_to_phonemes(text)

    # Load phoneme map
    phoneme_map = PhonemeMap.load_phoneme_map()

    # Convert text to phoneme IDs
    phoneme_ids = PhonemeMap.text_to_phoneme_ids(phonemes_text, phoneme_map)

    #IO.inspect(phoneme_ids)

    # Load the ONNX model
    model = Model.load_model()
    #IO.inspect(model)

    # Run inference
    input_tensor = Nx.tensor([phoneme_ids], type: :s64) |> Nx.backend_transfer(Ortex.Backend)
    input_lengths = Nx.tensor([length(phoneme_ids)], type: :s64) |> Nx.backend_transfer(Ortex.Backend)
    scales = Nx.tensor([0.667, 1, 0.8], type: :f32) |> Nx.backend_transfer(Ortex.Backend)

    case Ortex.run(model, {input_tensor, input_lengths, scales}) do
      {output} ->
        IO.puts("Inference successful.")
        #IO.inspect(output, label: "Model Outputs")
        AudioConverter.tensor_to_wav(output, output_path)
        :ok
      {:error, reason} ->
        IO.puts("Inference failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

end
