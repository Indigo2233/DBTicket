module TicketsController
using Genie.Renderer.Html, SearchLight, Genie.Renderer.Json
using SearchLight.QueryBuilder
using Tickets, TicketTypes
using Dates

function allTickets()
    sleep(0.02)
    tickets = all(Ticket)
    Dict("code" => 0, 
         "data" => [Dict(vcat([("tid", t.id.value)], 
                            [(k_name, getfield(t, k_name)) 
                                for k_name in fieldnames(eltype(tickets))])) 
                            for t in tickets]) |> json
end


function getOne(tid)
    ticket = SearchLight.find(Ticket, where("id = ?", tid))[1]
    # println(ticket)
    Dict("code" => 0,
         "data" => Dict(vcat([("tid", ticket.id.value)], 
                        [(k_name, getfield(ticket, k_name)) 
                        for k_name in fieldnames(typeof(ticket))])) 
         ) |> json
end

function search(map)
    isFather = true
    keyword = "%" * get(map, "keyword", "") * "%"
    query = where("ticketName LIKE ?", keyword)

    type, city, bg, ed = get.(Ref(map), ["type", "city", "beginTime", "endTime"], "") 
    (type == "全部") && (type = "") 
    (city !== nothing && city != "全部") && (query += where("city = ?", city))
    if get(map, "sonType", "") !== nothing && get(map, "sonType", "") != "全部" 
        type = get(map, "sonType", "")
        query += where("typeName = ?", type)
    elseif type !== nothing
        sonTypes = SearchLight.find(TicketType, where("fatherName = ?", type)) 
        # println(join([t.typeName for t in sonTypes], "', '"))
        statement = "typeName in ('" * join([t.typeName for t in sonTypes], "', '") * "')"
        query += where(statement)
    end
    
    beginTime, endTime = DateTime(1800), DateTime(1800)
    if bg !== nothing
        beginTime = DateTime(replace(bg, " " => "T"))
        endTime = DateTime(replace(ed, " " => "T"))
        query += where("beginTime > ?", beginTime) + where("endTime < ?", endTime)
    end
    # println(query)
    tickets = SearchLight.find(Ticket, query)
    Dict("code" => 0, 
    "data" => [Dict(vcat([("tid", t.id.value)], 
                       [(k_name, getfield(t, k_name)) 
                           for k_name in fieldnames(eltype(tickets))])) 
                       for t in tickets]) |> json
end
end

