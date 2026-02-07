*** Settings ***
Documentation     API endpoint paths for Fake Store API

*** Variables ***
# API Endpoints
${PRODUCTS_ENDPOINT}           /products
${USERS_ENDPOINT}              /users
${CARTS_ENDPOINT}              /carts

# Dynamic Endpoints (used with ID)
${PRODUCTS_BY_ID_ENDPOINT}     /products/
${USERS_BY_ID_ENDPOINT}        /users/
${CARTS_BY_ID_ENDPOINT}        /carts/
