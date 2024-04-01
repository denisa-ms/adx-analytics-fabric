CREATE TABLE SalesLT.TablesCDC (
    TableName varchar(255),
    DateCopied datetime
);

INSERT INTO SalesLT.TablesCDC (TableName, DateCopied)
VALUES ('Address', '1900-01-01 00:00'),
 ('Customer', '1900-01-01 00:00'),
 ('SalesOrderHeader', '1900-01-01 00:00'),
 ('SalesOrderDetail', '1900-01-01 00:00')