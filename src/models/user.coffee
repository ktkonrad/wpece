require('../lib/db')

User = db.define "person",
  {
    "email" : {"type": "string"},
    "salt" : {"type": "string"},
    "password" : {"type": "string"}
  }
