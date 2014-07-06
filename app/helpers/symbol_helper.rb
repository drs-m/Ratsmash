# encoding: utf-8
module SymbolHelper

    CODES = {
        checkmark: "&#x2713",
        cross: "&#x2717",
        #circle: "&#xffee",
        circle: "&#x25CF",
        progress_circle: "&#x27f3",
        flag: "&#x2691"
    }

    COLORS = {
        green: "#00ff00",
        orange: "#ff8a24",
        yellow: "#ffff00",
        red: "#d11313",
        black: "#000000"
    }

    # key: zustand
    STATES = {
        right: [:green, :checkmark],
        wrong: [:red, :cross],
        inactive: [:black, :circle],
        pending: [:yellow, :progress_circle]
    }

    def symbol(state, options = {})
        color = STATES[state][0]
        type = STATES[state][1]
        return raw("<span class='symbol #{state}' title='#{options[:hover]}' style='color:#{COLORS[color]};'>#{CODES[type]}</span>")
    end

    def simple_symbol(options)
        if options[:condition]
            symbol :right, hover: "Ja"
        else
            symbol :wrong, hover: "Nein"
        end
    end

    def member_symbol(student)
        if student.closed
            return symbol :wrong, hover: "gesperrt"
        end
        
        if student.password_digest.present?
            symbol :right, hover: "aktiv"
        else
            if student.password_reset_token.present?
                symbol :pending, hover: "Mail verschickt"
            else
                symbol :inactive, hover: "inaktiv" # noch keine registrierungmail verschickt
            end
        end
    end

    # for teachers and categories
    def closed_symbol(closeable)
        if closeable.closed
            symbol :wrong
        else
            symbol :right
        end
    end

    def description_status_symbol(description)
        case description.status
            when -1
                symbol :wrong, hover: "Abgelehnt"
            when 0
                symbol :pending, hover: "Noch nicht eingeordnet"
            when 1
                symbol :right, hover: "Angenommen"
        end
    end

end
