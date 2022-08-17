import sys
import logging
import pymysql

# rds settings
rds_host = "testing-db.00000000.us-east-1.rds.amazonaws.com"
name = "admin"
password = "Test1234"
db_name = "challenge"

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# connect using creds
try:
    conn = pymysql.connect(host=rds_host, user=name, password=password, database=db_name, connect_timeout=5)

except:
    logger.error("ERROR: Unexpected error: Could not connect to MySql instance.")
    sys.exit()

logger.info("SUCCESS: Connection to RDS mysql instance succeeded")


# executes upon API event
def lambda_handler(event, context):
    path = event['params']['path']['name']
    table = path.split('/')[0]
    record = path.split('/')[1]

    with conn.cursor() as cur:
        cur.execute("SELECT name,owner,species FROM {} WHERE name='{}'".format(table, record))
    conn.commit()

    for row in cur:
        record = {
            "name": row[0],
            "owner": row[1],
            "specie": row[2]
        }

    return record
