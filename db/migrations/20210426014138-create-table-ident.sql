-- up
create table account (
  id integer primary key,
  email text unique not null,
  password text not null,
  verified integer not null default 0,
  public_id text unique not null default(hex(randomblob(8))),
  created_at integer not null default(strftime('%s', 'now')),
  updated_at integer not null default(strftime('%s', 'now'))
)

-- down
drop table account