#!/usr/bin/env python
"""
Initialize SQLite database with data from Fake Store API.
This script fetches data from Fake Store API and populates the database.
"""

import json
import sqlite3
import requests
from pathlib import Path


def fetch_data_from_api(base_url: str = "https://fakestoreapi.com") -> dict:
    """Fetch data from Fake Store API."""
    data = {
        "products": [],
        "users": [],
        "carts": []
    }

    try:
        # Fetch products
        print("Fetching products from Fake Store API...")
        response = requests.get(f"{base_url}/products", timeout=30)
        response.raise_for_status()
        data["products"] = response.json()
        print(f"Retrieved {len(data['products'])} products")

        # Fetch users
        print("Fetching users from Fake Store API...")
        response = requests.get(f"{base_url}/users", timeout=30)
        response.raise_for_status()
        data["users"] = response.json()
        print(f"Retrieved {len(data['users'])} users")

        # Fetch carts
        print("Fetching carts from Fake Store API...")
        response = requests.get(f"{base_url}/carts", timeout=30)
        response.raise_for_status()
        data["carts"] = response.json()
        print(f"Retrieved {len(data['carts'])} carts")

    except requests.RequestException as e:
        print(f"Error fetching data from API: {e}")
        return None

    return data


def create_database_schema(conn: sqlite3.Connection):
    """Create database schema."""
    cursor = conn.cursor()

    # Products table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            category TEXT NOT NULL,
            description TEXT,
            image TEXT
        )
    """)

    # Users table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            email TEXT NOT NULL UNIQUE,
            username TEXT NOT NULL UNIQUE,
            password TEXT,
            name TEXT,
            phone TEXT,
            address TEXT
        )
    """)

    # Carts table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS carts (
            id INTEGER PRIMARY KEY,
            user_id INTEGER,
            date TEXT,
            products TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    """)

    conn.commit()
    print("Database schema created successfully")


def populate_database(conn: sqlite3.Connection, data: dict):
    """Populate database with API data."""
    cursor = conn.cursor()

    # Insert products
    print("Inserting products...")
    for product in data["products"]:
        cursor.execute("""
            INSERT OR REPLACE INTO products (id, title, price, category, description, image)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (
            product.get("id"),
            product.get("title"),
            product.get("price"),
            product.get("category"),
            product.get("description"),
            product.get("image")
        ))

    # Insert users
    print("Inserting users...")
    for user in data["users"]:
        name = user.get("name", {})
        address = user.get("address", {})
        cursor.execute("""
            INSERT OR REPLACE INTO users (id, email, username, password, name, phone, address)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            user.get("id"),
            user.get("email"),
            user.get("username"),
            user.get("password"),
            f"{name.get('firstname', '')} {name.get('lastname', '')}",
            user.get("phone"),
            json.dumps(address)
        ))

    # Insert carts
    print("Inserting carts...")
    for cart in data["carts"]:
        cursor.execute("""
            INSERT OR REPLACE INTO carts (id, user_id, date, products)
            VALUES (?, ?, ?, ?)
        """, (
            cart.get("id"),
            cart.get("userId"),
            cart.get("date"),
            json.dumps(cart.get("products", []))
        ))

    conn.commit()
    print("Database populated successfully")


def verify_database(conn: sqlite3.Connection):
    """Verify database has been populated correctly."""
    cursor = conn.cursor()

    cursor.execute("SELECT COUNT(*) FROM products")
    product_count = cursor.fetchone()[0]
    print(f"Products in database: {product_count}")

    cursor.execute("SELECT COUNT(*) FROM users")
    user_count = cursor.fetchone()[0]
    print(f"Users in database: {user_count}")

    cursor.execute("SELECT COUNT(*) FROM carts")
    cart_count = cursor.fetchone()[0]
    print(f"Carts in database: {cart_count}")

    return product_count > 0 and user_count > 0


def main():
    """Main function to initialize database."""
    db_path = Path("resources/test_database.db")
    db_path.parent.mkdir(parents=True, exist_ok=True)

    print(f"Initializing database at: {db_path}")

    # Fetch data from API
    data = fetch_data_from_api()
    if not data:
        print("Failed to fetch data from API. Using sample data...")
        data = get_sample_data()

    # Create database connection
    conn = sqlite3.connect(db_path)

    try:
        # Create schema
        create_database_schema(conn)

        # Populate database
        populate_database(conn, data)

        # Verify
        if verify_database(conn):
            print("\nDatabase initialization completed successfully!")
        else:
            print("\nWarning: Database may not have been populated correctly.")

    except Exception as e:
        print(f"Error during database initialization: {e}")
    finally:
        conn.close()


def get_sample_data() -> dict:
    """Get sample data if API fetch fails."""
    return {
        "products": [
            {
                "id": 1,
                "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                "price": 109.95,
                "category": "men's clothing",
                "description": "Your perfect pack for everyday use and walks in the forest.",
                "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
            },
            {
                "id": 2,
                "title": "Mens Casual Premium Slim Fit T-Shirts",
                "price": 22.3,
                "category": "men's clothing",
                "description": "Slim-fitting style, contrast raglan long sleeve.",
                "image": "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"
            },
            {
                "id": 3,
                "title": "Mens Cotton Jacket",
                "price": 55.99,
                "category": "men's clothing",
                "description": "great outerwear jackets for Spring/Autumn/Winter.",
                "image": "https://fakestoreapi.com/img/71li-ujdtUL._AC_UX679_.jpg"
            },
            {
                "id": 4,
                "title": "Mens Casual Slim Fit",
                "price": 15.99,
                "category": "men's clothing",
                "description": "The color could be slightly different from the picture.",
                "image": "https://fakestoreapi.com/img/71YXzoO-uL._AC_UY679_.jpg"
            },
            {
                "id": 5,
                "title": "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
                "price": 695.0,
                "category": "jewelery",
                "description": "From our Legends Collection, the Naga was inspired by the mythical water dragon.",
                "image": "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg"
            },
            {
                "id": 6,
                "title": "Solid Gold Petite Micropave Ring",
                "price": 168.0,
                "category": "jewelery",
                "description": "Satisfaction Guaranteed. Return or exchange any order within 30 days.",
                "image": "https://fakestoreapi.com/img/61sbMi1GLJL._AC_UL640_QL65_ML3_.jpg"
            }
        ],
        "users": [
            {
                "id": 1,
                "email": "john@example.com",
                "username": "johnd",
                "password": "m38rmF$",
                "name": {"firstname": "John", "lastname": "Doe"},
                "phone": "1-570-236-7033",
                "address": {"city": "kilcoole", "street": "new road", "number": 7682, "zipcode": "12926-3874"}
            },
            {
                "id": 2,
                "email": "janette@example.com",
                "username": "janetteweaver",
                "password": "g4lLSx",
                "name": {"firstname": "Janette", "lastname": "Weaver"},
                "phone": "1-539-864-7571",
                "address": {"city": "Elwood", "street": "Jadyn view", "number": 4289, "zipcode": "32411-2387"}
            },
            {
                "id": 3,
                "email": "derek@example.com",
                "username": "derek",
                "password": "jR7QpF",
                "name": {"firstname": "derek", "lastname": "Zulauf"},
                "phone": "1-243-636-0180",
                "address": {"city": "Skilesburgh", "street": "Ricky Curve", "number": 305, "zipcode": "25201"}
            }
        ],
        "carts": [
            {
                "id": 1,
                "userId": 1,
                "date": "2020-03-02T00:00:00.000Z",
                "products": [{"productId": 1, "quantity": 2}]
            },
            {
                "id": 2,
                "userId": 2,
                "date": "2020-03-01T00:00:00.000Z",
                "products": [{"productId": 3, "quantity": 1}, {"productId": 4, "quantity": 3}]
            },
            {
                "id": 3,
                "userId": 3,
                "date": "2020-03-03T00:00:00.000Z",
                "products": [{"productId": 5, "quantity": 1}]
            }
        ]
    }


if __name__ == "__main__":
    main()
