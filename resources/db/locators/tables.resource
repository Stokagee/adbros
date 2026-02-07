*** Settings ***
Documentation     Database table names and SQL query fragments

*** Variables ***
# Table Names
${PRODUCTS_TABLE}    products
${USERS_TABLE}       users
${CARTS_TABLE}       carts

# SQL Query Fragments
${PRODUCTS_SELECT_ALL}    SELECT * FROM products
${USERS_SELECT_ALL}       SELECT * FROM users
${CARTS_SELECT_ALL}       SELECT * FROM carts
