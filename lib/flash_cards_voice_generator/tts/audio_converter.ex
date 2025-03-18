defmodule AudioConverter do
  @sample_rate 22050

  @doc """
  Convert an Nx tensor to an audio file.

  ## Parameters
  - tensor: Nx tensor containing audio data
  - output_path: Path where the audio file will be saved
  - sample_rate: Audio sample rate (default: 16000)

  ## Example
  ```elixir
  # Assuming you have your Ortex tensor
  tensor = %Nx.Tensor{...}
  AudioConverter.tensor_to_wav(tensor, "output.wav")
  ```
  """
  def tensor_to_wav(tensor, output_path) do
    # Ensure the tensor is a 1D or 2D tensor
    flattened_tensor =
      tensor
      |> Nx.reshape({:auto})  # Flatten the tensor
      |> Nx.to_flat_list()    # Convert to list

    # Normalize audio data to 16-bit PCM range
    normalized_data =
      flattened_tensor
      |> Enum.map(fn sample ->
        # Scale from float (-1 to 1) to 16-bit integer range
        trunc(sample * 32767)
      end)

    # Convert to binary data (16-bit little-endian PCM)
    binary_data =
      normalized_data
      |> Enum.map(fn sample ->
        <<sample::signed-little-size(16)>>
      end)
      |> Enum.join()

    # Prepare WAV file header
    num_channels = 1
    bits_per_sample = 16
    byte_rate = @sample_rate * num_channels * bits_per_sample / 8
    block_align = num_channels * bits_per_sample / 8

    wav_header =
      "RIFF" <>
      <<byte_size(binary_data) + 36::unsigned-little-size(32)>> <>
      "WAVE" <>
      "fmt " <>
      <<16::unsigned-little-size(32)>>  # Chunk size
      <><<1::unsigned-little-size(16)>>  # Audio format (PCM)
      <><<num_channels::unsigned-little-size(16)>>
      <><<@sample_rate::unsigned-little-size(32)>>
      <><<trunc(byte_rate)::unsigned-little-size(32)>>
      <><<trunc(block_align)::unsigned-little-size(16)>>
      <><<bits_per_sample::unsigned-little-size(16)>>
      <>"data" <>
      <<byte_size(binary_data)::unsigned-little-size(32)>>

    # Write the WAV file
    File.write!(output_path, wav_header <> binary_data)

    :ok
  end

  @doc """
  Convert an Nx tensor to a raw audio file.

  ## Parameters
  - tensor: Nx tensor containing audio data
  - output_path: Path where the raw audio file will be saved
  - sample_width: Bytes per sample (default: 2 for 16-bit)

  ## Example
  ```elixir
  # Assuming you have your Ortex tensor
  tensor = %Nx.Tensor{...}
  AudioConverter.tensor_to_raw(tensor, "output.raw")
  ```
  """
  def tensor_to_raw(tensor, output_path) do
    # Flatten and normalize the tensor
    raw_data =
      tensor
      |> Nx.reshape({:auto})  # Flatten the tensor
      |> Nx.to_flat_list()    # Convert to list
      |> Enum.map(fn sample ->
        # Scale from float (-1 to 1) to 16-bit integer range
        trunc(sample * 32767)
      end)
      |> Enum.map(fn sample ->
        <<sample::signed-little-size(16)>>
      end)
      |> Enum.join()

    # Write the raw audio file
    File.write!(output_path, raw_data)

    :ok
  end
end
