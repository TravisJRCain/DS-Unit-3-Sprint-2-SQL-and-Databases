import sqlite3
import os

DATABASE_FILEPATH = os.path.join(os.path.dirname(__file__), "..", "module1-introduction-to-sql", "rpg_db.sqlite3")
connection = sqlite3.connect(DATABASE_FILEPATH)
curs = connection.cursor()

#- How many total Characters are there?
query_1 = 'SELECT count(distinct character_id) FROM charactercreator_character'
result_1 = curs.execute(query_1).fetchall()[0]
print("There are", result_1[0], "total characters.")

#- How many of each specific subclass?
query_2 = 'SELECT count() FROM charactercreator_cleric'
result_2 = curs.execute(query_2).fetchall()[0]
print("There are", result_2[0], "clerics.")

query_2 = 'SELECT count() FROM charactercreator_fighter'
result_2 = curs.execute(query_2).fetchall()[0]
print("There are", result_2[0], "fighters.")

query_2 = 'SELECT count() FROM charactercreator_mage'
result_2 = curs.execute(query_2).fetchall()[0]
print("There are", result_2[0], "mages.")

query_2 = 'SELECT count() FROM charactercreator_necromancer'
result_2 = curs.execute(query_2).fetchall()[0]
print("There are", result_2[0], "necromancers.")

query_2 = 'SELECT count() FROM charactercreator_thief'
result_2 = curs.execute(query_2).fetchall()[0]
print("There are", result_2[0], "thieves.")

#- How many total Items?
query_1 = 'SELECT count(distinct item_id) FROM armory_item'
items = curs.execute(query1).fetchall()[0]
print("There are", items[0], "total items.")

#- How many of the Items are weapons? How many are not?
query_1 = 'SELECT count(distinct item_ptr_id) FROM armory_weapon'
weapons = curs.execute(query_1).fetchall()[0]
print("There are", weapons[0], "items that are weapons.")

nonweapons = items[0] - weapons[0]
print("There are", nonweapons, "items that are not weapons.")
#- How many Items does each character have? (Return first 20 rows)
query1 = '''SELECT 
  charactercreator_character_inventory.character_id
  ,count(distinct charactercreator_character_inventory.item_id) as itemcount
  ,count(distinct armory_weapon.item_ptr_id) as weaponcount
FROM charactercreator_character_inventory
LEFT JOIN armory_item ON charactercreator_character_inventory.item_id = armory_item.item_id
LEFT JOIN armory_weapon ON charactercreator_character_inventory.item_id = armory_weapon.item_ptr_id
GROUP BY charactercreator_character_inventory.character_id 
ORDER BY charactercreator_character_inventory.character_id 
LIMIT 20'''
table1 = curs.execute(query1).fetchall()

# for row in table1:
#     if row[1] > 1:
#         print ("Character", row[0], "has", row[1], "items.")
#     else:
#         print ("Character", row[0], "has", row[1], "item.")
    
#- How many Weapons does each character have? (Return first 20 rows)

query = '''SELECT 
  count(distinct character_id) as character_count -- 302
  ,avg(item_count) as avg_items -- 2.97
  ,avg(weapon_count) as avg_weapons -- 0.67
FROM (
    -- row per character (302 rows)
    -- one col for the char id, one for the char name, third for the weapon count
    SELECT 
      ch.character_id
      ,ch."name" as char_name
      -- ,inv.id 
      ,count(distinct inv.item_id) as item_count
      ,count(distinct w.item_ptr_id) as weapon_count
    FROM charactercreator_character ch
    LEFT JOIN charactercreator_character_inventory inv ON ch.character_id = inv.character_id
    LEFT JOIN armory_weapon w ON inv.item_id = w.item_ptr_id
    GROUP BY 1,2
) subq'''



#- On average, how many Items does each Character have?
query = '''SELECT 
  AVG(itemcount)
  ,avg(weaponcount)
FROM (
	SELECT 
  		charactercreator_character_inventory.character_id
 		,count(distinct charactercreator_character_inventory.item_id) as itemcount
  		,count(distinct armory_weapon.item_ptr_id) as weaponcount
		FROM charactercreator_character_inventory
		LEFT JOIN armory_item ON charactercreator_character_inventory.item_id = armory_item.item_id
		LEFT JOIN armory_weapon ON charactercreator_character_inventory.item_id = armory_weapon.item_ptr_id
		GROUP BY charactercreator_character_inventory.character_id 
		ORDER BY charactercreator_character_inventory.character_id 
) subq'''
table = curs.execute(query).fetchall()
print("On avereage each character has", table[0][0], "items.")
#- On average, how many Weapons does each character have?
print("On avereage each character has", table[0][1], "weapons.")