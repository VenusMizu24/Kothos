require "win32ole"
require "selenium-webdriver"
require 'fileutils'

#wait = Selenium::WebDriver::Wait.new

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
    
  $d = Time.now.strftime("%m/%d/%Y-%I:%M%p")
  $label = "Date: #{$d}
Version: 1.0
Logfile: Kothos Project
Programmer: Nephtiry Bailey
  
  "
  puts "#{$label}"  
   
  def createLog(logType)
    begin
      $logName = ($dirName+"\\KothosTest_"+Time.now.strftime("%Y%m%d%H%M%S")+".log")
      File.open($logName,"w") do |log|
        log.puts "#{$label}"
      end
      return true
    rescue
      puts "Failed creating log"
      return false
    end
  end
  
  def reporting(logText,ex)
    begin
      File.open($logName,"a") do|logit|
        logit.puts Time.now.strftime("%Y:%m:%d:%H:%M:%S")+"-#{logText}"
        puts Time.now.strftime("%Y:%m:%d:%H:%M:%S")+"-#{logText}"
      end
    return true
    rescue
    puts "Failed to post to log."
    return false
    end
  end
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
      $bin.reporting(Time.now.inspect+": Logged Homepage",false)
    end
      for i in 0..6
        pageTitle = ["Chapter Headings","Prologue","Glossary","Creston","Bella Tu","Tuppa Tu","Black & White"]
        log = ["Logged Chapter Headings","Logged Prologue","Logged Glossary","Logged Creston","Logged Bella Tu","Logged Tuppa Tu","Logged Black & White"]  
        $driver.find_element(:link, "#{pageTitle[i]}").click
        $bin.saveImage("#{log}")
        $bin.reporting(Time.now.inspect+": #{log[i]}",false)
        $driver.get("http://thecityofkothos.com/")
      end
      return true
    rescue
      puts "Failed to log page."
    end
  end

$Koth=Kothostest.new
$Koth.chrome