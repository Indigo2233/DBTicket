module OrdersController
using SearchLight, Genie.Renderer.Json, Genie.Sessions
using SearchLight.QueryBuilder
using Tickets, Orders
using Dates, Genie

function create(params)
  tid = parse(Int, get(params, :ticketId, "0"))
  ticket = SearchLight.find(Ticket, where("id = ?", tid))[1] 
  if ticket.availableNumber == 0
    return Dict("code" => 3, "msg" => "售罄") |> json
  elseif ticket.endTime < now() 
    return Dict("code" => 3, "msg" => "时间已过！") |> json
  else
    ticket.availableNumber -= 1
    ticket |> save!
    Order(ticketId = tid, userId = params[:userId], dealTime = DateTime(now())) |> save!    

    return Dict("code" => 0, "msg" => "购买成功！") |> json
  end
end

function getOrders(params)
  orders = SearchLight.find(Order, where("userId = ?", params[:userId]))
  ticketNames = String[]
  for o in orders
    push!(ticketNames, SearchLight.find(Ticket, where("id = ?", o.ticketId))[1].ticketName)
  end
  println(ticketNames)
  Dict("code" => 0, 
      "data" => [Dict("orderId" => orders[i].id.value, "ticketName" => ticketNames[i],
                "ticketId" => orders[i].ticketId, "time" => orders[i].dealTime) 
                for i in 1:length(ticketNames)]) |> json
end

function delete(params)
  order = find(Order, where("id = ?", params[:orderId]))[1]

  tid = order.ticketId
  ticket = SearchLight.find(Ticket, where("id = ?", tid))[1]
  if ticket.endTime < now()
    return Dict("code" => 3, "msg" => "过期了！") |> json
  else
    ticket.availableNumber += 1
    SearchLight.delete(order)
    return Dict("code" => 0, "msg" => "退订成功！") |> json
  end
end

end
