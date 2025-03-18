defmodule TTS.Model do
  @model_path "priv/static/models/en_US-ryan-high.onnx"

  def load_model do
    model = Ortex.load(@model_path)
    model
  end
end
