import requests
from bs4 import BeautifulSoup
from urllib.parse import quote

BASE_URL = "https://mdcomputers.in/index.php"

def scrape_products(search_term):
    # grabs products from mdcomputers search page
    url = f"{BASE_URL}?route=product/search&search={quote(search_term)}"
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0;Win64;x64) AppleWebKit/537.36(KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }

    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
    except Exception as error:
        print(f"something went wrong: {error}")
        return[]
    soup = BeautifulSoup(response.text, "html.parser")

    products = []

    # loop through each product card

    for  product_box in soup.select(".product-grid-item"):
        name_tag = product_box.select_one("h3.product-entities-title a")
        price_tag = product_box.select_one(".price .ins .amount")
        
        if name_tag and price_tag:
            products.append({
                "name": name_tag.get_text(strip = True),
                "price": price_tag.get_text(strip = True)
            })
    return products 

def display_products(products):
    # prints out the search results
    if not products:
        print("No products found")
        return 
    
    print("\nProducts Found:\n")
    print("-"*65)

    for number, product in enumerate(products, start=1):
        print(f"{number}. {product['name']}")
        print(f"Selling price: {product['price']}")
        print("-"*65)

def main():
    """Run the product search."""
    search_term = input("Enter the product you want to search: ")
    if not search_term:
        print("Search term cannot be empty")
        return
    print(f"\nSearching MD Computers for: {search_term}")
    products = scrape_products(search_term)
    display_products(products)

if __name__ == "__main__":
    main()