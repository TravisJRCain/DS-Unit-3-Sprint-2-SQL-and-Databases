import os
from dotenv import load_dotenv
import psycopg2

load_dotenv()

DB_NAME= os.getenv('DB_NAME', default='OOPS')
DB_USER= os.getenv('DB_USER', default='OOPS')
DB_PW = os.getenv('DB_PW', default='OOPS')
DB_HOST= os.getenv('DB_HOST', default='OOPS')


# print(DB_NAME)
# print(DB_USER)
# print(DB_PW)
# print(DB_HOST)

# exit()


### Connect to ElephantSQL-hosted PostgreSQL
connection = psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PW, host=DB_HOST)
print(type(connection))

### A "cursor", a structure to iterate over db records to perform queries
cursor = connection.cursor()
print(type(cursor))

### An example query
cursor.execute('SELECT * from test_table;')

### Note - nothing happened yet! We need to actually *fetch* from the cursor
# results = cursor.fetchall()
# for row in results:
#     print(type(row), row)



### Inserting data ###

my_dict = { "a": 1, "b": ["dog", "cat", 42], "c": 'true' }


# insertion_query = f"INSERT INTO test_table (name, data) VALUES (%s, %s)"
# cursor.execute(insertion_query,
#  ('A rowwwww', 'null')
# )
# cursor.execute(insertion_query,
#  ('Another row, with JSONNNNN', json.dumps(my_dict)) # converting dictionary to string
# )

exit()

# h/t: https://stackoverflow.com/questions/8134602/psycopg2-insert-multiple-rows-with-one-query
insertion_query = f"INSERT INTO test_table (name, data) VALUES %s"
execute_values(cursor, insertion_query, [
 ('A rowwwww', 'null'),
 ('Another row, with JSONNNNN', json.dumps(my_dict)),
 ('Third row', "3")
])

df = pd.DataFrame([
  ['A rowwwww', 'null'],
  ['Another row, with JSONNNNN', json.dumps(my_dict)],
  ['Third row', "null"],
  ["Pandas Row", "null"]
])

records = df.to_dict("records") #> [{0: 'A rowwwww', 1: 'null'}, {0: 'Another row, with JSONNNNN', 1: '{"a": 1, "b": ["dog", "cat", 42], "c": "true"}'}, {0: 'Third row', 1: '3'}, {0: 'Pandas Row', 1: 'YOOO!'}]
list_of_tuples = [(r[0], r[1]) for r in records]

execute_values(cursor, insertion_query, list_of_tuples)

#
# QUERY THE TABLE
#

print("-------------------")
query = f"SELECT * FROM {table_name};"
print("SQL:", query)
cursor.execute(query)
for row in cursor.fetchall():
    print(row)

# ACTUALLY SAVE THE TRANSACTIONS
connection.commit()

cursor.close()
connection.close()