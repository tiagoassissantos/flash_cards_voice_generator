defmodule Integrations do
  defmodule AnkiClient do
    @anki_connect_url "http://localhost:8765"
    @deck_name "English"

    def create_card(text, audio_path) do
      with {:ok, audio_data} <- File.read(audio_path),
          audio_base64 = Base.encode64(audio_data),
          {:ok, filename} <- create_media(audio_base64),
          :ok <- create_note(filename, text) do
        {:ok, "Card created successfully"}
      else
        error -> {:error, "Failed to create card: #{inspect(error)}"}
      end
    end

    defp create_media(audio_base64) do
      filename = "audio_#{:os.system_time(:millisecond)}.wav"

      payload = %{
        action: "storeMediaFile",
        version: 6,
        params: %{
          filename: filename,
          data: audio_base64
        }
      }

      case make_request(payload) do
        {:ok, _} -> {:ok, filename}
        error -> error
      end
    end

    defp create_note(audio_filename, text) do
      payload = %{
        action: "addNote",
        version: 6,
        params: %{
          note: %{
            deckName: @deck_name,
            modelName: "Basic",
            fields: %{
              "Front" => "[sound:#{audio_filename}]",
              "Back" => text
            },
            options: %{
              allowDuplicate: false
            },
            tags: ["voice-generated"]
          }
        }
      }

      case make_request(payload) do
        {:ok, _} -> :ok
        error -> error
      end
    end

    defp make_request(payload) do
      headers = [{"Content-Type", "application/json"}]

      case HTTPoison.post(@anki_connect_url, Jason.encode!(payload), headers) do
        {:ok, %{status_code: 200, body: body}} ->
          case Jason.decode(body) do
            {:ok, %{"error" => nil, "result" => result}} -> {:ok, result}
            {:ok, %{"error" => error}} -> {:error, error}
            error -> error
          end
        error -> error
      end
    end
  end
end
