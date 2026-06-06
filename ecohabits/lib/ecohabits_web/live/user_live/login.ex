defmodule EcohabitsWeb.UserLive.Login do
  use EcohabitsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />

    <div class="flex min-h-screen bg-[#101318]">
    <div class="flex flex-col justify-center items-center w-full p-20 ">
    <.form
      for={%{}}
      action={~p"/users/log-in"}
      class="w-full max-w-md"
    >
      <h2 class="text-white text-4xl font-bold mb-3 tex">
        Bem-vindo ao EcoHabits!
      </h2>

      <p class="text-gray-400 text-base">
        Entre para transformar suas ações diárias em impacto real.
      </p>

      <label class="block text-white mb-3 mt-10">
        Email:
      </label>

      <input
        type="email"
        name="user[email]"
        placeholder="Insira seu email..."
        class="w-full mb-6 px-4 py-3 rounded-xl bg-[#191d24] border border-[#2b303b] text-white placeholder-gray-300 focus:ring-2 focus:ring-green-500"
        required
      />

      <label class="block text-white mb-3">
        Senha:
      </label>

      <input
        type="password"
        name="user[password]"
        placeholder="Insira sua senha..."
        class="w-full rounded-xl mb-10 px-4 py-3 bg-[#191d24] border border-[#2b303b] text-white placeholder-gray-300"
        required
      />

      <button
        type="submit"
        name="user[remember_me]"
        value="true"
        class="w-full text-white bg-gradient-to-r from-green-600 to-green-400 hover:from-green-700 hover:to-green-800 py-3 rounded-xl font-semibold"
      >
        Começar sua mudança
      </button>

      <div class="text-center flex justify-center items-center mt-8 gap-2">
        <p class="text-gray-400">
          Não possui uma conta?
        </p>

        <a
          href="/users/register"
          class="text-green-500 hover:text-green-400 font-semibold"
        >
          Criar conta
        </a>
      </div>
    </.form>
    </div>
    </div>

    """
  end
end
