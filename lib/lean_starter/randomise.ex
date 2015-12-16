defmodule LeanStarter.Randomise do
  def random(number \\ 100) do
    :random.seed(:os.timestamp()); :random.uniform(number)
  end
end
