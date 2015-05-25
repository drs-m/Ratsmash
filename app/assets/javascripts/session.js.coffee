$ ->

    emailLogin = $("#login-form").find("#email")
    if emailLogin.length
      emailLogin.focus()

    $("#login-form").submit (event) ->
        event.preventDefault()
        email = $("#email").val()
        return if email == ""
        password = $("#password").val()
        $.post "/login.json",
            email: email
            password: password
            (data, textStatus, jqXHR) ->
                if data.status == "error"
                    $("#error-msg").text(data.message)
                    $("#error-msg").fadeIn()
                    $("#login-form").effect("shake")
                else if data.status == "success"
                    window.location = data.path
