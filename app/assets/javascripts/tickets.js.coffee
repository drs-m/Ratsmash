$ ->
    $(".sort-tickets-student").on "click", ->
        ticketTableBody = $("#ticket-table").find("tbody")
        rows = ticketTableBody.find("tr")
        rows.detach()
        rows.sort (a, b) ->
            name1 = $(a).find("td.student-name").text()
            name2 = $(b).find("td.student-name").text()
            if name1 < name2 then return -1
            if name1 > name2 then return 1
            return 0

        rows.appendTo ticketTableBody
