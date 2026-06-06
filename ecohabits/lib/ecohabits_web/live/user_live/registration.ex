defmodule EcohabitsWeb.UserLive.Registration do
  use EcohabitsWeb, :live_view

  alias Ecohabits.Accounts
  alias Ecohabits.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />

    <div class="flex min-h-screen bg-[#101318]">


    <div class="flex flex-col justify-center items-center w-full p-18">

    <.form
      for={@form}
      id="registration_form"
      phx-submit="save"
      phx-change="validate"
      class="w-full max-w-lg"
    >

      <h2 class="text-white text-4xl font-bold mb-3">
        Crie sua conta no EcoHabits
      </h2>

      <p class="text-gray-400 text-base">
        Comece hoje sua jornada rumo a hábitos mais sustentáveis.
      </p>

      <label class="block text-white mb-3 mt-10">
        Nome:
      </label>

      <input
        type="text"
        name="user[name]"
        value={@form[:name].value}
        placeholder="Digite seu nome..."
        class="w-full mb-6 px-4 py-3 rounded-xl bg-[#191d24] border border-[#2b303b] text-white placeholder-gray-300"
        required
      />

      <label class="block text-white mb-3">
        Email:
      </label>

      <input
        type="email"
        name="user[email]"
        value={@form[:email].value}
        placeholder="Digite seu email..."
        class="w-full mb-6 px-4 py-3 rounded-xl bg-[#191d24] border border-[#2b303b] text-white placeholder-gray-300 focus:ring-2 focus:ring-green-500"
        required
      />

      <label class="block text-white mb-3">
        Senha:
      </label>

      <input
        type="password"
        name="user[password]"
        placeholder="Crie uma senha..."
        class="w-full mb-10 px-4 py-3 rounded-xl bg-[#191d24] border border-[#2b303b] text-white placeholder-gray-300"
        required
      />

      <button
        type="submit"
        class="w-full text-white bg-gradient-to-r from-green-600 to-green-400 hover:from-green-700 hover:to-green-800 py-3 rounded-xl font-semibold"
      >
        Criar minha conta
      </button>

      <div class="text-center flex justify-center items-center mt-8 gap-2">

        <p class="text-gray-400">
          Já possui uma conta?
        </p>

        <.link
          navigate={~p"/users/log-in"}
          class="text-green-500 hover:text-green-400 font-semibold"
        >
          Entrar
        </.link>

      </div>

    </.form>

    </div>


    </div>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: EcohabitsWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Conta criada com sucesso!"
         )
         |> push_navigate(to: ~p"/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end
