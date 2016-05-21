module.exports = (Schema) ->
  jsonSchema =
    name: {"type": "string", "default": null}
    email: {"type": "string", "default": null, "unique": true}
    password: {"type": "string", "default": null}

  schema = Schema(jsonSchema)

  return schema
