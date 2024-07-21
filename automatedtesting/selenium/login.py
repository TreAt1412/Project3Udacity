# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
import logging as log
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
import datetime
# Start the browser and login with standard_user

def timestamp():
    ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return (ts + '\t')


def login (user, password):
    print( timestamp() + 'Starting the browser...')
    # --uncomment when running in Azure DevOps.
    options = ChromeOptions()
    options.add_argument("--headless") 
    options.add_argument("--no-sandbox") 
    options.add_argument("--disable-dev-shm-usage") 
    options.add_experimental_option("prefs", {"profile.managed_default_content_settings.images": 2}) 
    options.add_argument("--no-sandbox") 
    options.add_argument("--disable-setuid-sandbox") 

    options.add_argument("--remote-debugging-port=9222")  # this

    options.add_argument("--disable-dev-shm-using") 
    options.add_argument("--disable-extensions") 
    options.add_argument("--disable-gpu") 
    options.add_argument("start-maximized") 
    options.add_argument("disable-infobars")
    options.add_argument(r"user-data-dir=.\cookies\\test") 

    service_obj = Service("/usr/bin/chromedriver")
    driver = webdriver.Chrome(service= service_obj, options=options)
    
    print( timestamp() + 'Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    driver.find_element(By.CSS_SELECTOR, "input[id='user-name']").send_keys(user)
    driver.find_element(By.CSS_SELECTOR, "input[id='password']").send_keys(password)
    driver.find_element(By.CSS_SELECTOR, "input[id='login-button']").click()

    path_wrapper = "div[id='page_wrapper'] > div[id='contents_wrapper']"
    path_product = path_wrapper + " > div[id='header_container'] > div[class='header_secondary_container'] > span[class='title']"
    product_logo = driver.find_element(By.CSS_SELECTOR, path_product).text

    assert "Products" in product_logo
    print( timestamp() + "Success login")
    # add item to cart
    print( timestamp() + "Starting add items to cart")

    for i in range(6):
        path_to_item = "a[id='item_" + str(i) + "_title_link']"
        item = driver.find_element(By.CSS_SELECTOR, path_to_item)
        item.find_element(By.XPATH, '../../div[@class="pricebar"]/button').click()

    path_shopping_cart_badge = "div[id='page_wrapper'] > div[id='contents_wrapper'] > div[id='header_container'] > div[class='primary_header'] > div[id='shopping_cart_container'] > a[class='shopping_cart_link'] > span[class='shopping_cart_badge']"
    total_items_text = driver.find_element(By.CSS_SELECTOR, path_shopping_cart_badge).text
    assert '6' == total_items_text
    print( timestamp() + "Success add 6 items to cart")
    
    # remove item from cart

    print( timestamp() + "Starting remove all items from cart")
    path_items = path_wrapper + " > div[id='inventory_container'] > div[id='inventory_container'] > div[class='inventory_list'] > div[class='inventory_item'] " 
    

    for i in range(6):
        path_to_item = "a[id='item_" + str(i) + "_title_link']"
        item = driver.find_element(By.CSS_SELECTOR, path_to_item)
        item.find_element(By.XPATH, '../../div[@class="pricebar"]/button').click()

    path_shopping_cart_badge = "div[id='page_wrapper'] > div[id='contents_wrapper'] > div[id='header_container'] > div[class='primary_header'] > div[id='shopping_cart_container'] > a[class='shopping_cart_link']"
    total_items_text = driver.find_element(By.CSS_SELECTOR, path_shopping_cart_badge).text
    assert '' == total_items_text
    print( timestamp() + "Success remove all items from cart")


login('standard_user', 'secret_sauce')
