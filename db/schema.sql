CREATE TRIGGER account_updated_at
AFTER UPDATE
ON account FOR EACH ROW
BEGIN
  UPDATE account SET updated_at = strftime('%s', 'now')
    WHERE id = old.id;
END
CREATE TABLE schema_migrations (version text primary key)
CREATE TABLE account (
  id integer primary key,
  email text unique not null,
  password text not null,
  verified integer not null default 0,
  public_id text unique not null default(hex(randomblob(8))),
  created_at integer not null default(strftime('%s', 'now')),
  updated_at integer not null default(strftime('%s', 'now'))
)