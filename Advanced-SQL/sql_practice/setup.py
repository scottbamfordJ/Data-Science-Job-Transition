import sqlite3
import random
from datetime import datetime, timedelta

random.seed(42)

conn = sqlite3.connect("ecommerce.db")
cur = conn.cursor()

cur.executescript("""
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,
    product_name  TEXT NOT NULL,
    category_id   INTEGER REFERENCES categories(category_id),
    price         REAL NOT NULL,
    cost          REAL NOT NULL
);

CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    first_name    TEXT NOT NULL,
    last_name     TEXT NOT NULL,
    email         TEXT UNIQUE NOT NULL,
    city          TEXT NOT NULL,
    state         TEXT NOT NULL,
    signup_date   DATE NOT NULL
);

CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER REFERENCES customers(customer_id),
    order_date    DATE NOT NULL,
    status        TEXT NOT NULL,
    shipping_cost REAL NOT NULL
);

CREATE TABLE order_items (
    item_id       INTEGER PRIMARY KEY,
    order_id      INTEGER REFERENCES orders(order_id),
    product_id    INTEGER REFERENCES products(product_id),
    quantity      INTEGER NOT NULL,
    unit_price    REAL NOT NULL
);
""")

categories = [
    (1, "Electronics"), (2, "Clothing"), (3, "Home & Kitchen"),
    (4, "Sports"), (5, "Books")
]
cur.executemany("INSERT INTO categories VALUES (?,?)", categories)

products = [
    (1,  "Wireless Headphones",   1, 79.99,  35.00),
    (2,  "Bluetooth Speaker",     1, 49.99,  18.00),
    (3,  "USB-C Hub",             1, 34.99,  12.00),
    (4,  "Mechanical Keyboard",   1, 129.99, 55.00),
    (5,  "Running Shoes",         2, 89.99,  32.00),
    (6,  "Yoga Pants",            2, 44.99,  14.00),
    (7,  "Winter Jacket",         2, 149.99, 60.00),
    (8,  "Coffee Maker",          3, 59.99,  22.00),
    (9,  "Air Fryer",             3, 89.99,  38.00),
    (10, "Knife Set",             3, 69.99,  28.00),
    (11, "Yoga Mat",              4, 29.99,  10.00),
    (12, "Resistance Bands",      4, 19.99,   6.00),
    (13, "Water Bottle",          4, 24.99,   8.00),
    (14, "Python Programming",    5, 39.99,  12.00),
    (15, "Data Science Handbook", 5, 44.99,  14.00),
]
cur.executemany("INSERT INTO products VALUES (?,?,?,?,?)", products)

first_names = ["James","Mary","John","Patricia","Robert","Jennifer","Michael","Linda",
               "William","Barbara","David","Susan","Richard","Jessica","Joseph","Sarah",
               "Thomas","Karen","Charles","Lisa","Scott","Emily","Emma","Liam","Olivia"]
last_names  = ["Smith","Johnson","Williams","Brown","Jones","Garcia","Miller","Davis",
               "Wilson","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin",
               "Thompson","Robinson","Clark","Rodriguez","Bamford","Lewis","Lee","Walker"]
cities = [
    ("New York","NY"),("Los Angeles","CA"),("Chicago","IL"),("Houston","TX"),
    ("Phoenix","AZ"),("Philadelphia","PA"),("San Antonio","TX"),("San Diego","CA"),
    ("Dallas","TX"),("San Jose","CA"),("Austin","TX"),("Seattle","WA"),
    ("Boston","MA"),("Denver","CO"),("Miami","FL")
]

customers = []
used_emails = set()
for i in range(1, 201):
    fn = random.choice(first_names)
    ln = random.choice(last_names)
    base = f"{fn.lower()}.{ln.lower()}"
    email = f"{base}{i}@email.com"
    city, state = random.choice(cities)
    signup = datetime(2022, 1, 1) + timedelta(days=random.randint(0, 900))
    customers.append((i, fn, ln, email, city, state, signup.strftime("%Y-%m-%d")))
cur.executemany("INSERT INTO customers VALUES (?,?,?,?,?,?,?)", customers)

statuses = ["completed","completed","completed","completed","completed","returned","cancelled"]
orders = []
order_id = 1
for customer_id in range(1, 201):
    num_orders = random.choices([0,1,2,3,4,5,6,8,10], weights=[5,15,20,20,15,10,8,5,2])[0]
    for _ in range(num_orders):
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 729))
        status = random.choice(statuses)
        shipping = round(random.choice([0.0, 0.0, 4.99, 7.99, 12.99]), 2)
        orders.append((order_id, customer_id, order_date.strftime("%Y-%m-%d"), status, shipping))
        order_id += 1
cur.executemany("INSERT INTO orders VALUES (?,?,?,?,?)", orders)

items = []
item_id = 1
for order in orders:
    oid = order[0]
    num_items = random.choices([1,2,3,4], weights=[50,30,15,5])[0]
    chosen_products = random.sample(products, min(num_items, len(products)))
    for prod in chosen_products:
        qty = random.choices([1,2,3], weights=[70,20,10])[0]
        items.append((item_id, oid, prod[0], qty, prod[3]))
        item_id += 1
cur.executemany("INSERT INTO order_items VALUES (?,?,?,?,?)", items)

conn.commit()
conn.close()
print(f"Done — {len(customers)} customers, {len(orders)} orders, {len(items)} order items")
