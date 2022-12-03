defmodule Touiteur.Repo.Migrations.AddNameToAccountsUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, size: 32
    end

    create unique_index(:users, [:name])
  end
end
