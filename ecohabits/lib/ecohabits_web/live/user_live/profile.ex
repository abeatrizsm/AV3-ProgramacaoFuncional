defmodule EcohabitsWeb.UserLive.Profile do
  use EcohabitsWeb, :live_view

  alias Ecohabits.Accounts

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user

    days_in_ecohabits =
      Date.diff(
        Date.utc_today(),
        DateTime.to_date(user.inserted_at)
      )

    {:ok,
     assign(socket,
       user: user,
       name: user.name || "",
       bio: user.bio || "",
       days_in_ecohabits: days_in_ecohabits
     )}
  end

  @impl true
  def handle_event(
        "save",
        %{
          "name" => name,
          "bio" => bio
        },
        socket
      ) do
    user = socket.assigns.user

    attrs = %{
      "name" => name,
      "bio" => bio
    }

    case Accounts.update_user_profile(user, attrs) do
      {:ok, updated_user} ->
        {:noreply,
         socket
         |> assign(user: updated_user)
         |> assign(name: updated_user.name)
         |> assign(bio: updated_user.bio || "")
         |> put_flash(:info, "Perfil atualizado com sucesso!")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Erro ao atualizar perfil")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen">
      <.sidebar current_scope={@current_scope} />
    <div class="bg-[#101318] min-h-screen ml-64 px-28 py-18 flex-1 p-12">

      <h2 class="text-white font-bold text-4xl mb-8">
        Meu Perfil
      </h2>

      <div class="flex flex-col gap-7">

        <div class="flex flex-col p-6 bg-[#191d24] border border-[#2b303b] rounded-2xl w-full gap-4">

          <h2 class="text-white text-2xl font-semibold">
            Informações Pessoais
          </h2>

          <form phx-submit="save">

            <div class="flex gap-6 mt-4">

              <div class="flex flex-col w-1/2">

                <label class="text-white font-semibold mb-2">
                  Nome Completo
                </label>

                <input
                  type="text"
                  name="name"
                  value={@name}
                  class="bg-[#101318] border  rounded-xl p-3 border-gray-700 text-white mb-4"
                />



                <label class="text-white font-semibold mb-2">
                  Email
                </label>

                <input
                  type="email"
                  value={@user.email}
                  disabled
                  class="bg-[#101318] border border-gray-700 rounded-xl p-3 text-gray-400 mb-4"
                />

              </div>

              <div class="flex flex-col w-1/2">

                <label class="text-white font-semibold mb-2">
                  Bio
                </label>

                <textarea
                  name="bio"
                  rows="5"
                  class="bg-[#101318] border border-gray-700 rounded-xl p-3 text-white"
                ><%= @bio %></textarea>

              </div>

            </div>

            <button
              type="submit"
              class="bg-green-600 hover:bg-green-700 rounded-xl text-white w-full h-12 mt-6 font-semibold"
            >
              Salvar Alterações
            </button>

          </form>

        </div>
        <div class="flex gap-6 mt-8">
          <div class="bg-[#191d24] border border-[#2b303b] rounded-2xl p-6 w-full">
            <h3 class="text-white text-xl font-semibold mb-6">
              Estatísticas
            </h3>

            <div class="grid grid-cols-2 gap-8">

              <div>
                <p class="text-gray-400">
                  Pontuação Total
                </p>

                <p class="text-4xl font-bold text-green-500 mt-2">
                  <%= @user.points %>
                </p>
              </div>

              <div>
                <p class="text-gray-400">
                  Dias no EcoHabits
                </p>

                <p class="text-4xl font-bold text-blue-500 mt-2">
                  <%= @days_in_ecohabits %>
                </p>
              </div>

            </div>

          </div>

        </div>
      </div>

    </div>
    </div>
    """
  end
end
