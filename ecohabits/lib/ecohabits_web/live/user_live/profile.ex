defmodule EcohabitsWeb.UserLive.Profile do
  use EcohabitsWeb, :live_view

  alias Ecohabits.Accounts

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user

    {:ok,
     assign(socket,
       user: user,
       name: user.name || "",
       bio: user.bio || ""
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
    <div class="bg-[#101318] min-h-screen p-12">

      <h2 class="text-white font-bold text-5xl mb-8">
        Meu Perfil
      </h2>

      <div class="flex gap-7">

        <div class="flex flex-col p-6 bg-[#191d24] border border-[#2b303b] rounded-2xl w-screen gap-4">

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

      </div>

    </div>
    """
  end
end
