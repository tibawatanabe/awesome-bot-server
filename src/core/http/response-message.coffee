module.exports = () ->

  class ResponseMessage

    @APP_VERSION_NULL = "Não foi enviada corretamente a versão do app."
    @APP_VERSION_WRONG = "Seu aplicativo está desatualizado, por favor visite a loja para atualização."
    @DATABASE_ERROR = "Erro na conexão com o banco de dados."
    @EXPIRED_SESSION = "Sessão expirada."
    @INVALID_FIELD = (property) -> return "Campo incorreto #{property}."
    @SOMETHING_WENT_WRONG = "Não foi possível completar essa operação."
    @UNAUTHORIZED_ACCESS = "Acesso não autorizado."

    @USER_AUTHENTICATED = "Usuário autenticado com sucesso"
    @USER_INVALID_PASSWORD = "Usuário e/ou senha inválidos."

  Object.freeze(ResponseMessage)
