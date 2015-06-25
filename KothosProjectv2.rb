require "win32ole"
require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new
$d = Time.now.strftime("%m/%d/%Y-%I:%M%p")
$label = "Date: #{$d}
Version: 1.0
Logfile: Kothos Project
Programmer: Nephtiry Bailey

"
puts "#{$label}"

driver = Selenium::WebDriver.for :chrome
driver.manage.window.maximize
driver.get("http://thecityofkothos.com/")
driver.find_element(:link, "Chapter Headings").click
driver.get("http://thecityofkothos.com/")
driver.find_element(:link, "Prologue").click
driver.get("http://thecityofkothos.com/")
driver.find_element(:link, "Glossary").click
driver.get("http://thecityofkothos.com/")
driver.find_element(:link, "Creston").click
driver.get("http://thecityofkothos.com/")
driver.find_element(:link, "Bella Tu").click
driver.get("http://thecityofkothos.com/")
driver.find_element(:link, "Tuppa Tu").click
driver.get("http://thecityofkothos.com/")
driver.find_element(:link, "Black & White").click
