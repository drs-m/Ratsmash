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
        admin: [:green, :checkmark], # admin-rechte vergeben
        noadmin: [:red, :cross], # keine admin-rechte
        closed: [:red, :cross], # account/kategorie gesperrt
        inactive: [:black, :circle], # keine registrierungsmail gesendet
        pending: [:yellow, :progress_circle], # registrierungsmail gesendet aber nicht aktiv
        active: [:green, :checkmark] # account wurde aktiviert
    }

    def symbol(state)
        color = STATES[state][0]
        type = STATES[state][1]
        return raw("<span class='symbol #{state}' style='color:#{COLORS[color]};'>#{CODES[type]}</span>")
    end

    def admin_symbol(student)
        if student.admin_permissions
            symbol :admin
        else
            symbol :noadmin
        end
    end

    def member_symbol(student)
        if student.closed
            return symbol :closed
        end
        
        if student.password_digest.present?
            symbol :active
        else
            if student.password_reset_token.present?
                symbol :pending
            else
                symbol :inactive
            end
        end
    end

    # for teachers and categories
    def closed_symbol(closeable)
        if closeable.closed
            symbol :closed
        else
            symbol :active
        end
    end

end
