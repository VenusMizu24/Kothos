require "win32ole"
require "selenium-webdriver"
require 'rubygems'
require 'fileutils'
require 'json'
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
  $string = $obj["FunctionString"]
  $label = $obj["TopLabel"]
  $timeform = $obj["Time"]
 
  def createDir(dir)
  begin
    network=WIN32OLE.new($string[0])
    username=network.username
    $dirName="C:"+$string[1]+Time.now.strftime($timeform[0])
      FileUtils.mkdir_p($dirName)
      FileUtils.mkdir_p($dirName+$string[2])
      FileUtils.mkdir_p($dirName+$string[3])
    return true
  rescue
  puts $string[4]
    return false
  end
  end
  
  def saveImage(dir)
      $driver.save_screenshot($dirName+$string[5]+Time.now.strftime($timeform[0])+$string[6])
    end
  $d =  "#{$string[7]} #{Time.now.strftime($timeform[1])}"
  puts $d
  puts $label
   
  def createLog(logType)
    begin
      $logName = ($dirName+$string[8]+Time.now.strftime($timeform[0])+$string[9])
      File.open($logName,"w") do |log|
        log.puts $d
        log.puts $label
      end
      return true
    rescue
      puts $string[10]
      return false
    end
  end
  def reporting(logText,ex)
    begin
      File.open($logName,"a") do|logit|
        logit.puts Time.now.strftime($timeform[2])+"-#{logText}"
        puts Time.now.strftime($timeform[2])+"-#{logText}"
      end
    return true
    rescue
    puts $string[11]
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
      $bin.createDir($dirName+$string[12]+Time.now.strftime($timeform[0]))
      $bin.reporting($string[14],false)
      $driver = Selenium::WebDriver.for :chrome
      $driver.manage.window.maximize
      $driver.get("http://thecityofkothos.com/")
      if $driver.find_element(tag_name: 'img')
      $bin.saveImage($string[15])
      $bin.reporting($string[16],false)
      $bin.reporting($string[17],false)
      sleep(5)
      else
        $bin.reporting(Time.now.inspect+$string[18],true)
        $driver.save_screenshot($dirName+$string[19]+Time.now.strftime($timeform[0])+$string[6])
      end
      for i in 0..6
        obj2 = $obj["PageTitle"]
        log = $obj["log"]
        log2 = $obj["log2"]
        $driver.find_element(:link, "#{obj2[i]}").click
        sleep(5)
        if $driver.find_element(tag_name: 'img')
        $bin.saveImage(log2[i])
        $bin.reporting(log[i],false)
        $bin.reporting(log2[i],false)
        $driver.get("http://thecityofkothos.com/")
        else
          $bin.reporting(Time.now.inspect+$string[18],true)
        end
      end
    rescue
      puts $string[13]
      $driver.save_screenshot($dirName+$string[18]+Time.now.strftime($timeform[0])+$string)
  end
  end
end

$Koth=Kothostest.new
$Koth.chrome
$driver.quit