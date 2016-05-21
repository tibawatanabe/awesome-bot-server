module.exports = (Schema) ->
  jsonSchema =
    model: {"type": "string", "default": null}
    os: {"type": "string", "default": null}
    version: {"type": "string", "default": null}
    notes: {"type": "string", "default": null}
    owner: {"type": "string", "default": null}
    status: {"type": "string", "default": null}
    date: {"type": "string", "default": null}
    user: {"type": "string", "default": null}

  schema = Schema(jsonSchema)

  return schema
