require "win32ole"
require "selenium-webdriver"
require 'fileutils'
require 'yajl/json_gem'
require 'pp'

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

  $json = File.read('C:\Users\Nephtiry\workspace\KothosProj\KPdata.json')
  $obj = JSON.parse($json)
 
  def createDir(dir)
  begin
    network=WIN32OLE.new("Wscript.Network")
    username=network.username
    $dirName="C:\\temp\\KothosTest_"+Time.now.strftime("%Y%m%d%H%M%S")
      FileUtils.mkdir_p($dirName)
      FileUtils.mkdir_p($dirName+"\\Screencaps")
      FileUtils.mkdir_p($dirName+"\\Errors")
    return true
  rescue
    puts $obj["DirectFail"]
    return false
  end
  end
  
  def saveImage(dir)
      $driver.save_screenshot($dirName+"\\Screencaps\\Chrome_screen_"+Time.now.strftime("%Y%m%d%H%M%S")+".png")
    end
  $d = "Date - #{Time.now.strftime("%m/%d/%Y-%I:%M%p")}"
  puts $d
  puts $obj["TopLabel"]
   
  def createLog(logType)
    begin
      $logName = ($dirName+"\\KothosTest_"+Time.now.strftime("%Y%m%d%H%M%S")+".log")
      File.open($logName,"w") do |log|
        log.puts $d
        log.puts $obj["TopLabel"]
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
    puts $obj["LogFail"]
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
      $bin.createDir($dirName+"\\Errors\\"+Time.now.strftime("%Y%m%d%H%M%S"))
      $bin.reporting(": Opening the browser... \n",false)
      $driver = Selenium::WebDriver.for :chrome
      $driver.manage.window.maximize
      $driver.get("http://thecityofkothos.com/")
      if $driver.find_element(tag_name: 'img')
      $bin.saveImage("KothosHomepage")
      $bin.reporting(": Verified reached Homepage",false)
      $bin.reporting(": Logged Homepage",false)
      sleep(5)
      else
        $bin.reporting(Time.now.inspect+": WARNING-Failed to log page",true)
        $driver.save_screenshot($dirName+"\\Errors\\Chrome_screen_"+Time.now.strftime("%Y%m%d%H%M%S")+".png")
      end
      for i in 0..6
        obj2 = $obj["PageTitle"]
        log = $obj["log"]
        log2 = $obj["log2"]
        $driver.find_element(:link, "#{obj2[i]}").click
        sleep(5)
        if $driver.find_element(tag_name: 'img')
        $bin.saveImage("#{log2[i]}")
        $bin.reporting(": #{log[i]}",false)
        $bin.reporting(": #{log2[i]}",false)
        $driver.get("http://thecityofkothos.com/")
        else
          $bin.reporting(Time.now.inspect+": WARNING-Failed to log page",true)
        end
      end
    rescue
      puts $obj["PageFail"]
      $driver.save_screenshot($dirName+"\\Errors\\Chrome_screen_"+Time.now.strftime("%Y%m%d%H%M%S")+".png")
  end
  end
end

$Koth=Kothostest.new
$Koth.chrome
$driver.quit