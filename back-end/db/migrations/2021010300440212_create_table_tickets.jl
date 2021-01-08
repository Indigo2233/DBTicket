module CreateTableTickets

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:tickets) do
    [
      primary_key()
      column(:availableNumber, :int)
      column(:beginTime, :datetime)
      column(:city, :string, limit=5)
      column(:detail, :string, limit=5000)
      column(:endTime, :datetime)
      column(:price, :int)
      column(:ticketName, :string, limit=64)
      column(:typeName, :string, limit=12)
      column(:venues, :string, limit=50)
      column(:poster, :string, limit=255)
    ]
  end

  add_index(:tickets, :typeName)
end

function down()
  drop_table(:tickets)
end

end
