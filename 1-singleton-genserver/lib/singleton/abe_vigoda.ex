defmodule Singleton.AbeVigoda do
  use GenServer

  @check_every 60_000
  @pid {__MODULE__, Singleton.master_node}

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, opts
  end

  def alive? do
    GenServer.call @pid, :get
  end

  def init(:ok) do
    :timer.send_interval @check_every, :check
    send self, :check
    {:ok, :maybe}
  end

  def handle_info(:check, _state) do
    state = :alive # fake API call
    {:noreply, state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
