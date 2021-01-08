module CreateTableOrders

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table

function up()
  create_table(:orders) do
    [
      primary_key()
      column(:ticketId, :int)
      column(:userId, :string, limit = 20)
      column(:dealTime, :datetime)
    ]
  end

  add_index(:orders, :userId)
end

function down()
  drop_table(:orders)
end

end
