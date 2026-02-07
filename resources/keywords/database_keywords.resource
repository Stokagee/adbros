*** Settings ***
Documentation     Database initialization and management keywords with error handling
Library           DatabaseLibrary
Library           BuiltIn
Library           OperatingSystem
Resource          ../config/config.resource

*** Keywords ***
Initialize Test Database
    [Documentation]    Initialize database with schema and sample data with error handling
    TRY
        Log    Initializing test database    console=True

        # Create database directory
        VAR    ${db_dir}    ${EXECDIR}${/}resources
        ${exists}=    Run Keyword And Return Status    Directory Should Exist    ${db_dir}
        IF    not ${exists}
            Create Directory    ${db_dir}
            Log    Created database directory: ${db_dir}    console=True
        END

        # Connect to database (creates file if not exists)
        Log    Connecting to database: ${DB_PATH}    console=True
        Connect To Database    ${DB_API}    ${DB_PATH}
        Log    Database connected    console=True

        # Create schema
        Log    Creating database schema    console=True
        Execute Sql String    CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, title TEXT NOT NULL, price REAL NOT NULL, category TEXT NOT NULL, description TEXT, image TEXT)
        Execute Sql String    CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, email TEXT NOT NULL UNIQUE, username TEXT NOT NULL UNIQUE, password TEXT, name TEXT, phone TEXT, address TEXT)
        Execute Sql String    CREATE TABLE IF NOT EXISTS carts (id INTEGER PRIMARY KEY, user_id INTEGER, date TEXT, products TEXT, FOREIGN KEY (user_id) REFERENCES users(id))
        Log    Database schema created    console=True

        # Insert sample products
        Log    Inserting sample products    console=True
        Execute Sql String    INSERT OR REPLACE INTO products (id, title, price, category, description, image) VALUES (1, 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops', 109.95, "men's clothing", 'Your perfect pack for everyday use.', 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg')
        Execute Sql String    INSERT OR REPLACE INTO products (id, title, price, category, description, image) VALUES (2, 'Mens Casual Premium Slim Fit T-Shirts', 22.3, "men's clothing", 'Slim-fitting style.', 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg')
        Execute Sql String    INSERT OR REPLACE INTO products (id, title, price, category, description, image) VALUES (3, 'Mens Cotton Jacket', 55.99, "men's clothing", 'great outerwear jackets.', 'https://fakestoreapi.com/img/71li-ujdtUL._AC_UX679_.jpg')
        Execute Sql String    INSERT OR REPLACE INTO products (id, title, price, category, description, image) VALUES (4, 'Mens Casual Slim Fit', 15.99, "men's clothing", 'The color could be different.', 'https://fakestoreapi.com/img/71YXzoO-uL._AC_UY679_.jpg')
        Execute Sql String    INSERT OR REPLACE INTO products (id, title, price, category, description, image) VALUES (5, 'John Hardy Women''s Legends Naga Gold & Silver Dragon Station Chain Bracelet', 695.0, 'jewelery', 'From our Legends Collection.', 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg')
        Execute Sql String    INSERT OR REPLACE INTO products (id, title, price, category, description, image) VALUES (6, 'Solid Gold Petite Micropave Ring', 168.0, 'jewelery', 'Satisfaction Guaranteed.', 'https://fakestoreapi.com/img/61sbMi1GLJL._AC_UL640_QL65_ML3_.jpg')

        # Insert sample users
        Log    Inserting sample users    console=True
        Execute Sql String    INSERT OR REPLACE INTO users (id, email, username, password, name, phone, address) VALUES (1, 'john@example.com', 'johnd', 'm38rmF$', 'John Doe', '1-570-236-7033', '{"city":"kilcoole","street":"new road"}')
        Execute Sql String    INSERT OR REPLACE INTO users (id, email, username, password, name, phone, address) VALUES (2, 'janette@example.com', 'janetteweaver', 'g4lLSx', 'Janette Weaver', '1-539-864-7571', '{"city":"Elwood","street":"Jadyn view"}')
        Execute Sql String    INSERT OR REPLACE INTO users (id, email, username, password, name, phone, address) VALUES (3, 'derek@example.com', 'derek', 'jR7QpF', 'derek Zulauf', '1-243-636-0180', '{"city":"Skilesburgh","street":"Ricky Curve"}')

        # Insert sample carts
        Log    Inserting sample carts    console=True
        Execute Sql String    INSERT OR REPLACE INTO carts (id, user_id, date, products) VALUES (1, 1, '2020-03-02T00:00:00.000Z', '[{"productId":1,"quantity":2}]')
        Execute Sql String    INSERT OR REPLACE INTO carts (id, user_id, date, products) VALUES (2, 2, '2020-03-01T00:00:00.000Z', '[{"productId":3,"quantity":1},{"productId":4,"quantity":3}]')
        Execute Sql String    INSERT OR REPLACE INTO carts (id, user_id, date, products) VALUES (3, 3, '2020-03-03T00:00:00.000Z', '[{"productId":5,"quantity":1}]')

        Log    Database initialization complete    console=True
    EXCEPT    AS    ${err}
        Fail    Failed to initialize test database | Path: ${DB_PATH} | Error: ${err}
    END

Verify Database Exists
    [Documentation]    Verify database file exists with error handling
    TRY
        File Should Exist    ${DB_PATH}
        Log    Database file exists: ${DB_PATH}    console=True
    EXCEPT    AS    ${err}
        Fail    Database file does not exist | Path: ${DB_PATH} | Error: ${err}
    END
