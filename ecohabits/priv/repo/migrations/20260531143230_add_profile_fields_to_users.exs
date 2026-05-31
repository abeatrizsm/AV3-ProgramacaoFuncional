defmodule Ecohabits.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :bio, :text
      add :points, :integer, default: 0
    end
  end
end
