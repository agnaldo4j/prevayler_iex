defmodule Prevalent.Journaling do

    defp write_binary(file_name, binary_data) do
        {:ok, file} = File.open file_name, [:write]
        IO.binwrite file, :erlang.term_to_binary(binary_data)
        File.close file
    end

    def log_command(command) do
        {:ok, str_time} = Timex.format(Timex.now, "{ISO:Extended}")
        File.mkdir_p("commands")
        File.cd!("commands", fn() -> write_binary("command_"<>str_time<>".dat", command) end)
    end

    def load_snapshot() do
        File.cd!("snapshot", fn() ->
            case File.read("prevalent_system.dat") do
                {:ok, system_binary} -> :erlang.binary_to_term(system_binary)
                {:error, error} -> %{}
            end
        end)
    end

    def take_snapshot(actual_state) do
      File.mkdir_p("snapshot")
      File.cd!("snapshot", fn() -> write_binary("prevalent_system.dat", actual_state) end)
    end

    def delete_all_commands() do
      File.cd!("commands", fn() ->
          {:ok, list_of_commands} = File.ls(".")
          Enum.each(list_of_commands, fn(path) -> File.rm(path) end)
      end)
    end

    def load_list_of_commands() do
        File.cd!("commands", fn() ->
            {:ok, list_of_commands} = File.ls(".")
            list_of_commands
        end)
    end

    def load_command(path) do
      {:ok, binary} = File.cd!("commands", fn() -> File.read(path) end)
      :erlang.binary_to_term(binary)
    end
end