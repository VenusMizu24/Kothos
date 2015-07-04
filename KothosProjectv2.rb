require "win32ole"
require "selenium-webdriver"
require 'fileutils'

#wait = Selenium::WebDriver::Wait.new
$d = Time.now.strftime("%m/%d/%Y-%I:%M%p")
$label = "Date: #{$d}
Version: 1.0
Logfile: Kothos Project
Programmer: Nephtiry Bailey

"

class Reporting
=begin
  To use the reporting function you must provide the text that will go into the file.
  To use the create directory function (createDir) you must provide the name of the directory.
  To use the create log function (createLog), you must provide a name for the log.
  You must run these functions in the following order:
    1) createDir (createLog needs the directory and reporting needs createLog)
    2) createLog (reporting needs the log file to have been created
    3) reporting (once the directory and log have been created you can write to the log
=end


 
  def createDir(dir)
  begin
    network=WIN32OLE.new("Wscript.Network")
    username=network.username
    $dirName="C:\\temp\\KothosTest_"+Time.now.strftime("%Y%m%d%H%M%S")
      FileUtils.mkdir_p($dirName)
      FileUtils.mkdir_p($dirName+"\\Screencaps")
    return true
  rescue
    puts "Failed to create directory"
    return false
  end
  end
  
  def saveImage(dir)
      $driver.save_screenshot($dirName+"\\Screencaps\\Chrome_screen_"+Time.now.strftime("%Y%m%d%H%M%S")+".png")
    end
    
  def createLog(logType)
    begin
      $logName = ($dirName+"\\KothosTest_"+Time.now.strftime("%Y%m%d%H%M%S")+".log")
      File.open($logName,"w+")
      return true
    rescue
      puts "Failed creating log"
      return false
    end
  end
=begin
  def reporting(logText)
  begin
      File.open($logName,"w+") do|logit|
        logit.puts "#{$label}"
        logit.puts Time.now.strftime("%Y:%m:%d:%H:%M:%S")+"-#{logText}"
        puts "#{$label}"
        puts Time.now.strftime("%Y:%m:%d:%H:%M:%S")+"-#{logText}"
    return true
  rescue
    puts "Failed to post to log."
    return false
   end
=end
end

class Kothostest < Reporting
  def chrome
    begin
      $bin=Reporting.new
      $bin.createDir(false)
      $bin.createLog(false)
      $driver = Selenium::WebDriver.for :chrome
      $driver.manage.window.maximize
      $driver.get("http://thecityofkothos.com/")
      $bin.saveImage("KothosHomepage")
      #$bin.reporting(Time.now.inspect+": Opened Kothos Homepage",false)
=begin

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
=end
    end
  end
end

$Koth=Kothostest.new
$Koth.chrome