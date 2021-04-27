-- up
CREATE TRIGGER account_updated_at
AFTER UPDATE
ON account FOR EACH ROW
BEGIN
  UPDATE account SET updated_at = strftime('%s', 'now')
    WHERE id = old.id;
END

-- down
DROP TRIGGER account_updated_at
