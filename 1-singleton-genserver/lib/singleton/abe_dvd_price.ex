defmodule Singleton.AbeDVDPrice do
  use GenServer

  @pid __MODULE__

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, opts
  end

  def get do
    GenServer.call @pid, :get
  end

  def init(:ok) do
    {:ok, :irrelevant}
  end

  def handle_call(:get, _from, state) do
    price = if Singleton.AbeVigoda.alive? do
      1_000
    else
      100
    end
    {:reply, price, state}
  end
end
